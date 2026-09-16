#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v proverif >/dev/null 2>&1; then
    echo "FAIL: proverif is not installed or not available in PATH."
    exit 1
fi

verify_model() {
    local file="$1"
    local expected="$2"
    local path="$ROOT_DIR/$file"

    echo "===== $file ====="

    if ! output="$(proverif "$path" 2>&1)"; then
        echo "FAIL: ProVerif could not analyze $file"
        echo "$output"
        exit 1
    fi

    if grep -Fq "$expected" <<< "$output"; then
        echo "PASS: $expected"
    else
        echo "FAIL: Unexpected verification result for $file"
        echo "Expected:"
        echo "  $expected"
        echo
        echo "Actual ProVerif output:"
        echo "$output"
        exit 1
    fi

    echo
}

verify_model \
    "basic-secrecy/public-message.pv" \
    "RESULT not attacker(secretMsg[]) is true."

verify_model \
    "basic-secrecy/public-channel-leak.pv" \
    "RESULT not attacker(secretMsg[]) is false."

verify_model \
    "basic-secrecy/private-channel.pv" \
    "RESULT not attacker(secretMsg[]) is true."

verify_model \
    "basic-secrecy/tuple-leak.pv" \
    "RESULT not attacker(secretMsg[]) is false."

echo "All basic secrecy verification checks passed."
