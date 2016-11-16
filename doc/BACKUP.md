#### One Maths Backup strategies

Backup system designed as per the following tutorial: http://vladigleba.com/blog/2014/06/30/backup-a-rails-database-with-the-backup-and-whenever-gems/

----
To restore from backup file (.sql)

`psql -U <database_username> -d one_maths_development -f local/path/to/your/file.sql`


Useful link:

- http://blog.bigbinary.com/2016/06/07/rails-5-prevents-destructive-action-on-production-db.html
- https://martinschurig.com/posts/2015/02/pulling-production-database-to-local-machine-rails-task/
- https://robots.thoughtbot.com/recover-data-from-production-backups-with-activerecord
- http://stackoverflow.com/questions/23899442/import-dump-sql-file-into-my-postgresql-database-on-linode
- https://www.postgresql.org/docs/9.6/static/app-pgdump.html
- http://postgresguide.com/utilities/backup-restore.html
- http://alvinalexander.com/blog/post/postgresql/log-in-postgresql-database
- http://askubuntu.com/questions/256534/how-do-i-find-the-path-to-pg-hba-conf-from-the-shell
- https://www.theguild.nl/backup-postgresql-from-a-rails-project-to-amazon-s3/
