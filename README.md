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

Then:

```bash
chmod +x ~/bin/kubectl-container
```

### 2. Add aliases to your shell config (e.g. `~/.zshrc.aliases`)

```bash
alias k128='kubectl-container 1.28'  # kubectl for EKS 1.28
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
```

---

## 📁 Repo Structure

If you still want to build locally, use the files in this repo:

```
kubectl-matrix/
├── 1.28/
│   └── Dockerfile
├── 1.29/
│   └── Dockerfile
├── ...
├── bootstrap.sh          # builds all versions locally
└── kubectl-container     # runner script (shared above)
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
   - Generate temporary folders like `tmp/1.33/`
   - Use `Dockerfile.template` to build the image
   - Tag it as `devopscloudycontainers/kubectl:1.33`
   - Push it to Docker Hub

3. (Optional) Clean up:

   ```bash
   rm -rf tmp/
   ```

You can also re-run the script to **rebuild all existing versions** listed in `versions.txt`.

```bash
./bootstrap.sh
```

---

## 💡 Tips

- Shell completions for `kubectl`, `stern`, `krew` plugins, etc. can be added to `~/.zsh/completions/`
- Combine with `direnv` or `.tool-versions`-style switching per project
- Images can be pulled from Docker Hub without any build

---

## 📝 License

MIT
