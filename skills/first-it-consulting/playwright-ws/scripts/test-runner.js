const { execSync } = require('child_process');

const PLAYWRIGHT_SERVER = process.env.PLAYWRIGHT_SERVER || 'http://localhost:3000';

function runTests(options = {}) {
  const {
    testPattern = '',
    headed = false,
    debug = false,
    project = '',
    reporter = 'list',
    retries = 0,
    workers = undefined
  } = options;

  // Set server endpoint for Playwright to use remote browser
  const env = {
    ...process.env,
    PLAYWRIGHT_SERVER,
    PW_TEST_CONNECT_WS_ENDPOINT: `${PLAYWRIGHT_SERVER}/ws`
  };

  let cmd = 'npx playwright test';
  
  if (testPattern) cmd += ` ${testPattern}`;
  if (headed) cmd += ' --headed';
  if (debug) cmd += ' --debug';
  if (project) cmd += ` --project=${project}`;
  if (reporter) cmd += ` --reporter=${reporter}`;
  if (retries > 0) cmd += ` --retries=${retries}`;
  if (workers !== undefined) cmd += ` --workers=${workers}`;

  console.log(`Running tests via server: ${PLAYWRIGHT_SERVER}`);
  console.log(`Command: ${cmd}`);
  execSync(cmd, { stdio: 'inherit', cwd: process.cwd(), env });
}

// CLI usage
if (require.main === module) {
  const args = process.argv.slice(2);
  
  const options = {
    testPattern: args.find(a => !a.startsWith('--')) || '',
    headed: args.includes('--headed'),
    debug: args.includes('--debug'),
    project: args.find(a => a.startsWith('--project='))?.split('=')[1],
    reporter: args.find(a => a.startsWith('--reporter='))?.split('=')[1] || 'list',
    retries: parseInt(args.find(a => a.startsWith('--retries='))?.split('=')[1] || '0'),
    workers: args.find(a => a.startsWith('--workers='))?.split('=')[1]
  };
  
  try {
    runTests(options);
  } catch (error) {
    process.exit(1);
  }
}

module.exports = { runTests };
