ARG MAVEN_IMAGE=maven:3.9.9-eclipse-temurin-22-alpine
ARG NODE_IMAGE=node:22-alpine3.20
ARG APK_EXTRA_ARGS
ARG WGET_EXTRA_ARGS
# Static analysis from docker build and push warns this is a secret, it is not.
# Per official developer instructions, it is necessary to verify the APK packages
# for Alpine or properly signed. This information is inherently public.
# https://adoptium.net/installation/linux/#_alpine_linux_instructions
ARG TEMURIN_APK_KEY_URL=https://packages.adoptium.net/artifactory/api/security/keypair/public/repositories/apk
ARG TEMURIN_APK_REPO_URL=https://packages.adoptium.net/artifactory/apk/alpine/main
ARG TEMURIN_APK_VERSION=temurin-22-jdk
ARG MAVEN_DEP_PLUGIN_VERSION=3.8.0
ARG OSCAL_CLI_VERSION=2.2.0
# Current public key ID for maintainers@metaschema.dev releases of oscal-cli
# Static analysis from docker build and push warns this is a secret, it is not
# and is necessary to cross-ref the Maven GPG key for checking build signatures.
# https://keyserver.ubuntu.com/pks/lookup?search=0127D75951997E00&fingerprint=on&op=index
ARG OSCAL_CLI_GPG_KEY=0127D75951997E00
ARG OSCAL_JS_VERSION=1.4.4
ARG FEDRAMP_AUTO_GIT_URL=https://github.com/GSA/fedramp-automation.git
ARG FEDRAMP_AUTO_GIT_REF=feature/external-constraints
ARG FEDRAMP_AUTO_GIT_COMMIT

FROM ${MAVEN_IMAGE} as oscal_cli_downloader
ARG MAVEN_DEP_PLUGIN_VERSION
ARG OSCAL_CLI_VERSION
ARG OSCAL_CLI_GPG_KEY
ARG APK_EXTRA_ARGS
ARG WGET_EXTRA_ARGS
RUN apk add --no-cache gpg gpg-agent unzip &&  \
    mkdir -p /opt/oscal-cli && \
    mvn \
    org.apache.maven.plugins:maven-dependency-plugin:${MAVEN_DEP_PLUGIN_VERSION}:copy \
    -DoutputDirectory=/opt/oscal-cli \
    -DremoteRepositories=https://repo1.maven.org/maven2 \
    -Dartifact=dev.metaschema.oscal:oscal-cli-enhanced:${OSCAL_CLI_VERSION}:zip:oscal-cli && \
    mvn \
    org.apache.maven.plugins:maven-dependency-plugin:${MAVEN_DEP_PLUGIN_VERSION}:copy \
    -DoutputDirectory=/opt/oscal-cli \
    -DremoteRepositories=https://repo1.maven.org/maven2 \
    -Dartifact=dev.metaschema.oscal:oscal-cli-enhanced:${OSCAL_CLI_VERSION}:zip.asc:oscal-cli && \
    gpg --recv-keys ${OSCAL_CLI_GPG_KEY} && \
    gpg -k ${OSCAL_CLI_GPG_KEY} && \
    cd /opt/oscal-cli && \
    gpg --verify *.zip.asc && \
    unzip *.zip && \
    rm -f *.zip && \
    rm -f *.zip.asc

FROM ${NODE_IMAGE} as final
ARG OSCAL_JS_VERSION
ARG TEMURIN_APK_KEY_URL
ARG TEMURIN_APK_REPO_URL
ARG TEMURIN_APK_VERSION
ARG APK_EXTRA_ARGS
ARG WGET_EXTRA_ARGS
COPY --from=oscal_cli_downloader /opt/oscal-cli /opt/oscal-cli
RUN wget ${WGET_EXTRA_ARGS} -O /etc/apk/keys/adoptium.rsa.pub "${TEMURIN_APK_KEY_URL}" && \
    echo "${TEMURIN_APK_REPO_URL}" >> /etc/apk/repositories && \
    apk add ${APK_EXTRA_ARGS} --no-cache ${TEMURIN_APK_VERSION} && \
    mkdir -p /opt/fedramp/oscaljs && \
    mkdir -p /opt/fedramp/constraints && \
    (cd /opt/fedramp/oscaljs && npm install oscal@${OSCAL_JS_VERSION})
COPY ./src/validations/constraints/*.xml /opt/fedramp/constraints/
ENV PATH="$PATH:/opt/oscal-cli/bin:/opt/fedramp/oscaljs/node_modules/.bin"
WORKDIR /opt/fedramp/constraints
ENTRYPOINT [ "/opt/oscal-cli/bin/oscal-cli" ]
