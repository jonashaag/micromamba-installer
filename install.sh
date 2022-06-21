#!/bin/bash -eu

function platform_name {
  uname="$(echo "$(uname -a)" | tr "[:upper:]" "[:lower:]")"
  if [[ "$uname" =~ darwin.+arm64 ]]; then echo osx-arm64
  elif [[ "$uname" =~ darwin.+x86_64 ]]; then echo osx-64
  elif [[ "$uname" =~ linux.+arm64 ]]; then echo linux-aarch64
  elif [[ "$uname" =~ linux.+x86_64 ]]; then echo linux-64
  elif [[ "$uname" =~ win ]] || [[ "$uname" =~ mingw ]]; then echo win-64
  fi
}

function binary_name {
  if [[ $(platform_name) =~ win ]]; then
    echo Library/bin/micromamba.exe
  else
    echo bin/micromamba
  fi
}

BIN_LOCATION=~/mm  # https://github.com/mamba-org/mamba/issues/1751
if [ $# = 1 ]; then
  BIN_LOCATION="$1"
elif [ $# != 0 ]; then
  shift
  echo "Found superfluous arguments: $@" >&2
  exit 2
fi

if [ -e "$BIN_LOCATION" ]; then
  echo "$BIN_LOCATION already exists" >&2
  exit 3
fi

url=https://micro.mamba.pm/api/micromamba/$(platform_name)/latest
curl -sL $url | bunzip2 | tar xOf - $(binary_name) > "$BIN_LOCATION"
chmod +x "$BIN_LOCATION"
