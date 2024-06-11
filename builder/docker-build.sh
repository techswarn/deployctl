#build
docker build --platform="linux/amd64" --no-cache -f Dockerfile.build -t swarntech/appship-build:ubuntu-22 .
docker build --platform="linux/amd64" --no-cache -f Dockerfile.run -t swarntech/appship-run:ubuntu-22 .
pack builder create swarntech/appship-buildpacks:ubuntu-22 --config ./builder.toml
docker tag swarntech/appship-buildpacks:ubuntu-22 swarntech/appship-buildpacks:latest
docker push swarntech/appship-buildpacks:ubuntu-22
docker build --platform="linux/amd64" --no-cache -f Dockerfile.builder -t swarntech/appship-builder:latest .

#publish
docker push swarntech/appship-build:ubuntu-22
docker push swarntech/appship-run:ubuntu-22
docker push swarntech/appship-builder:latest