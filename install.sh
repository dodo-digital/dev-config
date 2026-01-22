#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
LOCAL_BIN="$HOME/.local/bin"

echo "=== Dev Config Installer ==="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }

# Ensure directories exist
mkdir -p "$CLAUDE_DIR/hooks" "$CLAUDE_DIR/skills" "$LOCAL_BIN"

# ============================================
# 1. Install Binary Tools
# ============================================
echo ""
echo "--- Installing Tools ---"

# Ultimate Bug Scanner (ubs)
if command -v ubs &>/dev/null; then
    success "ubs already installed"
else
    echo "Installing ubs..."
    curl -sSL https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh | bash
    success "ubs installed"
fi

# Beads CLI (bd)
if command -v bd &>/dev/null; then
    success "bd (beads) already installed"
else
    echo "Installing bd (beads)..."
    cargo install beads-cli || {
        warn "bd requires Rust. Install with: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    }
fi

# Beads Viewer (bv)
if command -v bv &>/dev/null; then
    success "bv already installed"
else
    echo "Installing bv..."
    pip install --user beads-viewer || pip3 install --user beads-viewer
    success "bv installed"
fi

# Cast Memory (cm)
if command -v cm &>/dev/null; then
    success "cm already installed"
else
    echo "Installing cm..."
    npm install -g @anthropic/cast-memory 2>/dev/null || {
        warn "cm installation failed - check npm config"
    }
fi

# CASS (Agent Session Search)
if command -v cass &>/dev/null; then
    success "cass already installed"
else
    echo "Installing cass..."
    cargo install cass || {
        warn "cass requires Rust"
    }
fi

# Oracle (steipete)
if command -v oracle &>/dev/null; then
    success "oracle already installed"
else
    echo "Installing oracle..."
    npm install -g @steipete/oracle
    success "oracle installed"
fi

# ============================================
# 2. Install Hooks
# ============================================
echo ""
echo "--- Installing Hooks ---"

cp -f "$SCRIPT_DIR/claude/hooks/git_safety_guard.py" "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/git_safety_guard.py"
success "git_safety_guard.py installed"

cp -f "$SCRIPT_DIR/claude/hooks/on-file-write.sh" "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/on-file-write.sh"
success "on-file-write.sh (UBS hook) installed"

cp -f "$SCRIPT_DIR/claude/hooks/cass-index-on-exit.sh" "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR/hooks/cass-index-on-exit.sh"
success "cass-index-on-exit.sh (SessionEnd hook) installed"

# Skill Router (auto-activates skills based on context)
mkdir -p "$CLAUDE_DIR/hooks/skill-router"
cp -f "$SCRIPT_DIR/claude/hooks/skill-router/"*.{sh,py} "$CLAUDE_DIR/hooks/skill-router/" 2>/dev/null || true
chmod +x "$CLAUDE_DIR/hooks/skill-router/"*.sh "$CLAUDE_DIR/hooks/skill-router/"*.py 2>/dev/null || true
success "skill-router hook installed"

# ============================================
# 3. Install Skills
# ============================================
echo ""
echo "--- Installing Skills ---"

# Install custom skills from this repo
if [ -d "$SCRIPT_DIR/claude/skills" ] && [ "$(ls -A "$SCRIPT_DIR/claude/skills" 2>/dev/null)" ]; then
    cp -rf "$SCRIPT_DIR/claude/skills/"* "$CLAUDE_DIR/skills/" 2>/dev/null || true
    success "Custom skills installed (oracle, cass, memory, beads, beads-viewer, vercel-react, vercel-ai-browser)"
else
    warn "No custom skills to install"
fi

# Clone Vercel's official agent-skills if not present
VERCEL_SKILLS_DIR="$HOME/.claude/vendor/vercel-agent-skills"
if [ -d "$VERCEL_SKILLS_DIR" ]; then
    success "Vercel agent-skills already cloned"
    echo "    Updating..."
    (cd "$VERCEL_SKILLS_DIR" && git pull -q) || true
else
    echo "Cloning Vercel agent-skills..."
    mkdir -p "$HOME/.claude/vendor"
    git clone -q https://github.com/vercel-labs/agent-skills.git "$VERCEL_SKILLS_DIR"
    success "Vercel agent-skills cloned to $VERCEL_SKILLS_DIR"
fi

# Symlink Vercel's react-best-practices skill
if [ -d "$VERCEL_SKILLS_DIR/skills/react-best-practices" ]; then
    ln -sf "$VERCEL_SKILLS_DIR/skills/react-best-practices" "$CLAUDE_DIR/skills/react-best-practices-vercel" 2>/dev/null || true
    success "Linked Vercel react-best-practices skill"
fi

# ============================================
# 4. Install Git Hooks (Global)
# ============================================
echo ""
echo "--- Installing Global Git Hooks ---"

mkdir -p "$HOME/.config/git/hooks"
cp -f "$SCRIPT_DIR/git/hooks/pre-commit" "$HOME/.config/git/hooks/"
chmod +x "$HOME/.config/git/hooks/pre-commit"
git config --global core.hooksPath "$HOME/.config/git/hooks"
success "Global pre-commit hook installed (UBS bug scanner)"

# ============================================
# 5. Install Crontab
# ============================================
echo ""
echo "--- Installing Crontab ---"

if [ -f "$SCRIPT_DIR/crontab.txt" ]; then
    # Merge with existing crontab (avoid duplicates)
    EXISTING=$(crontab -l 2>/dev/null || true)
    while IFS= read -r line; do
        if [[ -n "$line" && ! "$EXISTING" =~ "$line" ]]; then
            (crontab -l 2>/dev/null; echo "$line") | crontab -
            success "Added cron: ${line:0:50}..."
        fi
    done < "$SCRIPT_DIR/crontab.txt"
else
    warn "No crontab.txt found"
fi

# ============================================
# 6. Configure Settings
# ============================================
echo ""
echo "--- Configuring Settings ---"

SETTINGS_FILE="$CLAUDE_DIR/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    cp "$SCRIPT_DIR/claude/settings.template.json" "$SETTINGS_FILE"
    success "Created new settings.json"
else
    warn "settings.json already exists - manual merge may be needed"
    echo "    Template at: $SCRIPT_DIR/claude/settings.template.json"
fi

# ============================================
# 7. Enable Plugins
# ============================================
echo ""
echo "--- Plugins ---"
echo "Enable these plugins in Claude Code:"
echo "  - compound-engineering@every-marketplace"
echo "  - agent-pipelines@dodo-digital"
echo ""
echo "Run: claude plugins enable compound-engineering@every-marketplace"
echo "Run: claude plugins enable agent-pipelines@dodo-digital"

# ============================================
# Done
# ============================================
echo ""
echo "=== Installation Complete ==="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.bashrc"
echo "  2. Enable plugins (see above)"
echo "  3. Set OPENAI_API_KEY for oracle (GPT-5 Pro)"
echo "  4. Run 'cass index' to index your coding sessions"
echo "  5. Run 'cm init' to initialize Cast Memory"
