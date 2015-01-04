Clinical
========

Clinical trials in a box

Features include:
 * Structured trials database
 * Structured document repository
 * Human ressources management
 * Groupware features / calendars + iCAL feeds
 * 100% browser based
 * Desktop-quality UI (e.g. keyboard navigation, unlimited undo / redo)
 * Fulltext search in realtime
 * Patients database / visit interval planning
 * eCRF / worksheet producer
 * Billing / Accounting / Reimbusements
 * Forms / reporting framework
 * REST API
 * Full audit trail

INSTALL
=====
```bash
# the easiest way to get Postgres up and running on a mac is Postgres.app
createdb  aug_clinical
createuser postgres -s
createuser root -s
cat sql_template.sql | psql aug_clinical
#
# we need a current TeX distribution such as <https://tug.org/mactex/>
# perl is already installed on linux and mac but we need quite a bunch of non-core perl modules
sudo perl -MCPAN -e 'install ($_) for qw/Mojolicious Mojolicious::Plugin::Database Mojolicious::Plugin::RenderFile SQL::Abstract::More Apache::Session::File Spreadsheet::WriteExcel Spreadsheet::ParseExcel Business::IBAN DBD::Pg Date::ICal Data::ICal Data::ICal::Entry::TimeZone/'
# now you can either call morbo backend.pl (testing server)
# or launch hypnotoad backend.pl during system boot
# locate your favourite web browser to http://localhost:3000/Frontend/index.html
# (you may change the port either in backend.pl or from the command line)
# the username is pi with no password
# (passwords are not enforced unless you modify the helper LDAPChallenge within backend.pl appropriately)
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

