# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-03-08

### Added
- Initial release with WebSocket server support
- Screenshot generation via remote Playwright server
- PDF export functionality
- Test runner for remote browser execution
- Complete Playwright selector documentation
- API reference documentation
- Jest test suite with 16 tests
- GitHub Actions CI/CD pipeline
- Renovate configuration for automated dependency updates

### Features
- `screenshot.js` - Capture screenshots with options (fullPage, viewport, waitForSelector)
- `pdf-export.js` - Generate PDFs from URLs with customizable format
- `test-runner.js` - Execute Playwright tests on remote server
- WebSocket connection support via `PLAYWRIGHT_WS` environment variable

[Unreleased]: https://github.com/first-it-consulting/playwright-skill/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/first-it-consulting/playwright-skill/releases/tag/v1.0.0