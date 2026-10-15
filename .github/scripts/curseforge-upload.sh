#!/usr/bin/env bash
# Upload a zip to the CurseForge project, tagged with every Minecraft version
# the server tests cover. DRY_RUN=1 only prints the metadata.
# Usage: CURSEFORGE_TOKEN=... curseforge-upload.sh <zip> <display name> <changelog file>
set -euo pipefail
zip=$1 name=$2 changelog=$3
project=1746185
api=https://minecraft.curseforge.com/api
auth=(-H "X-Api-Token: $CURSEFORGE_TOKEN")

# Versions = the test matrix, so tags never claim more than CI checked.
versions=$(grep -oP '^\s*minecraft: \[\K[^\]]+' "$(dirname "$0")/../workflows/test.yml" | tr -d '" ' | tr , '\n')

types=$(curl -fsS "${auth[@]}" "$api/game/version-types" \
  | jq '[.[] | select(.slug | test("^minecraft-[0-9]")) | .id]')
ids=$(curl -fsS "${auth[@]}" "$api/game/versions" \
  | jq --argjson types "$types" --arg want "$versions" '
      ($want | split("\n")) as $w
      | [.[] | select((.gameVersionTypeID as $t | $types | index($t)) and (.name as $n | $w | index($n)))]
      | if length == ($w | length) then map(.id) else error("CurseForge knows only \(map(.name)) of \($w)") end')

metadata=$(jq -n --arg name "$name" --rawfile changelog "$changelog" --argjson ids "$ids" \
  '{displayName: $name, changelog: $changelog, changelogType: "markdown", gameVersions: $ids, releaseType: "release"}')
echo "$metadata"
[ "${DRY_RUN:-}" = 1 ] && exit 0

curl -fsS "${auth[@]}" -F "metadata=$metadata" -F "file=@$zip" "$api/projects/$project/upload-file"
echo
