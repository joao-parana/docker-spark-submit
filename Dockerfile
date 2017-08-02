FROM openjdk:8-alpine

LABEL maintainer="Arseniy Tashoyan <tashoyan@gmail.com>"

RUN apk --update add git curl tar bash ncurses && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

ARG SBT_VERSION=0.13.13
ARG SBT_HOME=/usr/local/sbt-launcher-packaging-$SBT_VERSION
RUN curl -sL "http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz" | tar -xz -C /usr/local

ARG SPARK_VERSION=2.2.0
ARG SPARK_HOME=/usr/local/spark-$SPARK_VERSION-bin-hadoop2.7
RUN curl -sL "http://www-us.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" | tar -xz -C /usr/local

#TODO Expose driver ports
ENV PATH $PATH:$SBT_HOME/bin:$SPARK_HOME/bin
ENV SPARK_MASTER local[*]
COPY run.sh /
CMD ./run.sh
