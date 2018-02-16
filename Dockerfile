FROM php:7.1

MAINTAINER Glofox <glofox@glofox.com>

RUN apt-get update

RUN wget http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar -O php-cs-fixer.phar  \
    && chmod +x php-cs-fixer.phar \
    && mv php-cs-fixer.phar /usr/bin/php-cs-fixer

RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && chmod +x phpcs.phar \
    && mv phpcs.phar /usr/bin/phpcs

RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
    && chmod +x phpcbf.phar \
    && mv phpcbf.phar /usr/bin/phpcbf

RUN wget -c http://static.phpmd.org/php/latest/phpmd.phar \
    && chmod +x phpmd.phar \
    && mv phpmd.phar /usr/bin/phpmd

RUN wget https://phar.phpunit.de/phpcpd.phar \
    && chmod +x phpcpd.phar \
    && mv phpcpd.phar /usr/bin/phpcpd