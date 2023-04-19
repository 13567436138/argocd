#FROM argoproj/argocd:v2.6.7
FROM registry.cn-hangzhou.aliyuncs.com/hxpdocker/argocd:v2.6.7


USER root

COPY sops /usr/local/bin/
RUN chmod +x /usr/local/bin/sops  && \
    apt-get update && \
    apt-get install -y   gpg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    cp /usr/bin/gpg /usr/local/bin/ && mkdir -p /home/argocd/.gnupg && \
    chown -R 999:999 /home/argocd 


USER 999
COPY .sops.yaml /home/argocd
# helm secrets plugin should be installed as user argocd or it won't be found
COPY helm-secrets.tar.gz /helm-secrets.tar.gz
RUN mkdir -p /home/argocd/.local/share/helm/plugins && tar xzf /helm-secrets.tar.gz -C "$(helm env HELM_PLUGINS)" 
ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins"
