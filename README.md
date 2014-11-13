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
=======
```bash
/Applications/Postgres.app/Contents/Versions/9.3/bin/dropdb  aug_clinical
/Applications/Postgres.app/Contents/Versions/9.3/bin/createdb  aug_clinical
/Applications/Postgres.app/Contents/Versions/9.3/bin/createuser postgres -s
/Applications/Postgres.app/Contents/Versions/9.3/bin/createuser root -s
cat sql_template.sql | /Applications/Postgres.app/Contents/Versions/9.3/bin/psql aug_clinical
sudo perl -MCPAN -e 'install ($_) for qw/Mojolicious Mojolicious::Plugin::Database Mojolicious::Plugin::RenderFile SQL::Abstract::More Apache::Session::File JSON::XS Spreadsheet::WriteExcel Spreadsheet::ParseExcel Business::IBAN DBD::Pg/'
```

LICENCE:
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

