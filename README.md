Clinical
========

Clinical trials administration system

Features include:
 * Trials database
 * Document repository
 * Visit management
 * Cost calculation
 * Event tracker
 * Team calendar
 * Full text search
 * Password manager
 * Document (form) generator
 * Billing/reimbursements
 * Accounting
 * Reporting framework
 * Archive management

INSTALL
=====
```bash
# the easiest way to get Postgres up and running on a mac is Postgres.app
/Applications/Postgres.app/Contents/Versions/9.3/bin/createdb  aug_clinical
/Applications/Postgres.app/Contents/Versions/9.3/bin/createuser postgres -s
/Applications/Postgres.app/Contents/Versions/9.3/bin/createuser root -s
cat sql_template.sql | /Applications/Postgres.app/Contents/Versions/9.3/bin/psql aug_clinical
#
# we need a current TeX distribution such as <https://tug.org/mactex/>
# perl is already installed on linux and mac but we need quite a bunch of non-core perl modules
sudo perl -MCPAN -e 'install ($_) for qw/Mojolicious Mojolicious::Plugin::Database Mojolicious::Plugin::RenderFile SQL::Abstract::More Apache::Session::File JSON::XS Spreadsheet::WriteExcel Spreadsheet::ParseExcel Business::IBAN DBD::Pg/'
# now you can either call morbo backend.pl (testing server)
# or launch hypnotoad backend.pl during system boot
# locate your favourite web browser to http://localhost:3000/Frontend/index.html
# (you may change the port either in backend.pl or from the command line)
# the username is pi with no password
# (passwords are not enforced unless you modify the helper LDAPChallenge with backend.pl appropriately)
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

