#!/usr/bin/env node
/**
 * bgremove.js — Background Removal helper (zero neta-skills dependency)
 *
 * Commands:
 *   node bgremove.js remove <picture_uuid>              → {status, url, task_uuid}
 *   node bgremove.js gen-remove <prompt> [options]      → {status, url, task_uuid, source_uuid}
 *
 * Options for gen-remove:
 *   --char <name>    Character name
 *   --pic  <uuid>    Character picture UUID
 *   --size portrait|landscape|square|tall  (default: portrait)
 *   --style <name>   Style element (repeatable)
 *
 * Token resolved from: NETA_TOKEN env → ~/.openclaw/workspace/.env → clawhouse .env
 */

import { readFileSync } from 'node:fs';
import { homedir }      from 'node:os';
import { resolve }      from 'node:path';

// ── Config ────────────────────────────────────────────────────────────────────

const BASE = 'https://api.talesofai.cn';

function getToken() {
  if (process.env.NETA_TOKEN) return process.env.NETA_TOKEN;
  const envFiles = [
    resolve(homedir(), '.openclaw/workspace/.env'),
    resolve(homedir(), 'developer/clawhouse/.env'),
  ];
  for (const p of envFiles) {
    try {
      const m = readFileSync(p, 'utf8').match(/NETA_TOKEN=(.+)/);
      if (m) return m[1].trim();
    } catch { /* try next */ }
  }
  throw new Error('API token not found. Add it to ~/.openclaw/workspace/.env');
}

const HEADERS = {
  'x-token': getToken(),
  'x-platform': 'nieta-app/web',
  'content-type': 'application/json',
};

