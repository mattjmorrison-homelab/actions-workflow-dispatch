# actions-workflow-dispatch

Reusable GitHub Actions composite action that triggers a `workflow_dispatch`
run of a specific workflow in another repo in this org, via the GitHub REST
API (`POST /repos/{owner}/{repo}/actions/workflows/{workflow}/dispatches`).
Wraps the raw `curl` call so consuming workflows don't each hand-roll it.

Named for the mechanism it wraps (`workflow_dispatch`), same reasoning as
`actions-tofu` being named for OpenTofu rather than Terraform.

## Why this exists

The first intended consumer is `graph-ad-reporter`/`graph-hdmi-switch`'s CI:
whenever either deploys, it needs to trigger `graph-router`'s `publish.yml`
so the federated GraphQL schema stays current. Rather than have each of
those repos hand-roll the curl call to GitHub's dispatches endpoint, this
action gives them (and any future cross-repo trigger) one place to reach
for it.

## Inputs

| Input | Type | Default | Notes |
| --- | --- | --- | --- |
| `repo` | string | *(required)* | Target repo, e.g. `mattjmorrison-homelab/graph-router`. |
| `workflow` | string | *(required)* | Target workflow file name, e.g. `publish.yml`. |
| `ref` | string | `main` | Branch/ref to run the workflow against. |
| `token` | string | *(required)* | GitHub token with Actions:write permission on the target repo. |

## Using it from another repo

```yaml
- uses: mattjmorrison-homelab/actions-workflow-dispatch@<commit-sha>
  with:
    repo: mattjmorrison-homelab/graph-router
    workflow: publish.yml
    token: ${{ secrets.SOME_TOKEN_WITH_ACCESS_TO_GRAPH_ROUTER }}
```

**Pin to a commit SHA, not a branch** -- this org requires
`sha_pinning_required` on every `uses:` reference. Get the current SHA
with:

```sh
gh api repos/mattjmorrison-homelab/actions-workflow-dispatch/commits/main --jq '.sha'
```

No automation keeps these pins current today; update every caller's pin
manually after any change here that should actually take effect.
