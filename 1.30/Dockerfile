ARG KUBECTL_VERSION=1.30.0
FROM alpine:3.19

ARG KUBECTL_VERSION
ENV KREW_ROOT=/root/.krew
ENV PATH="${KREW_ROOT}/bin:/usr/local/bin:$PATH"

RUN apk add --no-cache bash curl git unzip \
 && curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
 && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
 && curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-linux_amd64.tar.gz" \
 && tar zxvf krew-linux_amd64.tar.gz \
 && ./krew-linux_amd64 install krew \
 && kubectl krew install ctx ns tree ktop whoami neat df-pv get-all access-matrix resource-capacity sniff
