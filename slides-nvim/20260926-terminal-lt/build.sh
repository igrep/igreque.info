#!/bin/bash

set -euo pipefail

files="$(ls *.md | grep -E '^[0-9][0-9]?' | /usr/bin/sort -n)"
(
  for file in $files; do
    cat "$file"
    echo -e "\n------------------------------------------------------------------------------\n"
  done
) > README.md

