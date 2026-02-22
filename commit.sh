#!/usr/bin/env bash
# commit.sh
# ------------------------------------------------------------------------------
# Simple, safe git commit + push helper script
# Features:
#   - Only commits and pushes to the current branch (never touches main/master)
#   - Automatically stages all changes (git add .)
#   - Interactive message input if no argument provided
#   - Colorized output for readability
#   - Safety checks: confirms you're not on main/master before pushing
#   - Shows short git status before and after
#
# Usage:
#   ./commit.sh "Fix login button alignment"
#   ./commit.sh                  # interactive prompt
# ------------------------------------------------------------------------------

set -euo pipefail  # Exit on error, undefined vars, and pipe failures

# Colors for nicer output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ──────────────────────────────────────────────────────────────────────────────
# Helper functions
# ──────────────────────────────────────────────────────────────────────────────

confirm() {
    local prompt="$1"
    read -p "${YELLOW}$prompt (y/N)${NC} " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

is_protected_branch() {
    local branch="$1"
    [[ "$branch" == "main" || "$branch" == "master" ]]
}

# ──────────────────────────────────────────────────────────────────────────────
# Main logic
# ──────────────────────────────────────────────────────────────────────────────

echo -e "${BLUE}=== commit.sh ===${NC}"

# 1. Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

if [ -z "$CURRENT_BRANCH" ]; then
    echo -e "${RED}Error: Not inside a git repository.${NC}"
    exit 1
fi

echo -e "Current branch: ${GREEN}$CURRENT_BRANCH${NC}"

# 2. Safety: warn if on main/master
if is_protected_branch "$CURRENT_BRANCH"; then
    echo -e "${RED}WARNING: You are on protected branch '$CURRENT_BRANCH'${NC}"
    if ! confirm "Are you sure you want to commit & push here?"; then
        echo -e "${YELLOW}Aborted.${NC}"
        exit 0
    fi
fi

# 3. Show what's about to be committed
echo -e "\n${BLUE}Changes to be committed:${NC}"
git status --short

if [ -z "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}Nothing to commit.${NC}"
    exit 0
fi

# 4. Ask for confirmation to stage everything
if ! confirm "Stage ALL changes and continue?"; then
    echo -e "${YELLOW}Aborted.${NC}"
    exit 0
fi

# 5. Stage all changes
echo -e "\n${BLUE}Staging all changes...${NC}"
git add .

# 6. Get commit message
if [ $# -eq 0 ]; then
    echo -e "\n${BLUE}Enter commit message (Ctrl+C to cancel):${NC}"
    read -r msg
    if [ -z "$msg" ]; then
        echo -e "${RED}Empty message. Aborted.${NC}"
        exit 1
    fi
else
    msg="$*"
fi

# 7. Commit
echo -e "\n${BLUE}Committing...${NC}"
git commit -m "$msg" || {
    echo -e "${RED}Commit failed.${NC}"
    exit 1
}

# 8. Push (only if commit succeeded)
echo -e "\n${BLUE}Pushing to origin/$CURRENT_BRANCH...${NC}"
git push origin "$CURRENT_BRANCH" || {
    echo -e "${RED}Push failed. You may need to resolve conflicts.${NC}"
    exit 1
}

# 9. Final status
echo -e "\n${GREEN}Success!${NC}"
echo "Committed and pushed to ${GREEN}$CURRENT_BRANCH${NC}"
echo -e "Message: ${YELLOW}$msg${NC}"
echo ""
git log --oneline -n 1 --decorate

echo -e "\n${BLUE}Done.${NC}"