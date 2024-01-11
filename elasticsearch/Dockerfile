ARG ES_VERSION=7.17.16
ARG ES_SUDACHI_VERSION=3.1.0

FROM eclipse-temurin:17 AS build
ARG ES_VERSION
ARG ES_SUDACHI_VERSION

WORKDIR /

RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/WorksApplications/elasticsearch-sudachi.git

WORKDIR /elasticsearch-sudachi

RUN git checkout v${ES_SUDACHI_VERSION} && \
    ./gradlew -PengineVersion=es:${ES_VERSION} build -x test

FROM elasticsearch:${ES_VERSION}
ARG ES_VERSION
ARG ES_SUDACHI_VERSION

COPY --from=build \
    /elasticsearch-sudachi/build/distributions/elasticsearch-${ES_VERSION}-analysis-sudachi-${ES_SUDACHI_VERSION}.zip \
    /analysis-sudachi.zip

RUN elasticsearch-plugin install file:///analysis-sudachi.zip
