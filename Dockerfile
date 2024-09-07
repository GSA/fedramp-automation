ARG GIT_IMAGE=alpine:3.20.2
ARG MAVEN_IMAGE=maven:3.9.9-eclipse-temurin-22-alpine
ARG NODE_IMAGE=node:22-alpine3.20
ARG TEMURIN_APK_KEY_URL=https://packages.adoptium.net/artifactory/api/security/keypair/public/repositories/apk
ARG TEMURIN_APK_REPO_URL=https://packages.adoptium.net/artifactory/apk/alpine/main
ARG TEMURIN_APK_VERSION=temurin-22-jdk
ARG MAVEN_DEP_PLUGIN_VERSION=3.8.0
ARG OSCAL_CLI_VERSION=2.0.2
ARG OSCAL_JS_VERSION=1.4.4
ARG FEDRAMP_AUTO_GIT_URL=https://github.com/GSA/fedramp-automation.git
ARG FEDRAMP_AUTO_GIT_REF=feature/external-constraints

FROM ${MAVEN_IMAGE} as oscal_cli_downloader
ARG MAVEN_DEP_PLUGIN_VERSION
ARG OSCAL_CLI_VERSION
RUN apk add --no-cache unzip &&  \
    mkdir -p /opt/oscal-cli && \
    mvn \
    org.apache.maven.plugins:maven-dependency-plugin:${MAVEN_DEP_PLUGIN_VERSION}:copy \
    -DoutputDirectory=/opt/oscal-cli \
    -DremoteRepositories=https://repo1.maven.org/maven2 \
    -Dartifact=dev.metaschema.oscal:oscal-cli-enhanced:${OSCAL_CLI_VERSION}:zip:oscal-cli && \
    cd /opt/oscal-cli && unzip *.zip && rm -f *.zip

FROM ${GIT_IMAGE} as fedramp_data_downloader
ARG FEDRAMP_AUTO_GIT_URL
ARG FEDRAMP_AUTO_GIT_REF
RUN apk add --no-cache git && \
    mkdir -p /usr/local/src && \
    cd /usr/local/src && \
    git clone ${FEDRAMP_AUTO_GIT_URL} && \
    cd fedramp-automation && \
    git checkout ${FEDRAMP_AUTO_GIT_REF} && \
    echo ${FEDRAMP_AUTO_GIT_URL} >> checkout_data.txt && \
    echo ${FEDRAMP_AUTO_GIT_REF} >> checkout_data.txt && \
    git rev-parse HEAD >> checkout_data.txt

FROM ${NODE_IMAGE} as final
ARG OSCAL_JS_VERSION
ARG TEMURIN_APK_KEY_URL
ARG TEMURIN_APK_REPO_URL
ARG TEMURIN_APK_VERSION
LABEL org.opencontainers.image.authors="FedRAMP Automation Team <oscal@fedramp.gov>"
LABEL org.opencontainers.image.documentation="https://automate.fedramp.gov"
LABEL org.opencontainers.image.source="https://github.com/GSA/fedramp-automation/tree/main/Dockerfile"
LABEL org.opencontainers.image.vendor="GSA Technology Transformation Services"
LABEL org.opencontainers.image.title="FedRAMP Validation Tools"
LABEL org.opencontainers.image.description="FedRAMP's tools for validating OSCAL data"
LABEL org.opencontainers.image.licenses="CC0-1.0"
COPY --from=oscal_cli_downloader /opt/oscal-cli /opt/oscal-cli
COPY --from=fedramp_data_downloader /usr/local/src/fedramp-automation/src/validations/constraints/*.xml /opt/fedramp/constraints/
COPY --from=fedramp_data_downloader /usr/local/src/fedramp-automation/checkout_data.txt /opt/fedramp/constraints/
RUN wget -O /etc/apk/keys/adoptium.rsa.pub "${TEMURIN_APK_KEY_URL}" && \
    echo "${TEMURIN_APK_REPO_URL}" >> /etc/apk/repositories && \
    apk add --no-cache ${TEMURIN_APK_VERSION} && \
    mkdir -p /opt/fedramp/oscaljs && \
    mkdir -p /opt/fedramp/constraints && \
    (cd /opt/fedramp/oscaljs && npm install oscal@${OSCAL_JS_VERSION})
ENV PATH="$PATH:/opt/oscal-cli/bin:/opt/fedramp/oscaljs/node_modules/.bin"
WORKDIR /opt/fedramp/constraints
ENTRYPOINT [ "/opt/oscal-cli/bin/oscal-cli" ]
