# syntax=docker/dockerfile:1
FROM alpine

RUN apk update && \
    apk add openjdk11-jre

EXPOSE 8071

ENV APP_PORT=8071

COPY . /app
WORKDIR /app

ENTRYPOINT ["java", "-jar", "user-microservice-0.1.0.jar"]
