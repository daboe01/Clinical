/etc/init.d/postgresql start && perl /app/Clinical/backend.pl prefork -m production -l http://*:3004 -w 10
