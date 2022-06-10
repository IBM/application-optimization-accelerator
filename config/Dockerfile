FROM python
WORKDIR /code
RUN apt-get update && \
    apt-get install -y kafkacat \
    npm \
    jq && \
    pip3 install ansible \
    kubernetes && \
    npm install elasticdump -g && \
    curl -L https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz -o cloudctl-linux-amd64.tar.gz && \
    tar xzfv cloudctl-linux-amd64.tar.gz && \
    mv -f cloudctl-linux-amd64 /usr/local/bin/cloudctl && \
    rm -f cloudctl-linux-amd64.tar.gz && \
    wget -L https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz -O helm.tar.gz && \
    tar xfvz helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -r linux-amd64/ && \
    rm helm.tar.gz && \
    wget https://github.com/openshift/okd/releases/download/4.7.0-0.okd-2021-07-03-190901/openshift-client-linux-4.7.0-0.okd-2021-07-03-190901.tar.gz -O oc.tar.gz && \
    tar xfzv oc.tar.gz && \
    mv -f oc /usr/local/bin && \
    mv -f kubectl /usr/local/bin && \
    rm -f oc.tar.gz && \
    rm -f README.md && \
    wget https://github.com/mikefarah/yq/releases/download/v4.18.1/yq_linux_amd64.tar.gz -O yq.tar.gz && \
    tar xfzv yq.tar.gz && \
    mv yq_linux_amd64 /usr/local/bin/yq
RUN apt-get install -y vim
COPY ./ansible/ ./
RUN mkdir -p /.ansible /.kube /.config /.cache /.cloudctl && \
    chgrp -R 0 /code /.ansible /.kube /.config /.cache /.cloudctl && \
    chmod -R g=u /code /.ansible /.kube /.config /.cache /.cloudctl
USER 1001
CMD ansible-playbook install-ai-manager.yaml
# ENTRYPOINT ["tail", "-f", "/dev/null"]