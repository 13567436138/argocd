FROM argoproj/argocd:v2.6.7

ENV SOPS_VERSION="v3.7.3"
ENV HELM_SECRETS_VERSION="v4.4.2"
ENV HELM_GCS_VERSION="0.4.1"

ENV SOPS_PGP_FP="8C2BD481C5AD7775D058FA71C0AD1F6E2948B453"


USER root  

RUN apt-get update && \
    apt-get install -y \
    curl \
    gpg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && \
    chmod +x /usr/local/bin/sops 

# helm secrets plugin should be installed as user argocd or it won't be found
USER argocd
RUN /usr/local/bin/helm plugin install https://github.com/zendesk/helm-secrets --version ${HELM_SECRETS_VERSION}
RUN /usr/local/bin/helm plugin install https://github.com/hayorov/helm-gcs.git --version ${HELM_GCS_VERSION}
ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins"
