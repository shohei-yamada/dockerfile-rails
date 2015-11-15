FROM centos
MAINTAINER teamY_ <ymd.mobi@gmail.com>
RUN yum -y install wget
RUN yum -y install tar
RUN yum -y groupinstall 'Development tools'
RUN yum -y install sqlite-devel
RUN yum -y install net-tools
RUN yum -y install readline-devel

# ruby2.1.2インストール
RUN cd /usr/local/src && \
    wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz && \
    tar zxvf ruby-2.1.2.tar.gz && \
    cd ruby-2.1.2 && \
    ./configure && \
    make && \
    make install

# gemのupdate時にzlibが必要とエラーになるためzlibをインストール
RUN yum install -y zlib-devel
RUN cd /usr/local/src/ruby-2.1.2/ext/zlib && \
    ruby extconf.rb && \
    make && \
    make install

# gemのupdate時にopensslが必要とエラーになるためインストール
# Makefileに間違いがあるので修正する。
RUN yum -y install openssl-devel
RUN cd /usr/local/src/ruby-2.1.2/ext/openssl && \
    ruby extconf.rb && \
    sed -i -e "15i top_srcdir = /usr/local/src/ruby-2.1.2" Makefile && \
    make && \
    make install

# "ruby console"が使えないための対応
RUN cd /usr/local/src/ruby-2.1.2/ext/readline && \
    ruby extconf.rb && \
    make && \
    make install

RUN gem update --system
RUN gem install rails -v 4.1.5
RUN bundle install
