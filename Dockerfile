FROM ubuntu:18.04

MAINTAINER daboe01

COPY cpanfile /

ENV EV_EXTRA_DEFS -DEV_NO_ATFORK
ENV DEBIAN_FRONTEND=noninteractive 

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list && apt-get update && apt-get install make g++ curl wget checkinstall -y && apt-get build-dep texlive -y

RUN apt-get update && \
  apt-get install perl imagemagick perlmagick cpanminus libio-socket-ssl-perl postgresql-10 libdbd-pg-perl r-base r-recommended -y && \
  cpanm -v -f --installdeps . -M https://cpan.metacpan.org && \
  apt-get remove make g++ wget curl -y && \
  rm -rf /root/.cpanm/* /usr/local/share/man/*

RUN mkdir /app
COPY . /app

RUN echo "local all  all  trust" > /etc/postgresql/10/main/pg_hba.conf
RUN echo "host  all  all  127.0.0.1/32 trust" >> /etc/postgresql/10/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf

RUN /etc/init.d/postgresql start &&\
    psql -U postgres --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -U docker aug_clinical && cat /app/sql_template.sql | psql -U docker aug_clinical


# USER daemon
WORKDIR /app
# VOLUME ["/data"]
EXPOSE 3004

ENTRYPOINT "/app/entrypoint.sh"
