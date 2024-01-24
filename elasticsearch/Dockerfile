ARG ES_VERSION=7.17.16
ARG ES_SUDACHI_VERSION=3.1.0
ARG SUDACHI_DICT_VERSION=20230927
# SUDACHI_VERSION is used only for downloading sudachi.json and char.def
ARG SUDACHI_VERSION=0.7.3

FROM eclipse-temurin:17 AS build
ARG ES_VERSION
ARG ES_SUDACHI_VERSION
ARG SUDACHI_DICT_VERSION
ARG SUDACHI_VERSION

WORKDIR /

RUN apt-get update && \
    apt-get install -y git unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Build elasticsearch-sudachi
RUN git clone https://github.com/ushitora-anqou/elasticsearch-sudachi.git
WORKDIR /elasticsearch-sudachi
RUN git checkout realdev && \
    ./gradlew -PengineVersion=es:${ES_VERSION} build -x test

# Download sudachi-dictionary, sudachi.json, and char.def
WORKDIR /
RUN curl -L -o dic.zip https://github.com/WorksApplications/SudachiDict/releases/download/v${SUDACHI_DICT_VERSION}/sudachi-dictionary-${SUDACHI_DICT_VERSION}-core.zip && \
    unzip dic.zip && \
    mv sudachi-dictionary-${SUDACHI_DICT_VERSION}/system_core.dic /system_core.dic && \
    curl https://raw.githubusercontent.com/WorksApplications/Sudachi/v${SUDACHI_VERSION}/src/main/resources/sudachi.json > /sudachi.json && \
    curl https://raw.githubusercontent.com/WorksApplications/Sudachi/v${SUDACHI_VERSION}/src/main/resources/char.def > /char.def

FROM elasticsearch:${ES_VERSION}
ARG ES_VERSION
ARG ES_SUDACHI_VERSION

# Install elasticsearch-sudachi and system_core.dic
COPY --from=build \
    /elasticsearch-sudachi/build/distributions/elasticsearch-*-analysis-sudachi-*.zip \
    /analysis-sudachi.zip
COPY --from=build /system_core.dic /sudachi.json /char.def config/sudachi/
RUN elasticsearch-plugin install file:///analysis-sudachi.zip

# Install analysis-icu
RUN elasticsearch-plugin install analysis-icu

USER elasticsearch:root
