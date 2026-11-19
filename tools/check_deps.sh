#!/bin/sh
# Preliminary source-include boundary lint only. It is not a full linkage audit.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
core="$root/src/core"

if [ ! -d "$core" ]; then
    printf '%s\n' 'src/core does not exist yet; boundary lint has no C files to inspect.'
    exit 0
fi

if find "$core" -type f \( -name '*.c' -o -name '*.h' \) \
    -exec grep -nE '^[[:space:]]*#[[:space:]]*include[[:space:]]*[<"][^>"]*(providers/|io/|SpiceUsr[.]h|erfa[.]h|mpfr[.]h)' {} +; then
    printf '%s\n' 'Forbidden direct dependency found in src/core.' >&2
    exit 1
fi

printf '%s\n' 'No forbidden direct includes found. Transitive/linkage constraints still require build review.'
