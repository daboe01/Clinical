# DOCKER-VERSION 1.6.0
FROM        perl:latest
MAINTAINER  Daniel daboe01@googlemail.com

RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm Mojolicious Mojolicious::Plugin::Database Mojolicious::Plugin::RenderFile SQL::Abstract::More Apache::Session::File Spreadsheet::WriteExcel Spreadsheet::ParseExcel Business::IBAN DBD::Pg Date::ICal Data::ICal Data::ICal::Entry::TimeZone Net::LDAP DateTime File::Find::Rule MIME::Lite Net::IMAP::Simple Email::MIME Email::MIME::Attachment::Stripper

RUN git clone https://github.com/daboe01/Clinical
RUN cd Clinical

EXPOSE 3000

WORKDIR Clinical
CMD morbo backend.pl
