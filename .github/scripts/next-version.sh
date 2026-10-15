#!/usr/bin/env bash
# Print the next tag from the last tag and a Conventional Commit message:
# "type!:" or "BREAKING CHANGE" -> major, "feat" -> minor, anything else -> patch.
# Usage: next-version.sh <last tag, e.g. v1.1.0> <commit message>
set -euo pipefail
IFS=. read -r major minor patch <<< "${1#v}"
major=${major:-0} minor=${minor:-0} patch=${patch:-0}
subject=$(head -n1 <<< "$2")
if [[ $subject =~ ^[a-z]+(\(.*\))?!: ]] || grep -q '^BREAKING[ -]CHANGE:' <<< "$2"; then
  echo "v$((major + 1)).0.0"
elif [[ $subject =~ ^feat(\(.*\))?: ]]; then
  echo "v$major.$((minor + 1)).0"
else
  echo "v$major.$minor.$((patch + 1))"
fi
