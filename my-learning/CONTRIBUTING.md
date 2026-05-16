# Contributing to FM-Agent Claude Code Support

Thank you for your interest in contributing to the Claude Code adaptation of FM-Agent!

## About This Contribution

This is an adaptation of [FM-Agent](https://github.com/legendlsf/FM-Agent) that adds support for Claude Code CLI as an alternative to OpenCode.

**Original Project**: https://github.com/legendlsf/FM-Agent  
**License**: Apache License 2.0  
**Authors**: Haoran Ding, Zhaoguo Wang, Haibo Chen

## What Was Changed

### New Files
- `main_claude.py` - Main pipeline adapted for Claude Code CLI
- `run_with_claude.sh` - Startup script with environment setup
- `test_claude_config.sh` - Configuration validation script
- `CLAUDE_CODE_USAGE.md` - Comprehensive usage guide
- `ADAPTATION_SUMMARY.md` - Technical adaptation details
- `CONTRIBUTING.md` - This file

### Modified Files
- `config.py` - Added support for Anthropic API environment variables

### Unchanged Files
- `main.py` - Original OpenCode version (preserved for backward compatibility)
- `src/` - All core modules remain unchanged
- `md/` - All workflow documents remain unchanged
- `LICENSE` - Original Apache 2.0 license

## Key Features

1. **No Breaking Changes**: Original OpenCode functionality is preserved
2. **Parallel Support**: Users can choose between OpenCode and Claude Code
3. **Simplified Installation**: No need for Bun, oh-my-opencode plugin
4. **Environment Flexibility**: Support for custom Anthropic API endpoints

## Testing

Tested with:
- Claude Code CLI (claude command)
- Anthropic API endpoint (https://cc-vibe.com)
- Python 3.12.3
- 1000+ LOC Python project (DataFabric Layer 1 PTI)

All pipeline stages (1-5) working correctly:
- ✅ Stage 1: Initialization
- ✅ Stage 2: Codebase understanding and phases.json generation
- ✅ Stage 3: File list collection
- ✅ Stage 4: Topdown layer generation
- ✅ Stage 5: Spec generation and verification

## How to Use

```bash
# Test configuration
./test_claude_config.sh

# Run FM-Agent with Claude Code
./run_with_claude.sh /path/to/project
```

See `CLAUDE_CODE_USAGE.md` for detailed instructions.

## Submitting to Upstream

If you want to submit this to the original FM-Agent project:

1. Fork https://github.com/legendlsf/FM-Agent
2. Create a feature branch: `git checkout -b feature/claude-code-support`
3. Add your changes
4. Submit a Pull Request with:
   - Clear description of changes
   - Motivation for the feature
   - Testing results
   - Backward compatibility notes

## License Compliance

This contribution complies with Apache License 2.0:
- ✅ Original license and copyright notices retained
- ✅ Modified files clearly marked with change notices
- ✅ NOTICE file preserved (if exists)
- ✅ Attribution to original authors maintained

## Contact

For questions about this adaptation, please open an issue or contact the contributor.

For questions about the original FM-Agent project, please refer to:
- Paper: https://arxiv.org/abs/2604.11556
- Website: http://fm-agent.ai/
- GitHub: https://github.com/legendlsf/FM-Agent
