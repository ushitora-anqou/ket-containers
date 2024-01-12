ARG ES_VERSION=7.17.16
ARG ES_SUDACHI_VERSION=3.1.0
ARG SUDACHI_DICT_VERSION=20230927

FROM eclipse-temurin:17 AS build
ARG ES_VERSION
ARG ES_SUDACHI_VERSION
ARG SUDACHI_DICT_VERSION

WORKDIR /

RUN apt-get update && \
    apt-get install -y git unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Build elasticsearch-sudachi
RUN git clone https://github.com/WorksApplications/elasticsearch-sudachi.git
WORKDIR /elasticsearch-sudachi
RUN git checkout v${ES_SUDACHI_VERSION} && \
    ./gradlew -PengineVersion=es:${ES_VERSION} build -x test

# Download sudachi-dictionary
WORKDIR /
RUN curl -L -o dic.zip https://github.com/WorksApplications/SudachiDict/releases/download/v${SUDACHI_DICT_VERSION}/sudachi-dictionary-${SUDACHI_DICT_VERSION}-core.zip && \
    unzip dic.zip && \
    mv sudachi-dictionary-${SUDACHI_DICT_VERSION}/system_core.dic /system_core.dic

FROM elasticsearch:${ES_VERSION}
ARG ES_VERSION
ARG ES_SUDACHI_VERSION
ARG SUDACHI_DICT_VERSION

# Install elasticsearch-sudachi and system_core.dic
COPY --from=build \
    /elasticsearch-sudachi/build/distributions/elasticsearch-${ES_VERSION}-analysis-sudachi-${ES_SUDACHI_VERSION}.zip \
    /analysis-sudachi.zip
COPY --from=build /system_core.dic config/sudachi/system_core.dic
RUN <<EOS
cat <<EOF > config/sudachi/sudachi.json
{
    "systemDict" : "system_core.dic",
    "characterDefinitionFile": "char.def",
    "inputTextPlugin" : [
        { "class" : "com.worksap.nlp.sudachi.DefaultInputTextPlugin" },
        { "class" : "com.worksap.nlp.sudachi.ProlongedSoundMarkInputTextPlugin",
          "prolongedSoundMarks": ["ー", "-", "⁓", "〜", "〰"],
          "replacementSymbol": "ー"},
	      { "class": "com.worksap.nlp.sudachi.IgnoreYomiganaPlugin",
          "leftBrackets": ["(", "（"],
          "rightBrackets": [")", "）"],
          "maxYomiganaLength": 4}
    ],
    "oovProviderPlugin" : [
        { "class" : "com.worksap.nlp.sudachi.MeCabOovProviderPlugin" },
        { "class" : "com.worksap.nlp.sudachi.SimpleOovProviderPlugin",
          "oovPOS" : [ "補助記号", "一般", "*", "*", "*", "*" ],
          "leftId" : 5968,
          "rightId" : 5968,
          "cost" : 3857 }
    ],
    "pathRewritePlugin" : [
        { "class" : "com.worksap.nlp.sudachi.JoinNumericPlugin",
          "joinKanjiNumeric" : true },
        { "class" : "com.worksap.nlp.sudachi.JoinKatakanaOovPlugin",
          "oovPOS" : [ "名詞", "普通名詞", "一般", "*", "*", "*" ],
          "minLength" : 3
        }
    ],
    "formatterPlugin" : [
      { "class" : "com.worksap.nlp.sudachi.SimpleMorphemeFormatter" },
      { "class" : "com.worksap.nlp.sudachi.WordSegmentationFormatter",
        "eos" : "\n" },
      { "class" : "com.worksap.nlp.sudachi.WordSegmentationFormatter",
        "eos" :  " " }
    ]
}
EOF
EOS
RUN mkdir -p /etc/elasticsearch/sudachi && \
    cp -r config/sudachi /etc/elasticsearch/ && \
    elasticsearch-plugin install file:///analysis-sudachi.zip
