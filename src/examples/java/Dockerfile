FROM maven:3.8.1-openjdk-17-slim

WORKDIR /code/src/examples/java
ADD pom.xml /code/src/examples/java/pom.xml
RUN mvn install
