#!/usr/bin/env bash

# Copyright (c) 2026 Sameer Al Sahab
# SPDX-License-Identifier: GPL-3.0-or-later


REQUIRED_DEPS=(
  "cloudflared" "curl" "grep"
)

MISSING_DEPS=()

for dep in "${REQUIRED_DEPS[@]}"; do
  if ! command -v "${dep}" &>/dev/null; then
    MISSING_DEPS+=("${dep}")
  fi
done

if (( ${#MISSING_DEPS[@]} > 0 )); then

  ABORT "Those required tools are missing!! Please install them before proceed."
  printf '    -> %s\n' "${MISSING_DEPS[@]}" >&2
  
  unset REQUIRED_DEPS MISSING_DEPS
  
  return 1 2>/dev/null || exit 1
fi

unset REQUIRED_DEPS MISSING_DEPS
