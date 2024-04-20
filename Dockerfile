FROM ubuntu:14.04 as ruby-1.8.7

RUN apt-get update && apt-get install -y build-essential wget

# build zlib statically
WORKDIR /tmp
RUN wget https://zlib.net/fossils/zlib-1.2.11.tar.gz && \
    tar -xzvf zlib-1.2.11.tar.gz && \
    rm zlib-1.2.11.tar.gz && \
    cd zlib-1.2.11 && \
    ./configure && \
    make && \
    make install && \
    rm -rf /tmp/zlib-1.2.11

# build openssl statically
WORKDIR /tmp
RUN wget https://www.openssl.org/source/openssl-1.0.2u.tar.gz && \
    tar -xzvf openssl-1.0.2u.tar.gz && \
    rm openssl-1.0.2u.tar.gz && \
    cd openssl-1.0.2u && \
    ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl zlib no-threads shared && \
    make && \
    make install_sw && \
    rm -rf /tmp/openssl-1.0.2u

# install ruby 1.8.7
WORKDIR /tmp
RUN wget https://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.gz && \
    tar -xzvf ruby-1.8.7-p374.tar.gz && \
    rm ruby-1.8.7-p374.tar.gz && \
    cd ruby-1.8.7-p374 && \
    # cd ext/openssl && \
    # ruby extconf.rb && cd /tmp/ruby-1.8.7-p374 && \
    # sed -i 's/$extobjs = "ext\/#{extinit.o} #{$extobjs}"/$extobjs = "#{$extobjs} libz.a libcrypto.a libssl.a"/' ext/extmk.rb && \
    # CFLAGS="-I/usr/local/ssl/include" LDFLAGS="-L/usr/local/ssl/lib" ./configure \
    ./configure \
    --build=$(uname -m)-unknown-linux-gnu \
    --with-openssl-dir=/usr/local/ssl \
    && \
    make && \
    make install && \
    rm -rf /tmp/ruby-1.8.7-p374


# install rubygems 1.8.30
WORKDIR /tmp
# RUN wget https://rubygems.org/rubygems/rubygems-1.8.30.tgz && \
RUN wget https://github.com/rubygems/rubygems/releases/download/v1.8.30/rubygems-1.8.30.tgz && \
    tar -xzvf rubygems-1.8.30.tgz && \
    rm rubygems-1.8.30.tgz && \
    cd rubygems-1.8.30 && \
    ruby setup.rb && \
    rm -rf /tmp/rubygems-1.8.30

# install rake 0.8.7
WORKDIR /tmp
RUN apt-get install -y ca-certificates
ENV SSL_CERT_FILE=/etc/ssl/cert.pem
RUN apt-get install -y zip unzip
# RUN gem install rake -v '11.3.0'
RUN gem sources
# RUN gem sources -r http://gems.rubyforge.org/
# RUN gem sources -a https://rubygems.org/
RUN gem install bundler -v '1.17.3'
RUN gem install rake -v '0.8.7'
FROM ruby-1.8.7 as crate
WORKDIR /app
RUN gem install amalgalite -v '1.3.0' --no-ri --no-rdoc
RUN gem install flexmock -v '0.8.2' --no-ri --no-rdoc
RUN gem install logging -v '0.9.7' --no-ri --no-rdoc
RUN gem install minitar -v '0.6' --no-ri --no-rdoc
RUN apt-get install git -y
COPY bin /app/bin
COPY lib /app/lib
COPY data /app/data
COPY spec /app/spec
COPY tasks /app/tasks
COPY Rakefile /app
COPY Gemfile /app
COPY Gemfile.lock /app
COPY crate.gemspec /app
# because gemspec uses git ls-files
RUN git init
RUN git add .
RUN bundle version
RUN bundle install
RUN rake install
RUN crate new
WORKDIR /app/new
# RUN bundle exec rake openssl:build
# RUN bundle exec rake openssl:install
# RUN ls /app/new/build/openssl/openssl-0.9.8j/*
RUN apt-get install git autoconf bison byacc gperf  -y

RUN rake ruby
RUN ls /app/new/fakeroot/usr/lib/*
RUN ls /app/new/fakeroot/usr/lib/ruby/*
COPY application.rb /app/new
RUN cp /usr/local/lib/ruby/1.8/aarch64-linux/openssl.so /app/new/fakeroot/usr/lib/ruby/1.8/aarch64-linux/
RUN rake
WORKDIR /app/new/dist
RUN ./mycrateapp
ENTRYPOINT [ "/app/new/dist/mycrateapp" ]
# we need openssl 1.0.x as 0.9.x not supported by modern clients
# rubygems 1.3.1 used rubyforge.org as source, which is no longer available