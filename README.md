# Clinical trials in a box

Features include:
 * 100% browser based
 * High quality GUI (incl. keyboard navigation, unlimited undo / redo)
 * State tracking trials database
 * Per trial document repository
 * Per trial subject log
 * Fulltext search in realtime
 * Human ressources management (working hours, holidays, certificate repos)
 * Groupware (personalized calendar / iCAL, meetings)
 * Visit interval planning (incl. cross-checks with human ressources)
 * Source data management / worksheets
 * Billing / Accounting / Reimbursements
 * Finances controlling
 * Forms / reporting framework
 * RESTful API
 * Full audit trail

Manual: https://github.com/daboe01/ClinicalManual/blob/master/manual.pdf?raw=true

Via Docker
=====
```bash
docker run -t -i  -p 3004:3004 daboe01/clinical:latest
```

> ⚠️ **Warning on Volatility:** This default demo container is completely **volatile**. Any changes you make or data you input will exist only within the container's temporary read-write layer. If the container is stopped and deleted (such as via `docker rm`), all your data will be permanently lost. Do not use this default command for production or persistent data collection.

How to make the database permanent
----------------------------------

### Method 1: Persistent Docker Named Volume (Easiest)
You can direct Docker to store the PostgreSQL database files in a named volume. Unlike the default container filesystem, data in a named volume persists even when the container is stopped, updated, or deleted. Docker will automatically copy the pre-initialized database template into the volume upon its first creation.

Run the container with the `-v` volume flag:
```bash
docker run -t -i -p 3004:3004 -v clinical_pgdata:/var/lib/postgresql/10/main daboe01/clinical:latest
```

### Method 2: Connect to an External PostgreSQL Database (Recommended for Production)
For production environments, running PostgreSQL inside the same container as the web server is generally discouraged. Instead, configure the application container to communicate with an external PostgreSQL instance (running natively on your host machine, on another cloud instance, or in a dedicated database container).

1. Set up a secure external PostgreSQL instance and restore the schema manually on your host:
   ```bash
   createdb aug_clinical
   cat sql_template.sql | psql aug_clinical
   ```
2. Update the database connection string, host, port, and credentials in your configuration file (`backend.pl`).
3. Bind-mount your customized `backend.pl` configuration into the container when launching:
   ```bash
   docker run -t -i -p 3004:3004 -v /absolute/path/to/your/backend.pl:/app/backend.pl daboe01/clinical:latest
   ```

BARE METAL INSTALL
=====
```bash
# you need build-essentials (linux) or XCode (mac)
# the easiest way to get Postgres up and running on a mac is Postgres.app
# (on linux do not forget to additionally install the postgres-dev package)
createdb  aug_clinical
createuser postgres -s
createuser root -s
cat sql_template.sql | psql aug_clinical
#
# we need a current TeX distribution such as <https://tug.org/mactex/>
# perl is already installed on linux and mac but we need quite a bunch of non-core perl modules
cpan Math::Expression String::Random Mojolicious Mojolicious::Plugin::Database Mojolicious::Plugin::RenderFile SQL::Abstract::More Apache::Session::File Spreadsheet::WriteExcel Spreadsheet::ParseExcel Business::IBAN DBD::Pg Date::ICal Data::ICal Data::ICal::Entry::TimeZone Net::LDAP DateTime File::Find::Rule MIME::Lite Net::IMAP::Simple Email::MIME Email::MIME::Attachment::Stripper
# now download this repo and cd into it
# change the constants on the top of this file as needed
# this includes the directory paths, passwords and the database connection string:
vi backend.pl
# now you are ready to launch
morbo backend.pl # this starts the testing server
# now locate your favourite web browser to http://localhost:3000/Frontend/index.html
# the username is pi with no password
# (passwords are not enforced unless you modify the helper LDAPChallenge within backend.pl appropriately)
#
# you may eventually want to automatically launch hypnotoad backend.pl (production server) during system boot
```

Update database schema
=====
```bash
# from github
pg_dump aug_clinical_incoming -s  >sql_template_new.sql 
# from production
pg_dump aug_clinical -s  >sql_template_old.sql 
java -jar apgdiff-2.4/apgdiff-2.4.jar sql_template_old.sql sql_template_new.sql > diff.sql
psql -d aug_clinical -a -f diff.sql
```

LICENCE
=====
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
