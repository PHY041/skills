#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[xeonasr-config] %s\n' "$*"
}

warn() {
  printf '[xeonasr-config] WARN: %s\n' "$*" >&2
}

fail() {
  printf '[xeonasr-config] ERROR: %s\n' "$*" >&2
  exit 1
}

timestamp() {
  date +%Y%m%d-%H%M%S
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"
CONFIG_FILE="${CONFIG_FILE:-$OPENCLAW_HOME/openclaw.json}"
UNIT_FILE="${UNIT_FILE:-$HOME/.config/systemd/user/openclaw-gateway.service}"
STT_BASE_URL="${STT_BASE_URL:-http://127.0.0.1:9001}"
STT_API_KEY="${STT_API_KEY:-not-needed}"
STT_MODEL="${STT_MODEL:-Qwen3-ASR-0.6B-INT8_ASYM-OpenVINO}"
RUN_ID="$(timestamp)"

require_cmd node

[[ -f "$CONFIG_FILE" ]] || fail "OpenClaw config not found: $CONFIG_FILE"

detect_stock_root() {
  if [[ -n "${OPENCLAW_GLOBAL_ROOT:-}" ]]; then
    printf '%s\n' "$OPENCLAW_GLOBAL_ROOT"
    return 0
  fi

  if [[ -f "$UNIT_FILE" ]]; then
    local from_unit
    from_unit="$({ sed -n 's#^ExecStart=.* \(/[^ ]*/openclaw\)/dist/index.js.*#\1#p' "$UNIT_FILE" || true; } | head -n 1)"
    if [[ -n "$from_unit" && -d "$from_unit" ]]; then
      printf '%s\n' "$from_unit"
      return 0
    fi
  fi

  for candidate in /usr/lib/node_modules/openclaw /usr/local/lib/node_modules/openclaw; do
    if [[ -d "$candidate/extensions/feishu/src" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  fail "unable to locate stock OpenClaw root; set OPENCLAW_GLOBAL_ROOT explicitly"
}

OPENCLAW_GLOBAL_ROOT="$(detect_stock_root)"
FEISHU_SRC_DIR="$OPENCLAW_GLOBAL_ROOT/extensions/feishu/src"
BOT_FILE="$FEISHU_SRC_DIR/bot.ts"
CHANNEL_FILE="$FEISHU_SRC_DIR/channel.ts"
CONFIG_SCHEMA_FILE="$FEISHU_SRC_DIR/config-schema.ts"
LOCAL_DUP_PLUGIN_DIR="$OPENCLAW_HOME/extensions/feishu"

[[ -f "$BOT_FILE" ]] || fail "stock Feishu bot file not found: $BOT_FILE"
[[ -f "$CHANNEL_FILE" ]] || fail "stock Feishu channel file not found: $CHANNEL_FILE"
[[ -f "$CONFIG_SCHEMA_FILE" ]] || fail "stock Feishu config schema file not found: $CONFIG_SCHEMA_FILE"

log "stock OpenClaw root: $OPENCLAW_GLOBAL_ROOT"

export CONFIG_FILE BOT_FILE CHANNEL_FILE CONFIG_SCHEMA_FILE STT_BASE_URL STT_API_KEY STT_MODEL RUN_ID

node <<'NODE'
const fs = require('node:fs');

const {
  CONFIG_FILE,
  BOT_FILE,
  CHANNEL_FILE,
  CONFIG_SCHEMA_FILE,
  STT_BASE_URL,
  STT_API_KEY,
  STT_MODEL,
  RUN_ID,
} = process.env;

function backup(filePath) {
  const backupPath = `${filePath}.bak.${RUN_ID}`;
  if (!fs.existsSync(backupPath)) {
    fs.copyFileSync(filePath, backupPath);
  }
}

function replaceOnce(text, oldText, newText, label) {
  if (!text.includes(oldText)) {
    throw new Error(`anchor not found for ${label}`);
  }
  return text.replace(oldText, newText);
}

function insertAfter(text, anchor, addition, marker, label) {
  if (text.includes(marker)) {
    return text;
  }
  if (!text.includes(anchor)) {
    throw new Error(`anchor not found for ${label}`);
  }
  return text.replace(anchor, `${anchor}${addition}`);
}

function patchBot() {
  backup(BOT_FILE);
  let text = fs.readFileSync(BOT_FILE, 'utf8');

  text = insertAfter(
    text,
    'import type { ClawdbotConfig, RuntimeEnv } from "openclaw/plugin-sdk";\n',
    'import fs from "node:fs";\nimport path from "node:path";\n',
    'import fs from "node:fs";',
    'bot imports',
  );

  text = insertAfter(
    text,
    'type PermissionError = {\n  code: number;\n  message: string;\n  grantUrl?: string;\n};\n',
    '\ntype STTConfig = {\n  baseUrl: string;\n  apiKey: string;\n  model: string;\n};\n',
    'type STTConfig = {',
    'bot STT type',
  );

  text = insertAfter(
    text,
    'const FEISHU_SCOPE_CORRECTIONS: Record<string, string> = {\n  "contact:contact.base:readonly": "contact:user.base:readonly",\n};\n',
    '\nfunction resolveFeishuSTTConfig(\n  cfg: Record<string, unknown>,\n  feishuCfg?: Record<string, unknown>,\n): STTConfig | null {\n  const channelStt = (feishuCfg as any)?.stt ?? (cfg as any)?.channels?.feishu?.stt;\n  if (channelStt && channelStt.enabled !== false) {\n    const providerId: string = channelStt?.provider || "openai";\n    const providerCfg = (cfg as any)?.models?.providers?.[providerId];\n    const baseUrl: string | undefined = channelStt?.baseUrl || providerCfg?.baseUrl;\n    const apiKey: string | undefined = channelStt?.apiKey || providerCfg?.apiKey;\n    const model: string = channelStt?.model || "whisper-1";\n    if (baseUrl && apiKey) {\n      return { baseUrl: baseUrl.replace(/\\/+$/, ""), apiKey, model };\n    }\n  }\n\n  const audioModelEntry = (cfg as any)?.tools?.media?.audio?.models?.[0];\n  if (audioModelEntry) {\n    const providerId: string = audioModelEntry?.provider || "openai";\n    const providerCfg = (cfg as any)?.models?.providers?.[providerId];\n    const baseUrl: string | undefined = audioModelEntry?.baseUrl || providerCfg?.baseUrl;\n    const apiKey: string | undefined = audioModelEntry?.apiKey || providerCfg?.apiKey;\n    const model: string = audioModelEntry?.model || "whisper-1";\n    if (baseUrl && apiKey) {\n      return { baseUrl: baseUrl.replace(/\\/+$/, ""), apiKey, model };\n    }\n  }\n\n  return null;\n}\n\nfunction getAudioMimeType(audioPath: string, contentType?: string): string {\n  if (contentType?.startsWith("audio/")) {\n    return contentType;\n  }\n\n  const ext = path.extname(audioPath).toLowerCase();\n  switch (ext) {\n    case ".wav":\n      return "audio/wav";\n    case ".mp3":\n      return "audio/mpeg";\n    case ".ogg":\n    case ".opus":\n      return "audio/ogg";\n    case ".m4a":\n      return "audio/mp4";\n    default:\n      return "application/octet-stream";\n  }\n}\n\nfunction isAudioLikeMedia(media: FeishuMediaInfo): boolean {\n  if (media.placeholder === "<media:audio>") {\n    return true;\n  }\n  if (media.contentType?.startsWith("audio/")) {\n    return true;\n  }\n\n  const ext = path.extname(media.path).toLowerCase();\n  return [".ogg", ".opus", ".wav", ".mp3", ".m4a", ".amr", ".silk", ".pcm"].includes(ext);\n}\n\nasync function transcribeFeishuAudio(params: {\n  audioPath: string;\n  contentType?: string;\n  sttCfg: STTConfig;\n}): Promise<string | null> {\n  const { audioPath, contentType, sttCfg } = params;\n  const fileBuffer = fs.readFileSync(audioPath);\n  const fileName = path.basename(audioPath) || "audio";\n  const mime = getAudioMimeType(audioPath, contentType);\n\n  const form = new FormData();\n  form.append("file", new Blob([fileBuffer], { type: mime }), fileName);\n  form.append("model", sttCfg.model);\n\n  const resp = await fetch(`${sttCfg.baseUrl}/audio/transcriptions`, {\n    method: "POST",\n    headers: { Authorization: `Bearer ${sttCfg.apiKey}` },\n    body: form,\n  });\n\n  if (!resp.ok) {\n    const detail = await resp.text().catch(() => "");\n    throw new Error(`STT failed (HTTP ${resp.status}): ${detail.slice(0, 300)}`);\n  }\n\n  const result = await resp.json() as { text?: string };\n  return result.text?.trim() || null;\n}\n\nfunction buildFeishuAudioBodyContent(originalContent: string, transcript?: string | null): string {\n  const normalized = originalContent.trim();\n  const placeholder = inferPlaceholder("audio");\n  const baseContent = !normalized || normalized.startsWith("{") ? placeholder : normalized;\n\n  if (!transcript) {\n    return baseContent;\n  }\n\n  return `${baseContent}\\n[Transcription] ${transcript}`;\n}\n',
    'function resolveFeishuSTTConfig(',
    'bot STT helper block',
  );

  const oldMediaBlock = [
    '    const mediaList = await resolveFeishuMediaList({',
    '      cfg,',
    '      messageId: ctx.messageId,',
    '      messageType: event.message.message_type,',
    '      content: event.message.content,',
    '      maxBytes: mediaMaxBytes,',
    '      log,',
    '      accountId: account.accountId,',
    '    });',
    '    const mediaPayload = buildAgentMediaPayload(mediaList);',
  ].join('\n');

  const newMediaBlock = [
    '    const mediaList = await resolveFeishuMediaList({',
    '      cfg,',
    '      messageId: ctx.messageId,',
    '      messageType: event.message.message_type,',
    '      content: event.message.content,',
    '      maxBytes: mediaMaxBytes,',
    '      log,',
    '      accountId: account.accountId,',
    '    });',
    '    let ctxForAgent = ctx;',
    '    const audioMedia = mediaList.find((media) => isAudioLikeMedia(media));',
    '    if (audioMedia) {',
    '      const sttCfg = resolveFeishuSTTConfig(',
    '        cfg as Record<string, unknown>,',
    '        account.config as Record<string, unknown>,',
    '      );',
    '',
    '      if (!sttCfg) {',
    '        log(`feishu[${account.accountId}]: audio message received but STT is not configured`);',
    '      } else {',
    '        try {',
    '          const transcript = await transcribeFeishuAudio({',
    '            audioPath: audioMedia.path,',
    '            contentType: audioMedia.contentType,',
    '            sttCfg,',
    '          });',
    '          if (transcript) {',
    '            log(`feishu[${account.accountId}]: STT transcript: ${transcript.slice(0, 100)}...`);',
    '            ctxForAgent = {',
    '              ...ctx,',
    '              content: buildFeishuAudioBodyContent(ctx.content, transcript),',
    '            };',
    '          } else {',
    '            log(`feishu[${account.accountId}]: STT returned empty result`);',
    '          }',
    '        } catch (err) {',
    '          log(`feishu[${account.accountId}]: STT failed: ${String(err)}`);',
    '        }',
    '      }',
    '',
    '      if (ctxForAgent === ctx) {',
    '        ctxForAgent = {',
    '          ...ctx,',
    '          content: buildFeishuAudioBodyContent(ctx.content),',
    '        };',
    '      }',
    '    }',
    '    const mediaPayload = buildAgentMediaPayload(mediaList);',
  ].join('\n');

  if (!text.includes('const audioMedia = mediaList.find((media) => isAudioLikeMedia(media));')) {
    text = replaceOnce(text, oldMediaBlock, newMediaBlock, 'bot media STT block');
  }

  if (!text.includes('      ctx: ctxForAgent,')) {
    text = replaceOnce(
      text,
      '    const messageBody = buildFeishuAgentBody({\n      ctx,\n      quotedContent,\n      permissionErrorForAgent,\n    });',
      '    const messageBody = buildFeishuAgentBody({\n      ctx: ctxForAgent,\n      quotedContent,\n      permissionErrorForAgent,\n    });',
      'bot ctxForAgent body',
    );
  }

  fs.writeFileSync(BOT_FILE, text);
}

function patchChannel() {
  backup(CHANNEL_FILE);
  let text = fs.readFileSync(CHANNEL_FILE, 'utf8');

  text = insertAfter(
    text,
    'const secretInputJsonSchema = {\n  oneOf: [\n    { type: "string" },\n    {\n      type: "object",\n      additionalProperties: false,\n      required: ["source", "provider", "id"],\n      properties: {\n        source: { type: "string", enum: ["env", "file", "exec"] },\n        provider: { type: "string", minLength: 1 },\n        id: { type: "string", minLength: 1 },\n      },\n    },\n  ],\n} as const;\n',
    '\nconst sttConfigJsonSchema = {\n  type: "object",\n  additionalProperties: false,\n  properties: {\n    enabled: { type: "boolean" },\n    provider: { type: "string" },\n    baseUrl: { type: "string" },\n    apiKey: { type: "string" },\n    model: { type: "string" },\n  },\n} as const;\n',
    'const sttConfigJsonSchema = {',
    'channel stt schema block',
  );

  if (!text.includes('        stt: sttConfigJsonSchema,')) {
    text = replaceOnce(
      text,
      '        mediaMaxMb: { type: "number", minimum: 0 },\n        renderMode: { type: "string", enum: ["auto", "raw", "card"] },',
      '        mediaMaxMb: { type: "number", minimum: 0 },\n        stt: sttConfigJsonSchema,\n        renderMode: { type: "string", enum: ["auto", "raw", "card"] },',
      'channel top-level stt',
    );
  }

  if (!text.includes('              stt: sttConfigJsonSchema,')) {
    text = replaceOnce(
      text,
      '              webhookHost: { type: "string" },\n              webhookPath: { type: "string" },\n              webhookPort: { type: "integer", minimum: 1 },',
      '              webhookHost: { type: "string" },\n              webhookPath: { type: "string" },\n              webhookPort: { type: "integer", minimum: 1 },\n              stt: sttConfigJsonSchema,',
      'channel account stt',
    );
  }

  fs.writeFileSync(CHANNEL_FILE, text);
}

function patchConfigSchema() {
  backup(CONFIG_SCHEMA_FILE);
  let text = fs.readFileSync(CONFIG_SCHEMA_FILE, 'utf8');

  text = insertAfter(
    text,
    'const FeishuConnectionModeSchema = z.enum(["websocket", "webhook"]);\n',
    '\nconst FeishuSttConfigSchema = z\n  .object({\n    enabled: z.boolean().optional(),\n    provider: z.string().optional(),\n    baseUrl: z.string().optional(),\n    apiKey: z.string().optional(),\n    model: z.string().optional(),\n  })\n  .strict()\n  .optional();\n',
    'const FeishuSttConfigSchema = z',
    'config schema stt block',
  );

  if (!text.includes('  stt: FeishuSttConfigSchema,')) {
    text = replaceOnce(
      text,
      '  reactionNotifications: ReactionNotificationModeSchema,\n  typingIndicator: z.boolean().optional(),\n  resolveSenderNames: z.boolean().optional(),\n};',
      '  reactionNotifications: ReactionNotificationModeSchema,\n  typingIndicator: z.boolean().optional(),\n  resolveSenderNames: z.boolean().optional(),\n  stt: FeishuSttConfigSchema,\n};',
      'config shared stt field',
    );
  }

  fs.writeFileSync(CONFIG_SCHEMA_FILE, text);
}

function patchConfigJson() {
  backup(CONFIG_FILE);
  const raw = fs.readFileSync(CONFIG_FILE, 'utf8');
  const config = JSON.parse(raw);

  config.channels = config.channels || {};

  for (const channelId of ['qqbot', 'feishu']) {
    if (!config.channels[channelId]) {
      continue;
    }
    config.channels[channelId].stt = {
      ...(config.channels[channelId].stt || {}),
      enabled: true,
      provider: config.channels[channelId].stt?.provider || 'custom',
      baseUrl: STT_BASE_URL,
      model: config.channels[channelId].stt?.model || STT_MODEL,
      apiKey: config.channels[channelId].stt?.apiKey || STT_API_KEY,
    };
  }

  config.plugins = config.plugins || {};
  config.plugins.entries = config.plugins.entries || {};
  config.plugins.entries.feishu = {
    ...(config.plugins.entries.feishu || {}),
    enabled: true,
  };

  if (config.plugins.installs && config.plugins.installs.feishu) {
    delete config.plugins.installs.feishu;
    if (Object.keys(config.plugins.installs).length === 0) {
      delete config.plugins.installs;
    }
  }

  fs.writeFileSync(CONFIG_FILE, `${JSON.stringify(config, null, 2)}\n`);
}

patchBot();
patchChannel();
patchConfigSchema();
patchConfigJson();
console.log('stock Feishu plugin and openclaw config patched');
NODE

if [[ -d "$LOCAL_DUP_PLUGIN_DIR" ]]; then
  DUP_BACKUP_DIR="$OPENCLAW_HOME/extensions/feishu.disabled.$RUN_ID"
  mv "$LOCAL_DUP_PLUGIN_DIR" "$DUP_BACKUP_DIR"
  log "moved duplicate local feishu plugin to: $DUP_BACKUP_DIR"
fi

log "OpenClaw integration configuration finished"