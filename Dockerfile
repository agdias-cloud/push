FROM busybox AS builder
COPY tomcat/apache-tomcat-9.0.94.zip /tmp
WORKDIR /tomcat
RUN unzip -d /tomcat/ /tmp/apache-tomcat-9.0.94.zip


FROM adoptopenjdk/openjdk8
WORKDIR /opt/tomcat
COPY  --from=builder /tomcat/ .

