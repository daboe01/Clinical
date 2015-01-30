Clinical trials in a box
========

Features include:
 * 100% browser based
 * High quality UI (e.g. keyboard navigation, unlimited undo / redo)
 * Structured trials database
 * Per trial document repository
 * Per trial subject log
 * Fulltext search in realtime
 * Human ressources management (working hours, holidays, certificate repos)
 * Groupware (personalized calendar / iCAL feed, meetings)
 * Visit interval planning (incl. cross-checks with human ressources)
 * Source data management / worksheets
 * Billing / Accounting / Reimbursements
 * Finances controlling
 * Forms / reporting framework
 * RESTful API
 * Full audit trail

INSTALL
=====
```bash
# the easiest way to get Postgres up and running on a mac is Postgres.app
# (on linux do not forget to additionally install the postgres-dev package)
createdb  aug_clinical
createuser postgres -s
createuser root -s
cat sql_template.sql | psql aug_clinical
#
# we need a current TeX distribution such as <https://tug.org/mactex/>
# perl is already installed on linux and mac but we need quite a bunch of non-core perl modules
curl -L https://cpanmin.us | perl - -M https://cpan.metacpan.org -n Mojolicious Mojolicious::Plugin::Database Mojolicious::Plugin::RenderFile SQL::Abstract::More Apache::Session::File Spreadsheet::WriteExcel Spreadsheet::ParseExcel Business::IBAN DBD::Pg Date::ICal Data::ICal Data::ICal::Entry::TimeZone Net::LDAP DateTime File::Find::Rule
# now download this repo and cd into it
morbo backend.pl # this starts the testing server
# now locate your favourite web browser to http://localhost:3000/Frontend/index.html
# the username is pi with no password
# (passwords are not enforced unless you modify the helper LDAPChallenge within backend.pl appropriately)
#
# you may eventually want to automatically launch hypnotoad backend.pl (production server) during system boot
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

