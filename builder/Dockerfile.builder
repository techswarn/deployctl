FROM swarntech/appship-buildpacks:ubuntu-22

COPY bin/build.sh /bin/build.sh
COPY bin/build-kaniko.sh /bin/build-kaniko.sh
COPY bin/build-buildpacks.sh /bin/build-buildpacks.sh

ENTRYPOINT ["/bin/build.sh"]