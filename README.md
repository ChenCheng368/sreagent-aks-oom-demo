# sreagent-aks-oom-demo

Workload repo for testing the automated incident response flow in
[cpf-sre-agent-kit](https://github.com/janalee123/cpf-sre-agent-kit). A small `web` deployment runs in
the `demo` namespace of an AKS cluster. A commit that raises its memory use above the container limit
makes it OOMKilled, which fires an Azure Monitor alert and starts the Azure SRE Agent investigation.

## Flow

1. `deploy.yml` deploys `k8s/` to AKS after a person approves the `aks-demo` environment.
2. The faulty commit makes the pod OOMKilled. The Azure Monitor alert fires and the agent investigates.
3. A person reads the agent's findings and runs **SRE Agent handoff**, which opens an issue.
4. A person raises a pull request that reverts the memory change, and a reviewer merges it.
5. A person approves the `aks-demo` deployment. `deploy.yml` checks the rollout, then closes the issue.

## Setup

Repository **variables** (Settings > Secrets and variables > Actions > Variables). There are no secrets,
because the Azure login uses OIDC:

| Variable | Value |
|---|---|
| `AZURE_CLIENT_ID` | Client ID of the `gh-sreagent-aks-oom-demo` app registration |
| `AZURE_TENANT_ID` | Your Entra tenant ID |
| `AZURE_SUBSCRIPTION_ID` | The subscription that holds the cluster |
| `AKS_RESOURCE_GROUP` | `rg-aks-demo` |
| `AKS_CLUSTER_NAME` | `aks-patch-demo` |

Environment: create `aks-demo` (Settings > Environments) and add yourself as a required reviewer. The
Azure federated credential only trusts this environment.
