FROM ubuntu:20.04

LABEL org.opencontainers.image.authors="Shahriar Rahat <shahriarrahat@outlook.com>"
LABEL version="1.0"
LABEL description="This is a PHP-7.4 image with sqlsrv and pdo_sqlsrv extensions along with composer and mssql-tools18. The aim of this image is to provide a easy environment to work with Laravel. "

RUN apt-get update 
RUN apt-get install -y apt-transport-https ca-certificates curl

RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc

RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update 
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18 unixodbc-dev
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.profile \
    && export PATH="$PATH:/opt/mssql-tools18/bin"

RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    php7.4 \
    php7.4-cli \
    php7.4-common \
    php7.4-xmlrpc \
    php7.4-gd \
    php-pear \
    php-dev

RUN pecl install sqlsrv-5.10.1 pdo_sqlsrv-5.10.1
RUN printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini
RUN phpenmod -v 7.4 sqlsrv pdo_sqlsrv

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN rm -rf /var/lib/apt/lists/*