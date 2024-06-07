FROM gcr.io/kaniko-project/executor:v0.17.1 AS kaniko

FROM nanzhong/appsail-buildpacks:ubuntu-18

COPY --from=kaniko /kaniko /kaniko
ENV PATH="${PATH}:/kaniko"

COPY bin/build.sh /bin/build.sh
COPY bin/build-kaniko.sh /bin/build-kaniko.sh
COPY bin/build-buildpacks.sh /bin/build-buildpacks.sh

ENTRYPOINT ["/bin/build.sh"]