FROM bitnami/kubectl:1.27.2 as base

USER 0

RUN apt-get update && apt-get install -y curl

WORKDIR /tmp
RUN curl -fsSLO https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-linux_amd64.tar.gz
RUN tar zxvf krew-linux_amd64.tar.gz
RUN chmod +x ./krew-linux_amd64 && mv ./krew-linux_amd64 /usr/local/bin/kubectl-krew

FROM base as vcluster

WORKDIR /tmp
RUN curl -fsSLO https://github.com/loft-sh/vcluster/releases/latest/download/vcluster-linux-amd64
RUN mv vcluster-linux-amd64 vcluster
RUN install -c -m 0755 vcluster /usr/local/bin
RUN rm -f vcluster
RUN kubectl krew install edit-status

FROM vcluster

LABEL version="1.0.0"
LABEL description="VCluster CLI"
USER 1001