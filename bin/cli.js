#!/usr/bin/env node

const { execSync, spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

const packageDir = path.resolve(__dirname, '..');
const installScript = path.join(packageDir, 'install.sh');

// Check if install.sh exists
if (!fs.existsSync(installScript)) {
  console.error('Error: install.sh not found in package');
  process.exit(1);
}

// Pass through all arguments to install.sh
const args = process.argv.slice(2);

// Show help if requested or no args and interactive
if (args.includes('--help') || args.includes('-h')) {
  console.log(`
@dodo-digital/dev-config

Power-user Claude Code config with integrated tooling for agentic development.

Usage:
  npx @dodo-digital/dev-config [options]

Options:
  --help, -h          Show this help message
  --no-hooks          Skip Claude hooks installation
  --no-git            Skip git config installation
  --no-tools          Skip CLI tools installation
  --no-cron           Skip crontab installation
  --hooks-only        Only install Claude hooks
  --git-only          Only install git config
  --tools-only        Only install CLI tools
  --cron-only         Only install crontab

Examples:
  npx @dodo-digital/dev-config              # Install everything
  npx @dodo-digital/dev-config --no-cron    # Skip crontab
  npx @dodo-digital/dev-config --hooks-only # Just Claude hooks

Repository: https://github.com/dodo-digital/dev-config
`);
  process.exit(0);
}

console.log('🚀 Installing dev-config...\n');

// Run install.sh with passed arguments
const child = spawn('bash', [installScript, ...args], {
  stdio: 'inherit',
  cwd: packageDir
});

child.on('close', (code) => {
  if (code === 0) {
    console.log('\n✅ dev-config installed successfully!');
  } else {
    console.error(`\n❌ Installation failed with code ${code}`);
  }
  process.exit(code);
});

child.on('error', (err) => {
  console.error('Failed to run install.sh:', err.message);
  process.exit(1);
});
