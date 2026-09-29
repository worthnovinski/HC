#!/bin/sh
printf '\033c\033]0;%s\a' Herman Crab
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Herman Crablin.x86_64" "$@"
