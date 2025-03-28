# 🧰 kubectl-matrix

**Multi-version, containerized `kubectl` CLI setup** with essential krew plugins. Run multiple versions of `kubectl` (1.28 – 1.32) side-by-side without polluting your system.  
Perfect for EKS version-specific tooling, testing, and CI environments.

---

## 📦 Included Versions

- `v1.28`
- `v1.29`
- `v1.30`
- `v1.31`
- `v1.32`

Each container includes:

- `kubectl`
- [krew](https://krew.sigs.k8s.io/) with plugins:
  - `ctx`, `ns`, `tree`, `ktop`, `whoami`, `neat`
  - `df-pv`, `get-all`, `access-matrix`, `resource-capacity`, `sniff`

---

## ⚙️ Usage

### 🖥 Local Setup

1. Clone the repo:

   ```bash
   git clone git@github.com:<your-username>/kubectl-matrix.git
   cd kubectl-matrix
   ```

2. Build all versions:

   ```bash
   ./bootstrap.sh
   ```

3. Copy the runner script to `~/bin`:

   ```bash
   cp kubectl-container ~/bin/kubectl-container
   chmod +x ~/bin/kubectl-container
   ```

4. Define aliases in your shell config (`~/.zshrc.aliases` or similar):

   ```bash
   alias k128='kubectl-container 1.28'
   alias k129='kubectl-container 1.29'
   alias k130='kubectl-container 1.30'
   alias k131='kubectl-container 1.31'
   alias k132='kubectl-container 1.32'
   ```

5. Reload your shell:

   ```bash
   exec zsh
   ```

### ✅ Example Commands

```bash
k128 version               # Use kubectl v1.28
k130 get nodes             # Use kubectl v1.30
k132 config use-context dev-cluster
```

---

## 🐳 Docker Image Naming (Local)

Each image is tagged:

```bash
kubectl-matrix:1.28
kubectl-matrix:1.29
# etc.
```

---

## ☁️ Optional: Push to Docker Hub

If publishing to Docker Hub:

```bash
docker tag kubectl-matrix:1.28 your-dockerhub-user/kubectl:1.28
docker push your-dockerhub-user/kubectl:1.28
```

Update the `kubectl-container` script to pull from Docker Hub if desired.

---

## 💡 Bonus Tips

- Pair with zsh completions (`kubectl`, `stern`, `k9s`, etc.)
- Optional `direnv` or `.tool-versions`-style switching per project
- Mount custom kubeconfigs and AWS credentials into containers

---

## 🧪 Requirements

- Docker
- Zsh or Bash (for aliases)
- Optional: shell completions, `direnv`, etc.

---

## 📁 Project Structure

```
kubectl-matrix/
├── 1.28/
│   └── Dockerfile
├── 1.29/
│   └── Dockerfile
├── ...
├── bootstrap.sh
└── kubectl-container     # runner script
```

---

## 📝 License

MIT
