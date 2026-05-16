#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                     N E X U S   I N S T A L L E R                            ║
# ║           OpenCode Supreme Setup · Next-Gen Installation                    ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
# MIT License · Copyright (c) 2025 OpenCode Supreme Setup Contributors
#
# SYNOPSIS
#     ./install.sh                    # Full interactive installation
#     ./install.sh --turbo            # Fast mode with defaults
#     ./install.sh --theme Matrix     # Custom theme (Matrix/Neon/Fire)
#     ./install.sh --profile minimal  # Minimal installation
#     ./install.sh --non-interactive  # Silent installation
#
# THEMES: Matrix | Neon | Fire | Aurora | Cyber
# PROFILES: minimal | standard | full | custom

# ═══════════════════════════════════════════════════════════════════════════════
# HEADER BLOCK - DO NOT MODIFY
# ═══════════════════════════════════════════════════════════════════════════════
set -o pipefail

# ─────────────────────────────────────────────────────────────────────────────
# REGION: CORE STATE MANAGEMENT
# ─────────────────────────────────────────────────────────────────────────────
declare -A STATE=(
    [TOTAL_TASKS]=0
    [COMPLETED_TASKS]=0
    [FAILED_TASKS]=0
    [CURRENT_TASK]=""
    [THEME]="Neon"
    [PROFILE]="standard"
    [TURBO]=false
    [VERBOSE]=false
    [LOG_FILE]=""
)

declare -A LOG=()

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: THEME ENGINE - Advanced Cyberpunk Palettes
# ═══════════════════════════════════════════════════════════════════════════════
declare -A THEMES=(
    # Matrix Theme
    ["Matrix.primary"]=$'\033[38;5;82m'
    ["Matrix.secondary"]=$'\033[38;5;28m'
    ["Matrix.accent"]=$'\033[38;5;196m'
    ["Matrix.glow"]=$'\033[38;5;46m'
    ["Matrix.bg"]=$'\033[48;5;16m'
    ["Matrix.text"]=$'\033[38;5;82m'
    ["Matrix.dim"]=$'\033[38;5;23m'
    ["Matrix.highlight"]=$'\033[1;38;5;82m'

    # Neon Theme
    ["Neon.primary"]=$'\033[38;5;201m'
    ["Neon.secondary"]=$'\033[38;5;45m'
    ["Neon.accent"]=$'\033[38;5;213m'
    ["Neon.glow"]=$'\033[38;5;231m'
    ["Neon.bg"]=$'\033[48;5;53m'
    ["Neon.text"]=$'\033[38;5;252m'
    ["Neon.dim"]=$'\033[38;5;59m'
    ["Neon.highlight"]=$'\033[1;38;5;201m'

    # Fire Theme
    ["Fire.primary"]=$'\033[38;5;208m'
    ["Fire.secondary"]=$'\033[38;5;196m'
    ["Fire.accent"]=$'\033[38;5;226m'
    ["Fire.glow"]=$'\033[38;5;214m'
    ["Fire.bg"]=$'\033[48;5;52m'
    ["Fire.text"]=$'\033[38;5;254m'
    ["Fire.dim"]=$'\033[38;5;130m'
    ["Fire.highlight"]=$'\033[1;38;5;208m'

    # Aurora Theme
    ["Aurora.primary"]=$'\033[38;5;147m'
    ["Aurora.secondary"]=$'\033[38;5;159m'
    ["Aurora.accent"]=$'\033[38;5;223m'
    ["Aurora.glow"]=$'\033[38;5;255m'
    ["Aurora.bg"]=$'\033[48;5;54m'
    ["Aurora.text"]=$'\033[38;5;251m'
    ["Aurora.dim"]=$'\033[38;5;60m'
    ["Aurora.highlight"]=$'\033[1;38;5;147m'

    # Cyber Theme
    ["Cyber.primary"]=$'\033[38;5;51m'
    ["Cyber.secondary"]=$'\033[38;5;220m'
    ["Cyber.accent"]=$'\033[38;5;163m'
    ["Cyber.glow"]=$'\033[38;5;123m'
    ["Cyber.bg"]=$'\033[48;5;17m'
    ["Cyber.text"]=$'\033[38;5;250m'
    ["Cyber.dim"]=$'\033[38;5;24m'
    ["Cyber.highlight"]=$'\033[1;38;5;51m'
)

# Color shortcuts
R=$'\033[0m'        # Reset
B=$'\033[1m'        # Bold
D=$'\033[2m'        # Dim
BL=$'\033[5m'       # Blink
U=$'\033[4m'        # Underline

# ─────────────────────────────────────────────────────────────────────────────
# REGION: THEME GETTER FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────
get_color() {
    local key="${STATE[THEME]}.$1"
    echo "${THEMES[$key]:-${THEMES[Neon.$1]}}"
}

C=$'\033[38;5;201m'  # Primary (will be set based on theme)
P=""  # Primary
S=""  # Secondary
A=""  # Accent
G=""  # Glow
T=""  # Text
M=""  # Dim
H=""  # Highlight

