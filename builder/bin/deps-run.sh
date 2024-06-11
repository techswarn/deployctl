#!/bin/bash

set -e
set -x

cat >>/etc/apt/sources.list.d/pgdb.list <<EOF
deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main
EOF

apt-get install -y --no-install-recommends curl ca-certificates gnupg
curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

apt-get update

# The majority of these packages are self explanatory from their names.
# Some less obvious ones are commented on below.
# In general, these packages widen the set of supported applications trading off final, image size, and security.
# This list is something we can play around with changing going forward as we better understand the types of workloads customers are running.
apt-get install -y --no-install-recommends \
    apt-transport-https \
    apt-utils \
    bind9-host \
    bzip2 \
    coreutils \
    curl \
    dnsutils \
    ed \
    file \
    fontconfig \
    gcc \
    geoip-database \
    ghostscript \
    git \
    gsfonts \
    imagemagick \
    iproute2 \
    iputils-tracepath \
    language-pack-en \
    less \
    # argon2 hashing function
    libargon2-0 \
    libc-client2007e \
    libcairo2 \
    # css manipulation library
    libcroco3 \
    libcurl4 \
    # trie datastructure implementation
    libdatrie1 \
    libev4 \
    libevent-2.1-6 \
    libevent-core-2.1-6 \
    libevent-extra-2.1-6 \
    libevent-openssl-2.1-6 \
    libevent-pthreads-2.1-6 \
    libexif12 \
    libgd3 \
    libgdk-pixbuf2.0-0 \
    libgdk-pixbuf2.0-common \
    libgnutls-openssl27 \
    libgnutlsxx28 \
    libgraphite2-3 \
    libgs9 \
    libharfbuzz0b \
    libmagickcore-6.q16-3-extra \
    libmcrypt4 \
    libmemcached11 \
    libmysqlclient20 \
    # regular expression library
    libonig4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libpangoft2-1.0-0 \
    libpixman-1-0 \
    librabbitmq4 \
    librsvg2-2 \
    librsvg2-common \
    libsasl2-modules \
    libseccomp2 \
    libsodium23 \
    # thai language support (not sure why this is included in heroku's images), but I wonder if it's a dependency for something else
    libthai-data \
    libthai0 \
    libuv1 \
    libxcb-render0 \
    libxcb-shm0 \
    libxrender1 \
    libxslt1.1 \
    libzip4 \
    locales \
    lsb-release \
    make \
    netcat-openbsd \
    openssh-client \
    openssh-server \
    patch \
    postgresql-client-12 \
    python \
    rename \
    rsync \
    ruby \
    shared-mime-info \
    socat \
    stunnel \
    syslinux \
    tar \
    telnet \
    tzdata \
    unzip \
    wget \
    xz-utils \
    zip \


cat > /etc/ImageMagick-6/policy.xml <<'IMAGEMAGICK_POLICY'
<policymap>
  <policy domain="resource" name="memory" value="256MiB"/>
  <policy domain="resource" name="map" value="512MiB"/>
  <policy domain="resource" name="width" value="16KP"/>
  <policy domain="resource" name="height" value="16KP"/>
  <policy domain="resource" name="area" value="128MB"/>
  <policy domain="resource" name="disk" value="1GiB"/>
  <policy domain="delegate" rights="none" pattern="URL" />
  <policy domain="delegate" rights="none" pattern="HTTPS" />
  <policy domain="delegate" rights="none" pattern="HTTP" />
  <policy domain="path" rights="none" pattern="@*"/>
  <policy domain="cache" name="shared-secret" value="passphrase" stealth="true"/>
</policymap>
IMAGEMAGICK_POLICY

# install the JDK for certificates, then remove it
apt-get install -y --no-install-recommends ca-certificates-java openjdk-8-jre-headless
apt-get remove -y ca-certificates-java
apt-get -y --purge autoremove
apt-get purge -y openjdk-8-jre-headless
test "$(file -b /etc/ssl/certs/java/cacerts)" = "Java KeyStore"