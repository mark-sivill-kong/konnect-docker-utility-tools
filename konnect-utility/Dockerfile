#
# example of processing an OpenAPI specification to generate Kong configuration then upload to Konnect
#

FROM --platform=linux/amd64 docker.io/library/ubuntu:22.04

# using amd64 for inso / yq


LABEL maintainer="Mark Sivill - Kong"
LABEL description="Kong Konnect and miscellaneous utility tooling and in one Docker container, includes example of converting OpenAPI specifications to Kong deck configuration"

#
# running non-root user
#
ARG CONTAINER_USER=demo

#
# install command line tools
#
# deck install - https://docs.konghq.com/deck/latest/installation/
# inso install - https://docs.insomnia.rest/inso-cli/install
# kced install - https://github.com/Kong/go-apiops
# yq install - https://github.com/mikefarah/yq
# jq install - https://stedolan.github.io/jq/
# openapi-format - https://github.com/thim81/openapi-format 
#
RUN uname -a \
  && apt-get update -y \
  && apt-get upgrade -y \
  && apt-get install -y \
    coreutils \
    curl \
    tar \
    xz-utils \
    wget \
    jq \
  && useradd -ms /bin/bash ${CONTAINER_USER} \
  && mkdir /home/${CONTAINER_USER}/openapi-specs \
  && curl -sL https://github.com/Kong/deck/releases/download/v1.19.1/deck_1.19.1_linux_amd64.tar.gz -o deck.tar.gz \
  && tar -xf deck.tar.gz \
  && rm deck.tar.gz \
  && mv deck /usr/local/bin/ \ 
  && curl -sL https://github.com/Kong/insomnia/releases/download/lib%403.13.0/inso-linux-3.13.0.tar.xz -o inso.tar.xz \
  && tar -xf inso.tar.xz \
  && rm inso.tar.xz \
  && mv inso /usr/local/bin/ \
  && curl -sL https://github.com/Kong/go-apiops/releases/download/v0.1.11/go-apiops_0.1.11_linux_amd64.tar.gz -o kced.tar.gz \
  && tar -xf kced.tar.gz \
  && rm kced.tar.gz \
  && mv kced /usr/local/bin/ \
  && wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
  && chmod a+x /usr/local/bin/yq \
  && curl -sL https://deb.nodesource.com/setup_18.x | bash -  \
  && apt-get install -y nodejs \
  && npm install -g --save openapi-format

COPY ./files/openapi-specs /home/${CONTAINER_USER}/openapi-specs
COPY ./files/output /home/${CONTAINER_USER}/output
COPY ./files/scripts /home/${CONTAINER_USER}/scripts

RUN chmod -R oug+x /home/${CONTAINER_USER}/scripts/ \
  && chown -R ${CONTAINER_USER}:${CONTAINER_USER} /home/${CONTAINER_USER}/* 

USER ${CONTAINER_USER}
WORKDIR /home/${CONTAINER_USER}

# allows commands.sh to be run by including in path
ENV PATH "$PATH:/home/${CONTAINER_USER}/scripts/general"

ENTRYPOINT ["/bin/bash", "/home/${CONTAINER_USER}/scripts/loop/loop.sh"]

