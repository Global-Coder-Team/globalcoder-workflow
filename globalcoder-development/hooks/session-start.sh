#!/usr/bin/env bash
# SessionStart hook for globalcoder-development plugin

set -euo pipefail

# Determine plugin root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Check if legacy skills directory exists and build warning
warning_message=""
legacy_skills_dir="${HOME}/.config/superpowers/skills"
if [ -d "$legacy_skills_dir" ]; then
    warning_message="\n\n<important-reminder>IN YOUR FIRST REPLY AFTER SEEING THIS MESSAGE YOU MUST TELL THE USER:⚠️ **WARNING:** globalcoder-development uses Claude Code's skills system. Custom skills in ~/.config/superpowers/skills will not be read. Move custom skills to ~/.claude/skills instead. To make this message go away, remove ~/.config/superpowers/skills</important-reminder>"
fi

# Read using-globalcoder-development content (set -e above will fail-fast if missing)
SKILL_FILE="${PLUGIN_ROOT}/skills/using-globalcoder-development/SKILL.md"
if [ ! -f "$SKILL_FILE" ]; then
    echo "globalcoder-development session-start hook: skill file not found at $SKILL_FILE" >&2
    exit 1
fi
using_skill_content=$(cat "$SKILL_FILE")

# Escape for JSON using bash parameter substitution
# These are single C-level passes - orders of magnitude faster than
# the character-by-character loop this replaces
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"      # Backslashes first
    s="${s//\"/\\\"}"      # Double quotes
    s="${s//$'\n'/\\n}"    # Newlines
    s="${s//$'\r'/\\r}"    # Carriage returns
    s="${s//$'\t'/\\t}"    # Tabs
    printf '%s' "$s"
}

using_skill_escaped=$(escape_for_json "$using_skill_content")
warning_escaped=$(escape_for_json "$warning_message")

# Output context injection as JSON
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\nYou have globalcoder-development skills.\n\n**Below is the full content of your 'globalcoder-development:using-globalcoder-development' skill - your introduction to using skills. For all other skills, use the 'Skill' tool:**\n\n${using_skill_escaped}\n\n${warning_escaped}\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
