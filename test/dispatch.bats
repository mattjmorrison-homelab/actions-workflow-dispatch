#!/usr/bin/env bats

setup() {
  export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
  export REPO="mattjmorrison-homelab/graph-router"
  export WORKFLOW="publish.yml"
  export REF="main"
  export TOKEN="fake-token"
}

@test "succeeds when GitHub returns 204" {
  run bash "$BATS_TEST_DIRNAME/../dispatch.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Dispatched publish.yml on mattjmorrison-homelab/graph-router at ref main"* ]]
}

@test "fails when GitHub does not return 204" {
  export MOCK_DISPATCH_FAILS="true"
  run bash "$BATS_TEST_DIRNAME/../dispatch.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"failed with HTTP 404"* ]]
}
