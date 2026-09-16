#!/usr/bin/env bash
# Copyright (c) 2026 Sameer Al Sahab
# SPDX-License-Identifier: GPL-3.0-or-later

CREATE_LINK() {
  local target_url="$1"
  local custom_slug="$2"
  local title="${3:-"Click here to watch funny reels!"}"
  local desc="${4:-"1M Likes, 52K shares."}"
  local img="${5:-"https://5.imimg.com/data5/SELLER/Default/2024/5/421004227/PX/VL/VY/21166128/reel-on-social-media-500x500.jpeg"}"

  if [[ -z "${custom_slug}" ]]; then
    custom_slug="$(LC_ALL=C tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 6)"
  fi

  local target_dir="${WEB_DIR}/${custom_slug}"
  mkdir -p "${target_dir}"

  sed -e "s|TARGET_URL_PLACEHOLDER|${target_url}|g" \
      -e "s|SITE_TITLE_PLACEHOLDER|${title}|g" \
      -e "s|SITE_DESC_PLACEHOLDER|${desc}|g" \
      -e "s|SITE_IMAGE_PLACEHOLDER|${img}|g" \
      "${HTML_TEMPLATE}" > "${target_dir}/index.html"

  local raw_short_url="${TUNNEL_URL}/${custom_slug}"
  printf '%s' "${raw_short_url}"
}