async function api(method, path, body) {
  const res = await fetch(BASE + path, {
    method,
    headers: HEADERS,
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  if (!res.ok) throw new Error(`HTTP ${res.status}: ${await res.text()}`);
  return res.json();
}

const log = msg => process.stderr.write(msg + '\n');
const out = data => console.log(JSON.stringify(data));

// ── Helpers ───────────────────────────────────────────────────────────────────

function parseFlags(args) {
  const flags = { _: [] };
  for (let i = 0; i < args.length; i++) {
    if (args[i].startsWith('--')) {
      const key = args[i].slice(2);
      const val = args[i + 1] && !args[i + 1].startsWith('--') ? args[++i] : true;
      flags[key] = flags[key] === undefined ? val : [].concat(flags[key], val);
    } else {
      flags._.push(args[i]);
    }
  }
  return flags;
}

const SIZES = {
  portrait:  { width: 576,  height: 768  },
  landscape: { width: 1024, height: 576  },
  square:    { width: 768,  height: 768  },
  tall:      { width: 576,  height: 1024 },
};

async function pollTask(task_uuid) {
  let warnedSlow = false;
  for (let i = 0; i < 150; i++) {
    await new Promise(r => setTimeout(r, 2000));
    if (!warnedSlow && i >= 14) {
      log('⏳ Still processing, hang tight...');
      warnedSlow = true;
    }
    const result = await api('GET', `/v1/artifact/task/${task_uuid}`);
    if (result.task_status !== 'PENDING' && result.task_status !== 'MODERATION') {
      return result;
    }
  }
  return { task_status: 'TIMEOUT', artifacts: [] };
}

async function removeBackground(pictureUuid) {
  log(`✂️  Removing background from: ${pictureUuid}...`);
  const taskUuid = await api('POST', '/v3/make_face_detailer', {
    source_artifact_uuid: pictureUuid,
    preset_key: '0_null/抠图SEG',
    meta: { entrance: 'PICTURE,PURE,VERSE' },
  });
  const task_uuid = typeof taskUuid === 'string' ? taskUuid : taskUuid?.task_uuid;
  log(`⏳ Removal task: ${task_uuid}`);
  return { task_uuid, result: await pollTask(task_uuid) };
}

// ── Commands ──────────────────────────────────────────────────────────────────

const [,, cmd, ...rawArgs] = process.argv;

// ── remove ────────────────────────────────────────────────────────────────────

if (cmd === 'remove') {
  const pictureUuid = rawArgs[0];
  if (!pictureUuid) throw new Error('Usage: bgremove.js remove <picture_uuid>');

  const { task_uuid, result } = await removeBackground(pictureUuid);
  out({
    status:      result.task_status,
    url:         result.artifacts?.[0]?.url ?? null,
    task_uuid,
    source_uuid: pictureUuid,
  });
}

// ── gen-remove ────────────────────────────────────────────────────────────────

else if (cmd === 'gen-remove') {
  const flags    = parseFlags(rawArgs);
  const prompt   = flags._.join(' ');
  const charName = flags.char ?? null;
  const picUuid  = flags.pic  ?? null;
  const sizeKey  = flags.size ?? 'portrait';
  const styles   = [].concat(flags.style ?? []);

  if (!prompt && !charName) {
    throw new Error('Usage: bgremove.js gen-remove <prompt> [--char name] [--pic uuid] [--size portrait|landscape|square|tall] [--style name]');
  }

  const { width, height } = SIZES[sizeKey] ?? SIZES.portrait;

  // 1. Resolve character vtoken
  const vtokens = [];
  let resolvedChar = null;

  if (charName) {
    log(`🔍 Looking up character: ${charName}...`);
    const search = await api('GET',
      `/v2/travel/parent-search?keywords=${encodeURIComponent(charName)}&parent_type=oc&sort_scheme=exact&page_index=0&page_size=1`);
    resolvedChar = search.list?.find(r => r.type === 'oc');
    if (resolvedChar) {
      vtokens.push({ type: 'oc_vtoken_adaptor', uuid: resolvedChar.uuid, name: resolvedChar.name, value: resolvedChar.uuid, weight: 1 });
      log(`✅ Character resolved: ${resolvedChar.name}`);
    } else {
      log(`⚠️  Character "${charName}" not found — using freetext fallback`);
    }
  }

  for (const style of styles) {
    vtokens.push({ type: 'freetext', value: `/${style}`, weight: 1 });
  }

  let promptText = prompt;
  if (resolvedChar && promptText) {
    promptText = promptText.replace(new RegExp(`@${charName}[,，\\s]*`, 'g'), '').trim();
  }
  if (promptText) vtokens.push({ type: 'freetext', value: promptText, weight: 1 });

  // 2. Generate image
  log(`🎨 Generating image (${width}×${height})...`);
  const genTaskUuid = await api('POST', '/v3/make_image', {
    storyId: 'DO_NOT_USE',
    jobType: 'universal',
    rawPrompt: vtokens,
    width,
    height,
    meta: { entrance: 'PICTURE' },
    ...(picUuid ? { inherit_params: { picture_uuid: picUuid } } : {}),
  });

  const gen_task_uuid = typeof genTaskUuid === 'string' ? genTaskUuid : genTaskUuid?.task_uuid;
  log(`⏳ Generation task: ${gen_task_uuid}`);

  const genResult = await pollTask(gen_task_uuid);
  if (genResult.task_status !== 'SUCCESS') {
    out({ status: genResult.task_status, url: null, gen_task_uuid, source_uuid: null });
    process.exit(0);
  }

  const sourceUuid = genResult.artifacts?.[0]?.uuid ?? gen_task_uuid;
  log(`✅ Image generated! Now removing background...`);

  // 3. Remove background
  const { task_uuid, result } = await removeBackground(sourceUuid);
  out({
    status:        result.task_status,
    url:           result.artifacts?.[0]?.url ?? null,
    task_uuid,
    source_uuid:   sourceUuid,
    gen_task_uuid,
    gen_url:       genResult.artifacts?.[0]?.url ?? null,
  });
}

else {
  process.stderr.write([
    'Usage:',
    '  node bgremove.js remove <picture_uuid>',
    '  node bgremove.js gen-remove <prompt> [--char name] [--pic uuid] [--size portrait|landscape|square|tall] [--style name]',
  ].join('\n') + '\n');
  process.exit(1);
}
