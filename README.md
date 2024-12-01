
# Carica Kestra

This repository contains:

- Docker compose file for **Kestra**, **PostgreSQL**, and **HAProxy**.
- Kestra's flows, which is automated using Github Webhook.

## 1. About the docker compose file

The docker compose file is mainly based on [Kestra installation guide](https://kestra.io/docs/installation/docker-compose). Some additional database configuration and the proxy server is mainly for ease of use. Note that **Kestra** is exposed to the internet and protected by a simple password authentication so we can use the UI without having to locally host or SSH to the server.

## 2. About the Kestra's flows

There is a total of four flows in the **_flows** directory. There functionalities will be explained below:

### 2.1 Version control flows

There are two **flows** written based on [Kestra version control & CI/CD guide](https://kestra.io/docs/version-control-cicd/git). The guide suggests using either `SyncFlows` or `PushFlows`, but here both are implemented in order to achieve the best of both worlds, at the price of losing some **Kestra**'s features.

The upside of doing that is that we can use the **Kestra UI**, which is very convenient, and at the same time use Git as a single source of truth for our flows.

The first flow `push_to_git` is designed to push **Kestra's flows** to **GitHub** by manually executing the flow on the UI. This flow allows us to use the UI to develop and push flows directly to **Github**. However, the implementation of `PushFlows` only allows us to push flows of the same namespace at once, so I decide to set the namespace of all flows to **prod**. This is the lost of features that I mentioned earlier.

The second flow `sync_from_git` is triggered by a **Github Webhook**, whenever there's a push to main, **Kestra** will automatically sync the changes.

Note that in order to avoid triggering a pull right after a push, the `push_to_git` flow is designed to push to another branch to be checked and merged into main.

### 2.2 Auto-deploy flows

There are two other flows which basically do the same thing but have different triggers.

For the context, we have three more repositories:

- [Web using Svelte](https://github.com/centaurin/carica)
- [Self-hosted AI model](https://github.com/centaurin/carica-ml)
- [Deployment scripts](https://github.com/centaurin/carica-deploy)

The first two repositories have the same CI/CD flow. Whenever a tag is pushed to one repo, a **GitHub Workflow** will be triggered to build and publish a docker image to **GitHub Packages**. After the build finish, a **Github Webhook** will be sent to a **Kestra** and the flow will send a command through SSH to the deployment. The command will execute a script to update everything on that server.

However, the third repository doesn't need a docker image. As such, it is manually cloned into that server and the update script will be triggered by **Kestra's flows**. This repository also has its own **flow**, whenever a push is made to branch `main`, a **Webhook** will trigger the **flow** to SSH into the deployment server and run the update script.
