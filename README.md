# 🧰 kubectl-matrix

**Multi-version, Dockerized `kubectl` CLI** with essential plugins.  
Run different Kubernetes versions (1.28–1.32) side-by-side, cleanly and consistently, with zero setup beyond Docker.

---

## 📦 Included Versions

- `v1.28`
- `v1.29`
- `v1.30`
- `v1.31`
- `v1.32`

Each image includes:

- `kubectl`
- [krew](https://krew.sigs.k8s.io/) and essential plugins:
  - `ctx`, `ns`, `tree`, `ktop`, `whoami`, `neat`
  - `df-pv`, `get-all`, `access-matrix`, `resource-capacity`, `sniff`
  - `rbac-tool`, `cert-manager`, `deprecations`, `view-allocations`, `outdated`
- `stern` (aggregated logs viewer)
- `aws` CLI v2

---

## ⚙️ Usage (with Prebuilt Docker Hub Images)

You **do not need to build anything locally**. Just use the aliases below or the runner script.

### 1. Create runner script

Save this as `~/bin/kubectl-container`:

```bash
#!/usr/bin/env bash

version="$1"
shift

image="devopscloudycontainers/kubectl:${version}"
docker run --rm -it \
  -v "$HOME/.kube:/root/.kube" \
  -v "$HOME/.aws:/root/.aws" \
  --network host \
  "$image" kubectl "$@"
```

Then make it executable:

```bash
chmod +x ~/bin/kubectl-container
```

### 2. Add aliases to your shell config (e.g. `~/.zshrc.aliases`)

```bash
alias k128='kubectl-container 1.28'
alias k129='kubectl-container 1.29'
alias k130='kubectl-container 1.30'
alias k131='kubectl-container 1.31'
alias k132='kubectl-container 1.32'
```

Then reload:

```bash
exec zsh
```

---

## ✅ Example Commands

```bash
k128 version
k129 get nodes
k132 config use-context my-dev-cluster
k131 get pods -n kube-system
```

---

## 📁 Repo Structure

```
kubectl-matrix/
├── Dockerfile.template         # Single dynamic Dockerfile template
├── versions.txt                # List of kubectl versions to build
├── bootstrap.sh                # Script to build, tag, push, and test
├── README.md                   # You're reading it :)
├── .gitignore
~/bin/
└── kubectl-container           # Runner script (outside repo, symlink or personal bin path)
```

---

## 🛠 Add or Update kubectl Versions

All versions are listed in [`versions.txt`](./versions.txt).
To add a new version:

1. Append it to the file:

   ```bash
   echo "1.33.0" >> versions.txt
   ```

2. Run the bootstrap script:

   ```bash
   ./bootstrap.sh
   ```

   This will:
   - Use `Dockerfile.template` to build the image
   - Tag it as `devopscloudycontainers/kubectl:<short_version>`
   - Push it to Docker Hub
   - Run basic tests for `kubectl` and `aws`

3. (Optional) Clean up:

   ```bash
   rm -rf tmp/
   ```

To rebuild all images:

```bash
./bootstrap.sh
```

---

## 🧠 Notes on Other Tools

These tools are useful, but **intentionally excluded** from the container because they:

- Require privileged access
- Run better natively
- Belong in CI/CD or cluster-side setups

| Tool                                | Reason                                                                 |
|-------------------------------------|------------------------------------------------------------------------|
| Helm                                | Needs its own versioning, best kept outside image per project          |
| K9s                                 | Interactive TUI, better run natively                                   |
| Inspektor Gadget                    | Requires kernel-level access – not container-friendly                  |
| Kube-hunter, kubeaudit              | Better suited for scanning from outside or CI/CD                       |
| Prometheus, Thanos                  | Server-side observability stacks                                       |
| Dex, Permission Manager             | Cluster services                                                       |
| kured, flagger, Draino              | Daemons or controllers                                                 |
| kube-cost                           | Analytics platform – better in-cluster                                 |
| kube-fledged, localpath-provisioner | Node-level tools                                                       |
| Kubevious                           | Browser GUI tool                                                       |
| Mizu                                | Requires privileged mode – better as a separate container              |
| kube-linter                         | Manifest linter to catch errors early                                  |
| kube-bench                          | CIS Benchmark check, post-upgrade safety                               |
| kubecfg                             | Preview/diff Kubernetes manifests before applying                      |
| kubefwd                             | Dev tool for port-forwarding services locally                          |
| telepresence                        | Intercept cluster traffic to your local app                            |
| skaffold, tilt                      | CI dev loop, live sync for local dev                                   |
| flux, tekton                        | CI/CD tools to automate deployments                                    |
| vertical-pod-autoscaler             | Tunes pod resource requests/limits dynamically                         |
| karpenter                           | Node autoscaling for EKS (controller-based)                            |
| kubectl-node-shell                  | Privileged pod to shell into a node                                    |

---

## 💡 Tips

- Shell completions for `kubectl`, `stern`, `krew` plugins, etc. can be added to `~/.zsh/completions/`
- Combine with `direnv` or `.tool-versions`-style switching per project
- Images can be pulled from Docker Hub without any build

---

## 📝 License

MIT