apply_theme() {
    P=$(get_color "primary")
    S=$(get_color "secondary")
    A=$(get_color "accent")
    G=$(get_color "glow")
    T=$(get_color "text")
    M=$(get_color "dim")
    H=$(get_color "highlight")
    C=$P
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: TERMINAL CAPABILITIES
# ═══════════════════════════════════════════════════════════════════════════════
init_terminal() {
    # Detect terminal dimensions
    if command -v tput &>/dev/null && [[ -n "$TERM" ]]; then
        TERM_WIDTH=$(tput cols 2>/dev/null || echo 120)
        TERM_HEIGHT=$(tput lines 2>/dev/null || echo 40)
    else
        TERM_WIDTH=120
        TERM_HEIGHT=40
    fi

    # Enable UTF-8
    export LANG="${LANG:-en_US.UTF-8}"
    export LC_ALL="${LC_ALL:-en_US.UTF-8}"

    # Hide cursor during operations
    hide_cursor() { printf '\033[?25l'; }
    show_cursor() { printf '\033[?25h'; }

    trap 'show_cursor' EXIT INT TERM

    # Initialize log file
    STATE[LOG_FILE]="/tmp/nexus_setup_$(date +%Y%m%d_%H%M%S).log"
    : > "${STATE[LOG_FILE]}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: ANIMATED ASCII ART
# ═══════════════════════════════════════════════════════════════════════════════
get_nexus_logo() {
    local frame=${1:-0}
    local rainbow=(
        $P $S $A $G $P $S
    )
    local idx=$((frame % ${#rainbow[@]}))
    local accent="${rainbow[$idx]}"

    cat << 'LOGO'
LOGO
}

get_nexus_logo_full() {
    cat << 'LOGOBLOCK'
${P}╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   ${S}███╗   ███╗ ${P}███████╗${S}██╗ ${P}██████╗ ${S}██████╗ ${A}██████╗ ${G}███████╗${S} ██████╗${P}  █████╗${A}██╗     ${G}██╗███████╗███████╗${P}  ║
║   ${S}████╗ ████║${P}██╔════╝${S}██║${P}██╔══██╗${S}██╔══██╗${A}██╔══██╗${G}██╔════╝${S}██╔════╝${P} ██╔══██╗${A}██║     ${G}██║██╔════╝██╔════╝${P}  ║
║   ${S}██╔████╔██║${P}█████╗  ${S}██║${P}██████╔╝${S}██████╔╝${A}██████╔╝${G}███████╗${S}██║     ${P} ███████║${A}██║     ${G}██║███████╗███████╗${P}  ║
║   ${S}██║╚██╔╝██║${P}██╔══╝  ${S}██║${P}██╔══██╗${S}██╔══██╗${A}██╔══██╗${G}╚════██║${S}██║     ${P} ██╔══██║${A}██║     ${G}██║╚════██║╚════██║${P}  ║
║   ${S}██║ ╚═╝ ██║${P}███████╗${S}██║${P}██║  ██║${S}██║  ██║${A}██████╔╝${G}███████║${S}╚██████╗${P} ██║  ██║${A}╚██████╔╝${G}██║███████║███████║${P}  ║
║   ${S}╚═╝     ╚═╝${P}╚══════╝${S}╚═╝${P}╚═╝  ╚═╝${S}╚═╝  ╚═╝${A}╚═════╝ ${G}╚══════╝${S} ╚═════╝ ${P} ╚═╝  ╚═╝${A} ╚═════╝ ${G}╚═╝╚══════╝╚══════╝${P}  ║
║                                                                           ║
║${M}                    ◈ NEXUS INSTALLER v3.0 · NEXT-GEN CLI ◈${P}                       ║
╚═══════════════════════════════════════════════════════════════════════════╝
LOGOBLOCK
}

get_matrix_rain() {
    local lines=${1:-8}
    local frame=${2:-0}
    local chars="ｦｱｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾗﾘﾙﾚﾛﾜﾝ0123456789"
    local rain=""

    for ((i=0; i<lines; i++)); do
        local offset=$((frame + i))
        local line_len=$(( (TERM_WIDTH - 70) / 2 ))
        [[ $line_len -lt 5 ]] && line_len=5

        local drop=""
        for ((j=0; j<line_len; j++)); do
            local char_idx=$((RANDOM % ${#chars}))
            local char="${chars:char_idx:1}"
            if (( RANDOM % 10 > 7 )); then
                drop+="${G}${char}"
            else
                drop+="${M}${char}"
            fi
        done
        rain+="${M}│${drop}${G}${' ' * 5}${M}│$R\n"
    done
    echo -e "$rain"
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: UI COMPONENTS
# ═══════════════════════════════════════════════════════════════════════════════
draw_progress_bar() {
    local width=40
    local percent=${1:-0}
    local label="${2:-}"

    local filled=$((percent * width / 100))
    local empty=$((width - filled))

    local bar=""
    local colors=("$P" "$S" "$A" "$G")

    for ((i=0; i<filled; i++)); do
        local color_idx=$((i / (width / 4)))
        [[ $color_idx -ge ${#colors[@]} ]] && color_idx=$((${#colors[@]} - 1))
        if (( RANDOM % 10 > 8 )); then
            bar+="${colors[$color_idx]}${B}▓${R}"
        else
            bar+="${colors[$color_idx]}${B}█${R}"
        fi
    done

    bar+="${M}$(printf '░%.0s' $(seq 1 $empty))"

    printf "${M}[$bar${M}] %3d%%${R}" "$percent"
    [[ -n "$label" ]] && printf "  ${T}%s${R}" "$label"
}

draw_header() {
    clear
    local frame=${1:-0}
    local runtime_secs=$(($(date +%s) - START_TIME))

    # Generate animated logo
    local logo
    logo=$(eval "cat << 'LOGOBLOCK'
${P}╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   ${S}███╗   ███╗ ${P}███████╗${S}██╗ ${P}██████╗ ${S}██████╗ ${A}██████╗ ${G}███████╗${S} ██████╗${P}  █████╗${A}██╗     ${G}██╗███████╗███████╗${P}  ║
║   ${S}████╗ ████║${P}██╔════╝${S}██║${P}██╔══██╗${S}██╔══██╗${A}██╔══██╗${G}██╔════╝${S}██╔════╝${P} ██╔══██╗${A}██║     ${G}██║██╔════╝██╔════╝${P}  ║
║   ${S}██╔████╔██║${P}█████╗  ${S}██║${P}██████╔╝${S}██████╔╝${A}██████╔╝${G}███████╗${S}██║     ${P} ███████║${A}██║     ${G}██║███████╗███████╗${P}  ║
║   ${S}██║╚██╔╝██║${P}██╔══╝  ${S}██║${P}██╔══██╗${S}██╔══██╗${A}██╔══██╗${G}╚════██║${S}██║     ${P} ██╔══██║${A}██║     ${G}██║╚════██║╚════██║${P}  ║
║   ${S}██║ ╚═╝ ██║${P}███████╗${S}██║${P}██║  ██║${S}██║  ██║${A}██████╔╝${G}███████║${S}╚██████╗${P} ██║  ██║${A}╚██████╔╝${G}██║███████║███████║${P}  ║
║   ${S}╚═╝     ╚═╝${P}╚══════╝${S}╚═╝${P}╚═╝  ╚═╝${S}╚═╝  ╚═╝${A}╚═════╝ ${G}╚══════╝${S} ╚═════╝ ${P} ╚═╝  ╚═╝${A} ╚═════╝ ${G}╚═╝╚══════╝╚══════╝${P}  ║
║                                                                           ║
║${M}                    ◈ NEXUS INSTALLER v3.0 · NEXT-GEN CLI ◈${P}                       ║
╚═══════════════════════════════════════════════════════════════════════════╝
LOGOBLOCK
")

    echo -e "$logo"

    # Stats bar
    printf "  ${M}◈ Runtime: %02d:%02d  ◈ Tasks: %d/%d  ◈ Failed: %d${R}\n" \
        $((runtime_secs / 60)) $((runtime_secs % 60)) \
        "${STATE[COMPLETED_TASKS]}" \
        "${STATE[TOTAL_TASKS]}" \
        "${STATE[FAILED_TASKS]}"
    printf "  ${M}%s${R}\n" "$(printf '─%.0s' $(seq 1 $((TERM_WIDTH - 4))))"
}

draw_task_line() {
    local name="$1"
    local desc="$2"
    local name_padded=$(printf "%-35s" "$name")
    printf "  ${S}⚡${R}  ${T}%s${R}" "$name_padded"
    [[ -n "$desc" ]] && printf " ${M}» %s${R}" "$desc"
    echo ""
}

draw_success_line() {
    local name="$1"
    local duration="$2"
    local name_padded=$(printf "%-35s" "$name")
    printf "\r  ${P}✓${R}  ${T}%s${R}  ${M}%s${R}\n" "$name_padded" "$duration"
}

draw_fail_line() {
    local name="$1"
    local name_padded=$(printf "%-35s" "$name")
    printf "\r  ${A}✗${R}  ${A}%s${R}  ${M}Failed${R}\n" "$name_padded"
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: INTERACTIVE TUI ELEMENTS
# ═══════════════════════════════════════════════════════════════════════════════
interactive_menu() {
    local title="$1"
    shift
    local options=("$@")
    local count=${#options[@]}
    local current=1
    local selected=0

    draw_menu() {
        local idx=$1
        clear
        echo ""
        printf "  ${P}┌─${M}%${TERM_WIDTH}s${P}─┐\n" | tr ' ' '─'
        printf "  ${P}│${S}  ◈ %s${M}%*s${P}│\n" "$title" $((TERM_WIDTH - 30 - ${#title})) ""
        printf "  ${P}├${M}%${TERM_WIDTH}s${P}┤\n" | tr ' ' '─'

        for ((i=0; i<count; i++)); do
            local opt="${options[i]}"
            local prefix icon suffix
            if (( i == idx )); then
                prefix="► "; icon="${G}◉"; suffix=" ◄"
            else
                prefix="  "; icon="${M}○"; suffix="  "
            fi
            local desc=""
            if [[ "$opt" == *"|"* ]]; then
                desc="${M} - ${opt##*|}"
                opt="${opt%%|*}"
            fi
            printf "  ${P}│${T}%s${icon} %s${suffix}${desc}%*s${P}│\n" "$prefix" "$opt" "$suffix" \
                $((TERM_WIDTH - 50 - ${#opt} - ${#desc})) ""
        done

        printf "  ${P}└─${M}%${TERM_WIDTH}s${P}─┘\n" | tr ' ' '─'
        echo ""
        printf "  ${M}↑↓ Navigate  ↩ Enter Select  Esc Cancel${R}\n"
    }

    draw_menu $current

    while true; do
        read -rsn1 key

        case "$key" in
            $'\e')
                read -rsn1 -t 0.1 k2
                read -rsn1 -t 0.1 k3
                case "$k2$k3" in
                    '[A') (( current = current > 0 ? current - 1 : count - 1 ));;
                    '[B') (( current = current < count - 1 ? current + 1 : 0 ));;
                esac
                draw_menu $current
                ;;
            '')
                selected=$current
                break
                ;;
            'q'|'Q')
                return 255
                ;;
        esac
    done

    return $selected
}

checkbox_list() {
    local title="$1"
    shift
    local items=("$@")
    local count=${#items[@]}
    local current=0
    local selected=false
    local states=()

    for ((i=0; i<count; i++)); do
        states+=(false)
    done

    draw_checkboxes() {
        clear
        echo ""
        printf "  ${P}╭─${M}%${TERM_WIDTH}s${P}─╮\n" | tr ' ' '─'
        printf "  ${P}│${S}  ◈ %s${M}%*s${P}│\n" "$title" $((TERM_WIDTH - 35 - ${#title})) ""
        printf "  ${P}├${M}%${TERM_WIDTH}s${P}┤\n" | tr ' ' '─'

        for ((i=0; i<count; i++)); do
            local item="${items[i]}"
            local check icon prefix
            if ${states[i]}; then
                check="${G}☑"; icon="●"
            else
                check="${M}☐"; icon="○"
            fi
            if (( i == current )); then
                prefix="${P}► ${G}"
            else
                prefix="  ${T}"
            fi
            printf "  ${P}│${prefix}%s${check} %s%*s${P}│\n" "$prefix" "$item" \
                $((TERM_WIDTH - 45 - ${#item})) ""
        done

        printf "  ${P}╰─${M}%${TERM_WIDTH}s${P}─╯\n" | tr ' ' '─'
        echo ""
        printf "  ${M}↑↓ Navigate  Space Toggle  Enter Confirm  Esc Cancel${R}\n"
    }

    draw_checkboxes

    while ! $selected; do
        read -rsn1 key

        case "$key" in
            $'\e')
                read -rsn1 -t 0.1 k2
                read -rsn1 -t 0.1 k3
                case "$k2$k3" in
                    '[A') (( current = current > 0 ? current - 1 : count - 1 ));;
                    '[B') (( current = current < count - 1 ? current + 1 : 0 ));;
                esac
                draw_checkboxes
                ;;
            ' ')
                states[current]=$(${states[current]:-false} && echo false || echo true)
                draw_checkboxes
                ;;
            '')
                selected=true
                ;;
            'q'|'Q')
                return 255
                ;;
        esac
    done

    printf '%s\n' "${states[@]}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: LOGGING SYSTEM
# ═══════════════════════════════════════════════════════════════════════════════
log() {
    local level="${1:-INFO}"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S.000')
    local entry="[$timestamp] [$level] $message"

    LOG+=("$entry")
    echo "$entry" >> "${STATE[LOG_FILE]}"

    if ${STATE[VERBOSE]}; then
        local color
        case "$level" in
            ERROR) color="$A" ;;
            WARN)  color="$S" ;;
            SUCCESS) color="$P" ;;
            *) color="$T" ;;
        esac
        printf "  ${M}[$timestamp]${R} ${color}$message${R}\n"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: TASK EXECUTION ENGINE
# ═══════════════════════════════════════════════════════════════════════════════
declare -a SPINNERS=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
FRAME=0

execute_task() {
    local name="$1"
    local cmd="$2"
    local critical="${3:-false}"
    local quiet="${4:-false}"

    STATE[TOTAL_TASKS]=$((STATE[TOTAL_TASKS] + 1))
    STATE[CURRENT_TASK]="$name"

    if [[ "$cmd" == *"|"* ]] || [[ "$cmd" == *"&&"* ]] || [[ "$cmd" == *"||"* ]]; then
        # Complex command - wrap in bash
        local tmp=$(mktemp)
        hide_cursor
        printf "  ${S}⚡${R}  %-35s" "$name"

        bash -c "$cmd" >"$tmp" 2>&1 &
        local pid=$!
        local i=0
        local start=$(date +%s)

        while kill -0 $pid 2>/dev/null; do
            if ! $quiet; then
                printf "\r  ${S}%s${R}  %-35s ${M}%ds${R}" \
                    "${SPINNERS[i % 10]}" "$name" $(($(date +%s) - start))
            fi
            sleep 0.05
            ((i++))
        done

        wait $pid
        local rc=$?
        local duration=$(($(date +%s) - start))
        cat "$tmp" >> "${STATE[LOG_FILE]}" 2>/dev/null
        rm -f "$tmp"
        show_cursor

        if (( rc == 0 )); then
            STATE[COMPLETED_TASKS]=$((STATE[COMPLETED_TASKS] + 1))
            if ! $quiet; then
                printf "\r  ${P}✓${R}  %-35s ${M}%ds${R}\n" "$name" "$duration"
            fi
            return 0
        else
            log "ERROR" "$name failed with exit code $rc"
            STATE[FAILED_TASKS]=$((STATE[FAILED_TASKS] + 1))
            if ! $quiet; then
                printf "\r  ${A}✗${R}  %-35s ${M}Failed${R}\n" "$name"
            fi
            if $critical; then
                return 1
            fi
            return 0
        fi
    else
        # Simple command
        local tmp=$(mktemp)
        hide_cursor
        printf "  ${S}⚡${R}  %-35s" "$name"

        eval "$cmd" >"$tmp" 2>&1 &
        local pid=$!
        local i=0
        local start=$(date +%s)

        while kill -0 $pid 2>/dev/null; do
            if ! $quiet; then
                printf "\r  ${S}%s${R}  %-35s ${M}%ds${R}" \
                    "${SPINNERS[i % 10]}" "$name" $(($(date +%s) - start))
            fi
            sleep 0.05
            ((i++))
        done

        wait $pid
        local rc=$?
        local duration=$(($(date +%s) - start))
        cat "$tmp" >> "${STATE[LOG_FILE]}" 2>/dev/null
        rm -f "$tmp"
        show_cursor

        if (( rc == 0 )); then
            STATE[COMPLETED_TASKS]=$((STATE[COMPLETED_TASKS] + 1))
            if ! $quiet; then
                printf "\r  ${P}✓${R}  %-35s ${M}%ds${R}\n" "$name" "$duration"
            fi
            return 0
        else
            log "ERROR" "$name failed with exit code $rc"
            STATE[FAILED_TASKS]=$((STATE[FAILED_TASKS] + 1))
            if ! $quiet; then
                printf "\r  ${A}✗${R}  %-35s ${M}Failed${R}\n" "$name"
            fi
            if $critical; then
                return 1
            fi
            return 0
        fi
    fi
}

execute_task_check() {
    local name="$1"
    local check_cmd="$2"
    local install_cmd="$3"
    local critical="${4:-false}"

    # Check if already installed
    if eval "$check_cmd" &>/dev/null; then
        STATE[TOTAL_TASKS]=$((STATE[TOTAL_TASKS] + 1))
        STATE[COMPLETED_TASKS]=$((STATE[COMPLETED_TASKS] + 1))
        printf "  ${S}◈${R}  %-35s ${M}(already installed)${R}\n" "$name"
        return 0
    fi

    # Execute installation
    execute_task "$name" "$install_cmd" "$critical"
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: STATUS MESSAGES
# ═══════════════════════════════════════════════════════════════════════════════
status() {
    local msg="$1"
    local type="${2:-INFO}"

    local icon
    case "$type" in
        SUCCESS) icon="${P}⚡" ;;
        ERROR)   icon="${A}⚠" ;;
        WARN)     icon="${S}⚡" ;;
        INFO)     icon="${M}◆" ;;
        *)        icon="${T}•" ;;
    esac

    printf "  %s  %s%s%s\n" "$icon" "$T" "$msg" "$R"
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: PACKAGE MANIFEST
# ═══════════════════════════════════════════════════════════════════════════════
declare -A MANIFEST=(
    [core]="Node.js 18+ command -v node && node --version | grep -qE 'v(1[89]|[2-9][0-9])' ; bash -c 'command -v node && node --version | grep -qE \"v(1[89]|[2-9][0-9])\"'
PowerShell 7+ command -v pwsh && pwsh --version | grep -qE '7|8 ; [[ \${BASH_VERSINFO[0]} -ge 4 ]]'
"
)

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: INSTALLATION PHASES
# ═══════════════════════════════════════════════════════════════════════════════
phase_prerequisites() {
    draw_header
    echo ""
    status "Checking Prerequisites" "INFO"
    echo ""

    execute_task_check "Node.js 18+" \
        "command -v node && node --version | grep -qE 'v(1[89]|[2-9][0-9])'" \
        "command -v node && node --version | grep -qE 'v(1[89]|[2-9][0-9])'"

    execute_task_check "Bash 4+" \
        "[[ \${BASH_VERSINFO[0]} -ge 4 ]]" \
        "[[ \${BASH_VERSINFO[0]} -ge 4 ]]"

    echo ""
}

phase_runtime() {
    draw_header
    echo ""
    status "Installing Runtime Environment" "INFO"
    echo ""

    execute_task_check "opencode-ai" \
        "command -v opencode" \
        "npm install -g opencode-ai@latest"

    execute_task_check "bun runtime" \
        "command -v bun" \
        "command -v bun || npm install -g bun"

    execute_task_check "openskills CLI" \
        "command -v openskills" \
        "npm install -g openskills"

    echo ""
}

phase_orchestrator() {
    draw_header
    echo ""
    status "Installing oh-my-openagent Orchestrator" "INFO"
    echo ""

    execute_task "oh-my-openagent" \
        "bunx oh-my-openagent install --no-tui --skip-auth 2>&1 || bunx oh-my-openagent install --no-tui --claude=no --gemini=no --copilot=no --opencode-go=yes --skip-auth 2>&1"

    echo ""
}

phase_plugins() {
    draw_header
    echo ""
    status "Installing OpenCode Plugins" "INFO"
    echo ""

    local plugins=(
        "opencode-snippets|text expansion"
        "opencode-snip|60-90% token savings"
        "opencode-notify|OS notifications"
        "opencode-mem|persistent vector memory"
        "opencode-quota|token + cost tracking"
        "opencode-background-agents|async delegation"
        "opencode-worktree|isolated git worktrees"
        "opencode-dynamic-context-pruning|auto context pruning"
        "opencode-smart-title|smart session titles"
        "ocwatch|visual dashboard :3000"
    )

    for entry in "${plugins[@]}"; do
        local pkg="${entry%%|*}"
        local desc="${entry##*|}"
        execute_task "$pkg" "npm install -g $pkg 2>&1 || true"
    done

    echo ""
}

phase_skills() {
    draw_header
    echo ""
    status "Installing OpenSkills Collection" "INFO"
    echo ""

    execute_task "anthropics/skills" "npx openskills install anthropics/skills -y 2>&1 || true"
    execute_task "mattpocock/skills" "npx openskills install mattpocock/skills -y 2>&1 || true"
    execute_task "JuliusBrussee/caveman" "npx openskills install JuliusBrussee/caveman -y 2>&1 || true"
    execute_task "safishamsi/graphify" "npx openskills install safishamsi/graphify -y 2>&1 || true"
    execute_task "nexu-io/open-design" "npx openskills install nexu-io/open-design -y 2>&1 || true"

    echo ""
}

phase_devtools() {
    draw_header
    echo ""
    status "Installing Developer Tools" "INFO"
    echo ""

    execute_task "comment-checker" "npm install -g @code-yeongyu/comment-checker 2>&1 || true"
    execute_task "ast-grep" "npm install -g @ast-grep/cli 2>&1 || true"
    execute_task "GitHub CLI" "command -v gh && true || { command -v brew && brew install gh; } || { command -v apt && sudo apt install -y gh; } || true"

    echo ""
}

phase_config() {
    draw_header
    echo ""
    status "Synchronizing Configuration" "INFO"
    echo ""

    local conf="$HOME/.config/opencode"
    local conf_url="https://raw.githubusercontent.com/skeletorflet/opencode-supreme-setup/master/config"
    local repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || echo "")"

    mkdir -p "$conf"

    if [[ -d "$repo_dir/config" ]]; then
        execute_task "Sync local config" "cp -r \"$repo_dir/config/\"* \"$conf/\""
    else
        execute_task "opencode.json" "curl -fsSL \"$conf_url/opencode.json\" -o \"$conf/opencode.json\" 2>&1 || true"
        execute_task "oh-my-openagent.json" "curl -fsSL \"$conf_url/oh-my-openagent.json\" -o \"$conf/oh-my-openagent.json\" 2>&1 || true"
        execute_task "AGENTS.md" "curl -fsSL \"$conf_url/AGENTS.md\" -o \"$conf/AGENTS.md\" 2>&1 || true"
    fi

    echo ""
}

phase_extras() {
    draw_header
    echo ""
    status "Installing Optional Enhancements" "INFO"
    echo ""

    if [[ "${STATE[TURBO]}" == "false" ]]; then
        if ask "Install agentsys (49 agents, 20 plugins)?" n; then
            execute_task "agentsys" "npm install -g agentsys 2>&1 || true"
        fi

        if ask "Install firecrawl?" n; then
            execute_task "firecrawl" "npm install -g firecrawl-cli 2>&1 || npm install -g @firecrawl/firecrawl-cli 2>&1 || true"
        fi

        if ask "Install WakaTime?" n; then
            execute_task "wakatime" "npm install -g opencode-wakatime 2>&1 || true"
        fi

        if ask "Install themes (ayu/lavi/moonlight/poimandres)?" n; then
            execute_task "opencode-ayu-theme" "npm install -g opencode-ayu-theme 2>&1 || true"
            execute_task "lavi" "npm install -g lavi 2>&1 || true"
            execute_task "opencode-moonlight-theme" "npm install -g opencode-moonlight-theme 2>&1 || true"
            execute_task "opencode-ai-poimandres-theme" "npm install -g opencode-ai-poimandres-theme 2>&1 || true"
        fi
    fi

    echo ""
}

ask() {
    local q="$1"
    local default="${2:-y}"

    local hint
    if [[ "$default" == "y" ]]; then
        hint="${G}${B}Y${R}${M}/n${R}"
    else
        hint="${M}y/${R}${A}${B}N${R}"
    fi

    printf "\n  ${S}?${R}  ${T}%-40s${R}  ${M}[${R}%b${M}]${R}  " "$q" "$hint"

    local ans
    IFS= read -r ans
    [[ -z "$ans" ]] && ans="$default"
    [[ "$ans" =~ ^[Yy] ]]
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: COMPLETION SCREEN
# ═══════════════════════════════════════════════════════════════════════════════
show_completion() {
    local success="${1:-true}"
    local duration_secs=$(($(date +%s) - START_TIME))

    clear
    echo ""

    if $success; then
        cat << 'SUCCESS_ART'
SUCCESS_ART
        eval "cat << 'LOGOBLOCK'
${P}╔═══════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                           ║
║        ${G}██████╗ ${P}██████╗ ${S}███████╗${A}███████╗${G}██████╗ ${P}██████╗ ${S}███████╗${A}███████╗${G}██████╗ ${P}██████╗ ${S}███████╗${A}███████╗      ║
║        ${G}██╔══██╗${P}██╔══██╗${S}╚══███╔╝${A}╚══███╔╝${G}██╔══██╗${P}██╔══██╗${S}╚══███╔╝${A}╚══███╔╝${G}██╔══██╗${P}██╔══██╗${S}╚══███╔╝${A}╚══███╔╝      ║
║        ${G}██████╔╝${P}██████╔╝ ${S}  ███╔╝ ${A}  ███╔╝ ${G}██████╔╝${P}██████╔╝ ${S}  ███╔╝ ${A}  ███╔╝ ${G}██████╔╝${P}██████╔╝ ${S}  ███╔╝ ${A}  ███╔╝       ║
║        ${G}██╔═══╝ ${P}██╔══██╗ ${S}  ███╔╝ ${A}  ███╔╝ ${G}██╔═══╝ ${P}██╔══██╗ ${S}  ███╔╝ ${A}  ███╔╝ ${G}██╔═══╝ ${P}██╔══██╗ ${S}  ███╔╝ ${A}  ███╔╝       ║
║        ${G}██║     ${P}██║  ██║${S}███████╗${A}███████╗${G}██║     ${P}██║  ██║${S}███████╗${A}███████╗${G}██║     ${P}██║  ██║${S}███████╗${A}███████╗      ║
║        ${G}╚═╝     ${P}╚═╝  ╚═╝${S}╚══════╝${A}╚══════╝${G}╚═╝     ${P}╚═╝  ╚═╝${S}╚══════╝${A}╚══════╝${G}╚═╝     ${P}╚═╝  ╚═╝${S}╚══════╝${A}╚══════╝      ║
║                                                                                                           ║
║                                    ◈ Installation Complete ◈                                                     ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════╝
LOGOBLOCK
"
    else
        eval "cat << 'FAIL_ART'
${A}╔═══════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                                           ║
║         ${A}███████╗${S}██╗   ${A}██╗${S}██████╗ ${A}██████╗ ${S}███████╗${A}██████╗ ${S}██╗   ${A}██╗                                           ║
║         ${A}╚══███╔╝${S}╚██╗ ${A}██╔╝${S}██╔══${A}██╗${S}██╔══${A}██╗${S}██╔════╝${A}██╔══${A}██╗${S}██║   ${A}██║                                           ║
║           ${A}███╔╝  ${S} ╚████╔╝ ${A}██████╔╝${S}██████╔╝${A}███████╗${S}██████╔╝${A}██║   ${A}██║                                           ║
║          ${A}███╔╝    ╚██╔╝  ${A}██╔═══╝ ${S}██╔══██╗${A}╚════██║${S}██╔══██╗${A}██║   ${A}██║                                           ║
║         ${A}███████╗${S}  ██║   ${A}██║     ${S}██║  ${A}██║${S}███████╗${A}██║  ${A}██║${S}╚██████╔╝                                           ║
║         ${A}╚══════╝${S}  ╚═╝   ${A}╚═╝     ${S}╚═╝  ${A}╚═╝${S}╚══════╝${A}╚═╝  ${A}╚═╝${S} ╚═════╝                                            ║
║                                                                                                           ║
║                        ◈ Installation Failed - Check Logs Below ◈                                          ║
╚═══════════════════════════════════════════════════════════════════════════════════════════════════╝
FAIL_ART
"
    fi

    echo ""
    printf "  ${M}◈ Installation Summary${R}\n"
    printf "  ${M}%s${R}\n" "$(printf '─%.0s' $(seq 1 60))"
    printf "  ${T}◈ Duration:${M} %02d:%02d${R}\n" $((duration_secs / 60)) $((duration_secs % 60))
    printf "  ${T}◈ Tasks:${M} ${STATE[COMPLETED_TASKS]} completed, ${STATE[FAILED_TASKS]} failed${R}\n"
    printf "  ${T}◈ Log:${M} ${STATE[LOG_FILE]}${R}\n"
    echo ""

    printf "  ${P}◈ Quick Start Commands${R}\n"
    printf "  ${M}%s${R}\n" "$(printf '─%.0s' $(seq 1 60))"
    printf "  ${G}opencode${R}                    ${M}Launch OpenCode${R}\n"
    printf "  ${G}opencode auth login${R}         ${M}Authenticate your account${R}\n"
    printf "  ${G}ocwatch${R}                     ${M}Open visual dashboard (port 3000)${R}\n"
    printf "  ${G}npx openskills sync${R}         ${M}Sync available skills${R}\n"
    echo ""
    printf "  ${S}◈ Repository:${M} https://github.com/skeletorflet/opencode-supreme-setup${R}\n"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# REGION: MAIN ENTRY POINT
# ═══════════════════════════════════════════════════════════════════════════════
main() {
    START_TIME=$(date +%s)

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --turbo)
                STATE[TURBO]=true
                ;;
            --theme)
                STATE[THEME]="$2"
                shift
                ;;
            --profile)
                STATE[PROFILE]="$2"
                shift
                ;;
            --verbose)
                STATE[VERBOSE]=true
                ;;
            --non-interactive)
                STATE[TURBO]=true
                ;;
            --help|-h)
                echo "NEXUS INSTALLER - Advanced CLI Installer"
                echo ""
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --turbo              Fast mode with defaults"
                echo "  --theme THEME        Set theme (Matrix/Neon/Fire/Aurora/Cyber)"
                echo "  --profile PROFILE    Set profile (minimal/standard/full)"
                echo "  --verbose            Verbose logging"
                echo "  --non-interactive    Silent installation"
                echo "  --help, -h           Show this help"
                exit 0
                ;;
        esac
        shift
    done

    # Apply theme
    apply_theme

    # Initialize terminal
    init_terminal

    # Show header
    draw_header 0
    echo ""
    status "Initializing NEXUS Installation Environment" "INFO"
    status "Theme: ${STATE[THEME]}  |  Profile: ${STATE[PROFILE]}  |  Log: ${STATE[LOG_FILE]}" "INFO"
    echo ""
    printf "  ${M}%s${R}\n" "$(printf '─%.0s' $(seq 1 $((TERM_WIDTH - 4))))"

    if ! ${STATE[TURBO]}; then
        echo ""
        read -p "  Press ENTER to continue or Ctrl+C to cancel... " -r
    fi

    # Show profile selection
    if ! ${STATE[TURBO]}; then
        echo ""
        printf "  ${P}┌─${M}%${TERM_WIDTH}s${P}─┐\n" | tr ' ' '─'
        printf "  ${P}│${S}  ◈ SELECT INSTALLATION PROFILE${M}%*s${P}│\n" $((TERM_WIDTH - 45)) ""
        printf "  ${P}├${M}%${TERM_WIDTH}s${P}┤\n" | tr ' ' '─'
        printf "  ${P}│${G}  ▶ ◉  Minimal Install${M}%*s${P}│\n" $((TERM_WIDTH - 38)) ""
        printf "  ${P}│${T}    ○  Standard Install (Recommended)${M}%*s${P}│\n" $((TERM_WIDTH - 50)) ""
        printf "  ${P}│${T}    ○  Full Installation${M}%*s${P}│\n" $((TERM_WIDTH - 38)) ""
        printf "  ${P}│${T}    ○  Custom Selection${M}%*s${P}│\n" $((TERM_WIDTH - 35)) ""
        printf "  ${P}└─${M}%${TERM_WIDTH}s${P}─┘\n" | tr ' ' '─'
        echo ""
        read -p "  Select option (1-4) [2]: " -r choice
        choice="${choice:-2}"
    else
        choice=2
    fi

    # Execute phases based on selection
    local phases=()
    case "$choice" in
        1) phases=(phase_prerequisites phase_runtime phase_orchestrator) ;;
        2) phases=(phase_prerequisites phase_runtime phase_orchestrator phase_plugins phase_skills phase_devtools) ;;
        3) phases=(phase_prerequisites phase_runtime phase_orchestrator phase_plugins phase_skills phase_devtools phase_extras) ;;
        4)
            phases=(phase_prerequisites)
            if ! ${STATE[TURBO]}; then
                if ask "Install Runtime Environment?" y; then phases+=(phase_runtime); fi
                if ask "Install oh-my-openagent?" y; then phases+=(phase_orchestrator); fi
                if ask "Install Plugins?" y; then phases+=(phase_plugins); fi
                if ask "Install Skills?" y; then phases+=(phase_skills); fi
                if ask "Install DevTools?" n; then phases+=(phase_devtools); fi
                if ask "Install Extras?" n; then phases+=(phase_extras); fi
            fi
            ;;
    esac

    # Run phases
    for phase in "${phases[@]}"; do
        $phase
        sleep 0.3
    done

    # Config sync
    phase_config

    # Health check
    status "Running health checks..." "INFO"
    execute_task "oh-my-openagent doctor" "bunx oh-my-openagent doctor 2>&1 || true" false true

    # Show completion
    show_completion $([[ ${STATE[FAILED_TASKS]} -eq 0 ]] && echo true || echo false)
}

# Execute main
main "$@"