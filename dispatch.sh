#!/usr/bin/env bash
set -euo pipefail

PAYLOAD=$(jq -n --arg ref "$REF" '{ref: $ref}')

STATUS=$(curl -s -o /dev/null -w '%{http_code}' -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d "$PAYLOAD" \
  "https://api.github.com/repos/$REPO/actions/workflows/$WORKFLOW/dispatches")

if [ "$STATUS" != "204" ]; then
  echo "workflow_dispatch to $REPO/$WORKFLOW (ref=$REF) failed with HTTP $STATUS" >&2
  exit 1
fi

echo "Dispatched $WORKFLOW on $REPO at ref $REF"
