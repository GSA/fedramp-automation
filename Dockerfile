ARG GIT_IMAGE=bitnami/git:2.46.0
ARG MAVEN_IMAGE=maven:3.9.8-eclipse-temurin-21
ARG MAVEN_DEP_PLUGIN_VERSION=3.8.0
ARG OSCAL_CLI_VERSION=2.0.2
ARG OSCAL_CLI_INSTALL_PATH=/opt/oscal

FROM ${MAVEN_IMAGE} as cli_downloader
ARG MAVEN_DEP_PLUGIN_VERSION
ARG OSCAL_CLI_VERSION
ARG OSCAL_CLI_INSTALL_PATH
RUN apt-get update -y && \
    apt-get install -y unzip && \
    mkdir -p /opt/oscal-cli && \
    mvn \
    org.apache.maven.plugins:maven-dependency-plugin:${MAVEN_DEP_PLUGIN_VERSION}:copy \
    -DoutputDirectory=/opt/oscal-cli \
    -DremoteRepositories=https://repo1.maven.org/maven2 \
    -Dartifact=dev.metaschema.oscal:oscal-cli-enhanced:${OSCAL_CLI_VERSION}:zip:oscal-cli && \
    cd /opt/oscal-cli && unzip *.zip && rm -f *.zip

FROM cli_downloader
LABEL org.opencontainers.image.authors="FedRAMP Automation Team <oscal@fedramp.gov>"
LABEL org.opencontainers.image.documentation="https://automate.fedramp.gov"
LABEL org.opencontainers.image.source="https://github.com/GSA/fedramp-automation/tree/main/Dockerfile"
LABEL org.opencontainers.image.vendor="GSA Technology Transformation Services"
LABEL org.opencontainers.image.title="FedRAMP Validation Tools"
LABEL org.opencontainers.image.description="FedRAMP's tools for validating OSCAL data"
LABEL org.opencontainers.image.licenses="CC0-1.0"
ARG OSCAL_CLI_INSTALL_PATH
COPY --from=cli_downloader /opt/oscal-cli /opt/
RUN mkdir -p /opt/fedramp
ENV PATH="$PATH:/opt/oscal-cli/bin"
WORKDIR /app
ENTRYPOINT [ "/opt/oscal-cli/bin/oscal-cli" ]
