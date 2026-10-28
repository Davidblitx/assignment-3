#!/usr/bin/env bash
set -u
cd "$(dirname "$0")/.." || exit 1
APP=./app/app.sh
FAILED=0

t() {
  local name="$1" expected="$2" rc
  shift 2
  "$@" >/dev/null 2>&1
  rc=$?
  if [[ $rc -eq $expected ]]; then echo "PASS: $name"; else echo "FAIL: $name (got $rc, want $expected)"; FAILED=1; fi
}

t "help exits 0" 0 $APP help
t "system-info exits 0" 0 $APP system-info
t "no command exits 2" 2 $APP
t "invalid command exits 2" 2 $APP bogus
t "check-host missing host exits 2" 2 $APP check-host
t "check-host localhost exits 0" 0 $APP check-host localhost
t "check-port missing port exits 2" 2 $APP check-port localhost
t "check-port non-numeric exits 2" 2 $APP check-port localhost abc
t "check-port 0 exits 2" 2 $APP check-port localhost 0
t "check-port 65536 exits 2" 2 $APP check-port localhost 65536
exit $FAILED
