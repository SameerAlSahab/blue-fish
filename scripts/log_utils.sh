#!/usr/bin/env bash
# Copyright (c) 2026 Sameer Al Sahab
# SPDX-License-Identifier: GPL-3.0-or-later

# Colors
RED='\033[0;31m' 
YELLOW='\033[0;33m' 
WHITE='\033[0m'

# Functions
LOG() { printf '%s\n' "$*" } 

LOGW() { 
printf '%b%s%b\n' "$YELLOW" "$*" "$WHITE" 
}

LOGE() { 
printf '%b%s%b\n' "$RED" "$*" "$WHITE" 
}

ABORT() { 
LOGE "$*" exit 1 
}
