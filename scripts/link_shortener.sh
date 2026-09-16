#!/usr/bin/env bash
# Copyright (c) 2026 Sameer Al Sahab
# SPDX-License-Identifier: GPL-3.0-or-later

SHORTEN_WITH_BITLY() {
  local long_url="$1"
  local bitly_token="${2:-${BITLY_TOKEN}}"

  if [[ -z "${long_url}" ]]; then
    LOGE "Usage: SHORTEN_WITH_BITLY <long_url> [bitly_token]"
    return 1
  fi

  if [[ -z "${bitly_token}" ]]; then
    LOGE "Bitly API Token missing. Set BITLY_TOKEN env var or pass token."
    return 1
  fi

  LOG "Sending URL to Bitly API v4..."

  # Bitly v4 API Request
  local response
  response="$(curl -s -X POST "https://api-ssl.bitly.com/v4/shorten" \
    -H "Authorization: Bearer ${bitly_token}" \
    -H "Content-Type: application/json" \
    -d "{\"long_url\": \"${long_url}\"}")"

  # Extract short URL from JSON response
  local bitly_url
  bitly_url="$(printf '%s' "${response}" | grep -o '"link":"[^"]*' | cut -d'"' -f4)"

  if [[ -z "${bitly_url}" ]]; then
    LOGE "Failed to shorten link via Bitly. Response: ${response}"
    return 1
  fi

  LOG "Bitly Link Generated Successfully!"
  printf '%s\n' "${bitly_url}"
}

# Try with other services
SHORTEN_LINK() {
  local long_url="$1"
  local provider="${2:-is.gd}"
  local masked_url=""

  LOG "Shorting URL via ${provider}..."

  if [[ "${provider}" == "is.gd" ]]; then
    masked_url="$(curl -s "https://is.gd/create.php?format=simple&url=${long_url}")"
  elif [[ "${provider}" == "tinyurl" ]]; then
    masked_url="$(curl -s "https://tinyurl.com/api-create.php?url=${long_url}")"
  fi

  if [[ -n "${masked_url}" && "${masked_url}" =~ ^http ]]; then
    LOG "Shorted URL Created: ${masked_url}"
    printf '%s' "${masked_url}"
  else
    LOGW "Shorting failed. Returning raw Cloudflare URL."
    printf '%s' "${long_url}"
  fi
}
