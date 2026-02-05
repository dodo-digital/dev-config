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
BOLD='\033[1m'
NC='\033[0m'

success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }

# ============================================
# Component Selection
# ============================================
INSTALL_TOOLS=true
INSTALL_HOOKS=true
INSTALL_SKILLS=true
INSTALL_GIT_HOOKS=true
INSTALL_CRON=true
INSTALL_SETTINGS=true

# Parse flags
while [[ $# -gt 0 ]]; do
    case $1 in
        --tools-only)    INSTALL_HOOKS=false; INSTALL_SKILLS=false; INSTALL_GIT_HOOKS=false; INSTALL_CRON=false; INSTALL_SETTINGS=false ;;
        --hooks-only)    INSTALL_TOOLS=false; INSTALL_SKILLS=false; INSTALL_GIT_HOOKS=false; INSTALL_CRON=false; INSTALL_SETTINGS=false ;;
        --skills-only)   INSTALL_TOOLS=false; INSTALL_HOOKS=false; INSTALL_GIT_HOOKS=false; INSTALL_CRON=false; INSTALL_SETTINGS=false ;;
        --no-tools)      INSTALL_TOOLS=false ;;
        --no-hooks)      INSTALL_HOOKS=false ;;
        --no-skills)     INSTALL_SKILLS=false ;;
        --no-git-hooks)  INSTALL_GIT_HOOKS=false ;;
        --no-cron)       INSTALL_CRON=false ;;
        --no-settings)   INSTALL_SETTINGS=false ;;
        -h|--help)
            echo "Usage: ./install.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --tools-only     Only install CLI tools"
            echo "  --hooks-only     Only install Claude Code hooks"
            echo "  --skills-only    Only install Claude Code skills"
            echo "  --no-tools       Skip CLI tool installation"
            echo "  --no-hooks       Skip hook installation"
            echo "  --no-skills      Skip skill installation"
            echo "  --no-git-hooks   Skip global git hook installation"
            echo "  --no-cron        Skip crontab installation"
            echo "  --no-settings    Skip settings.json setup"
            echo "  -h, --help       Show this help"
            exit 0
            ;;
        *) error "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# Ensure directories exist
mkdir -p "$CLAUDE_DIR/hooks" "$CLAUDE_DIR/skills" "$LOCAL_BIN"

# ============================================
# Helper: Replace __HOME__ placeholder in files
# ============================================
template_home() {
    local file="$1"
    if [[ -f "$file" ]]; then
        sed -i "s|__HOME__|$HOME|g" "$file"
    fi
}

# ============================================
# 1. Install Binary Tools
# ============================================
if [[ "$INSTALL_TOOLS" == "true" ]]; then
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
        if command -v cargo &>/dev/null; then
            cargo install beads-cli
        else
            warn "bd requires Rust. Install with: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        fi
    fi

    # Beads Viewer (bv)
    if command -v bv &>/dev/null; then
        success "bv already installed"
    else
        echo "Installing bv..."
        pip install --user beads-viewer 2>/dev/null || pip3 install --user beads-viewer
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
        if command -v cargo &>/dev/null; then
            cargo install cass
        else
            warn "cass requires Rust"
        fi
    fi

    # Oracle (steipete)
    if command -v oracle &>/dev/null; then
        success "oracle already installed"
    else
        echo "Installing oracle..."
        npm install -g @steipete/oracle
        success "oracle installed"
    fi
fi

# ============================================
# 2. Install Hooks
# ============================================
if [[ "$INSTALL_HOOKS" == "true" ]]; then
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
    # Don't copy the generated skill-rules.json — it regenerates per-machine
    success "skill-router hook installed"
fi

# ============================================
# 3. Install Skills
# ============================================
if [[ "$INSTALL_SKILLS" == "true" ]]; then
    echo ""
    echo "--- Installing Skills ---"

    # Install custom skills from this repo
    if [ -d "$SCRIPT_DIR/claude/skills" ] && [ "$(ls -A "$SCRIPT_DIR/claude/skills" 2>/dev/null)" ]; then
        cp -rf "$SCRIPT_DIR/claude/skills/"* "$CLAUDE_DIR/skills/" 2>/dev/null || true
        success "Custom skills installed"
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
fi

# ============================================
# 4. Install Git Hooks (Global)
# ============================================
if [[ "$INSTALL_GIT_HOOKS" == "true" ]]; then
    echo ""
    echo "--- Installing Global Git Hooks ---"

    mkdir -p "$HOME/.config/git/hooks"
    cp -f "$SCRIPT_DIR/git/hooks/pre-commit" "$HOME/.config/git/hooks/"
    chmod +x "$HOME/.config/git/hooks/pre-commit"
    git config --global core.hooksPath "$HOME/.config/git/hooks"
    success "Global pre-commit hook installed (UBS bug scanner)"
fi

# ============================================
# 5. Install Crontab
# ============================================
if [[ "$INSTALL_CRON" == "true" ]]; then
    echo ""
    echo "--- Installing Crontab ---"

    if [ -f "$SCRIPT_DIR/crontab.txt" ]; then
        # Resolve __HOME__ placeholders before installing
        EXISTING=$(crontab -l 2>/dev/null || true)
        while IFS= read -r line; do
            # Skip comments and empty lines
            [[ -z "$line" || "$line" =~ ^# ]] && continue
            # Replace placeholder with actual home directory
            resolved_line="${line//__HOME__/$HOME}"
            if [[ -n "$resolved_line" && ! "$EXISTING" =~ "$resolved_line" ]]; then
                (crontab -l 2>/dev/null; echo "$resolved_line") | crontab -
                success "Added cron: ${resolved_line:0:60}..."
            fi
        done < "$SCRIPT_DIR/crontab.txt"
    else
        warn "No crontab.txt found"
    fi
fi

# ============================================
# 6. Configure Settings
# ============================================
if [[ "$INSTALL_SETTINGS" == "true" ]]; then
    echo ""
    echo "--- Configuring Settings ---"

    SETTINGS_FILE="$CLAUDE_DIR/settings.json"

    if [ ! -f "$SETTINGS_FILE" ]; then
        cp "$SCRIPT_DIR/claude/settings.template.json" "$SETTINGS_FILE"
        # Replace __HOME__ placeholder with actual home directory
        template_home "$SETTINGS_FILE"
        success "Created settings.json (paths resolved to $HOME)"
    else
        warn "settings.json already exists - manual merge may be needed"
        echo "    Template at: $SCRIPT_DIR/claude/settings.template.json"
        echo "    Tip: Compare with 'diff $SETTINGS_FILE $SCRIPT_DIR/claude/settings.template.json'"
    fi
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
echo ""
