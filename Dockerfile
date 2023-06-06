FROM bitnami/kubectl:1.27.2 as base

USER 0

RUN apt-get update && apt-get install -y curl

WORKDIR /tmp

RUN curl -fsSLO https://github.com/loft-sh/vcluster/releases/latest/download/vcluster-linux-amd64
RUN mv vcluster-linux-amd64 vcluster
RUN install -c -m 0755 vcluster /usr/local/bin
RUN rm -f vcluster
ADD --chmod=0755 vclusterctl.sh /usr/local/bin/vclusterctl.sh

FROM base

USER 1001