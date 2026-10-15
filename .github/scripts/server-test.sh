#!/usr/bin/env bash
# Load the pack on a headless vanilla server and fail on any pack error.
# Usage: server-test.sh <minecraft version> <path to elytra-hud.zip>
set -euo pipefail
version=$1 zip=$(realpath "$2")
dir=$(mktemp -d)
cd "$dir"

url=$(curl -fsS https://piston-meta.mojang.com/mc/game/version_manifest_v2.json \
  | jq -r --arg v "$version" '.versions[] | select(.id == $v) | .url')
[ -n "$url" ] || { echo "Unknown version $version"; exit 1; }
curl -fsS -o server.jar "$(curl -fsS "$url" | jq -r .downloads.server.url)"

echo eula=true > eula.txt
printf 'level-type=minecraft\\:flat\nspawn-protection=0\n' > server.properties
mkdir -p world/datapacks && cp "$zip" world/datapacks/elytra-hud.zip

# Feed commands once the server is up, then stop it.
{
  until grep -q 'Done (' logs/latest.log 2>/dev/null; do sleep 1; done
  echo 'datapack list enabled'
  echo 'reload'
  sleep 5
  echo 'datapack list enabled'
  echo 'stop'
} | timeout 300 java -Xmx1G -jar server.jar nogui > out.log 2>&1 || { cat out.log; exit 1; }

cat out.log
if grep -E '(ERROR|WARN)\]' out.log | grep -iE 'elytra|datapack|data pack|function|predicate|parse'; then
  echo "FAIL: pack errors on $version"; exit 1
fi
[ "$(grep -c 'file/elytra-hud.zip' out.log)" -ge 2 ] || { echo "FAIL: pack not enabled on $version"; exit 1; }
echo "OK: $version"
