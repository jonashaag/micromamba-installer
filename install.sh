#!/bin/bash -eu

function platform_name () {
  local x
  x=$(uname)-$(uname -m)
  x=${x,,}
  x=${x//darwin/osx}
  x=${x//_x86/}
  echo $x
}

BIN_LOCATION=~/micromamba
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
curl -sL $url | bunzip2 | tar xOf - bin/micromamba > "$BIN_LOCATION"
chmod +x "$BIN_LOCATION"
