#!/usr/bin/env bash
set -u

usage() {
  cat <<'EOF'
Usage: app.sh <command> [args]
Commands:
  system-info              Show system information
  check-host <host>        Resolve a host
  check-port <host> <port> Check TCP connectivity
  help                     Show this help
EOF
}

valid_host() { [[ "$1" =~ ^[A-Za-z0-9._:-]+$ ]]; }
valid_port() { [[ "$1" =~ ^[0-9]{1,5}$ ]] && (( 10#$1 >= 1 && 10#$1 <= 65535 )); }

cmd_system_info() {
  local os cpu
  os=$(. /etc/os-release 2>/dev/null && echo "${PRETTY_NAME:-unknown}")
  cpu=$(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d: -f2- | sed 's/^ //')
  echo "Hostname: $(uname -n)"
  echo "User:     $(id -un)"
  echo "OS:       ${os:-unknown}"
  echo "Kernel:   $(uname -r)"
  echo "CPU:      ${cpu:-unknown}"
  echo "Memory:   $(awk '/MemTotal/ {printf "%d MB", $2/1024}' /proc/meminfo)"
}

cmd_check_host() {
  if [[ $# -lt 1 ]]; then echo "Error: check-host requires <host>" >&2; exit 2; fi
  valid_host "$1" || { echo "Error: invalid host" >&2; exit 2; }
  local addr
  addr=$(getent ahosts "$1" 2>/dev/null | awk 'NR==1 {print $1}')
  if [[ -z "$addr" ]]; then echo "Cannot resolve $1" >&2; exit 1; fi
  echo "Resolved $1 -> $addr"
}

cmd_check_port() {
  if [[ $# -lt 2 ]]; then echo "Error: check-port requires <host> <port>" >&2; exit 2; fi
  valid_host "$1" || { echo "Error: invalid host" >&2; exit 2; }
  valid_port "$2" || { echo "Error: port must be 1-65535" >&2; exit 2; }
  if timeout 3 bash -c "exec 3<>/dev/tcp/$1/$2" 2>/dev/null; then
    echo "$1:$2 is open"
  else
    echo "$1:$2 is closed or unreachable" >&2; exit 1
  fi
}

case "${1:-}" in
  system-info) cmd_system_info ;;
  check-host) shift; cmd_check_host "$@" ;;
  check-port) shift; cmd_check_port "$@" ;;
  help|-h|--help) usage ;;
  "") echo "Error: missing command" >&2; usage >&2; exit 2 ;;
  *) echo "Error: unknown command '$1'" >&2; usage >&2; exit 2 ;;
esac

