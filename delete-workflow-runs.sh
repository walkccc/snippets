# !/usr/bin/env bash

# Script to delete GitHub Actions workflow runs from a specified repository.
#
# You can either delete all workflow runs or selectively delete specific runs by
# passing 'all' or 'select' as the first argument, respectively, followed by the
# repository in 'owner/repo' format.
#
# Usage:
#   1. To delete all workflow runs
#      $ bash delete-workflow-runs.sh all owner/repo
#
#   2. To select and delete specific workflow runs
#      $ bash delete-workflow-runs.sh select owner/repo
#
# Requirements:
#   1. gh (GitHub CLI)
#   2. jq (JSON processor)

set -o errexit
set -o pipefail

declare mode=${1:?No mode specified, use 'all' or 'select'}
declare repo=${2:?No owner/repo specified}

jq_script() {
  cat <<EOF
    def symbol:
      sub("skipped"; "SKIP") |
      sub("success"; "GOOD") |
      sub("failure"; "FAIL");

    def tz:
      gsub("[TZ]"; " ");

    .workflow_runs[]
      | [
          (.conclusion | symbol),
          (.created_at | tz),
          .id,
          .event,
          .name
        ]
      | @tsv
EOF
}

fetch_runs() {
  gh api --paginate "/repos/$repo/actions/runs" | jq -r -f <(jq_script)
}

delete_run() {
  local run id result
  run=$1
  id="$(cut -f 3 <<<"$run")"
  gh api -X DELETE "/repos/$repo/actions/runs/$id"
  [[ $? = 0 ]] && result="OK!" || result="BAD"
  printf "%s\t%s\n" "$result" "$run"
}

delete_runs() {
  while read -r run; do
    delete_run "$run"
    sleep 0.25
  done
}

delete_all_runs() {
  fetch_runs |
    while read -r run; do
      delete_run "$run"
      sleep 0.25
    done
}

main() {
  case $mode in
  all)
    delete_all_runs
    ;;
  select)
    fetch_runs | fzf --multi | delete_runs
    ;;
  *)
    echo "Invalid mode specified, use 'all' or 'select'"
    exit 1
    ;;
  esac
}

main
