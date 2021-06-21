FROM adoptopenjdk/openjdk11-openj9:latest AS build
ADD . /src
WORKDIR /src
RUN ./gradlew service:clean service:build

FROM adoptopenjdk:11-jre-hotspot
EXPOSE 9194


COPY --from=build /src/service/build/libs/service-*boot.jar /usr/local/bin/service.jar
HEALTHCHECK --retries=12 --interval=10s CMD curl -s localhost:9194/health || exit 1
RUN chmod +x /usr/local/bin/service.jar
ENTRYPOINT ["java", "-jar", "/usr/local/bin/service.jar"]