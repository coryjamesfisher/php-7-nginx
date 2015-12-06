FROM ubuntu:latest
MAINTAINER Cory Fisher <coryjamesfisher@gmail.com>

ADD start.sh /

RUN apt-get update && \
	apt-get install -y build-essential git autoconf bison libxml2 libxml2-dev libcurl4-openssl-dev nginx && \
	mkdir /root/build && \
	git clone --depth=1 --single-branch -b master https://git.php.net/repository/php-src.git /root/build/php && \
        cd /root/build/php && \
        ./buildconf && \
        ./configure \
          --prefix=/opt/php \
          --with-config-file-path=/opt/php \
          --enable-fpm \
          --with-openssl \
          --with-openssl-dir=/usr/bin \
          --enable-phpdbg && \
	make && \
	make install; \
	groupadd nobody && \
	cp /opt/php/etc/php-fpm.conf.default /opt/php/etc/php-fpm.conf && \
	cp /opt/php/etc/php-fpm.d/www.conf.default /opt/php/etc/php-fpm.d/www.conf && \
        ln -s /opt/php/bin/php /usr/bin/php && \
	chmod +x /start.sh; exit 0

EXPOSE 80

CMD ["/start.sh"]
