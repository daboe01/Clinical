FROM ubuntu:18.04

MAINTAINER daboe01

COPY cpanfile /

ENV EV_EXTRA_DEFS -DEV_NO_ATFORK

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && apt-get update && apt-get install make g++ curl wget checkinstall pdftk -y && apt-get build-dep texlive -y

RUN apt-get update && \
  apt-get install perl imagemagick perlmagick cpanminus libio-socket-ssl-perl postgresql-10 libdbd-pg-perl r-base r-recommended -y && \
  export cpanm -v -f --installdeps . -M https://cpan.metacpan.org && \
  apt-get remove make g++ wget curl -y && \
  rm -rf /root/.cpanm/* /usr/local/share/man/*

RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker aug_clinical

RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf


RUN mkdir /app
# USER daemon
WORKDIR /app
# VOLUME ["/data"]
EXPOSE 3000

COPY . /app

RUN cat /app/sql_template.sql | psql aug_clinical && rm /app/sql_template.sql

ENTRYPOINT "/app/entrypoint.sh"
