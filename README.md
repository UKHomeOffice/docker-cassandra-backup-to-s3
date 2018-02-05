# docker-cassandra-backup-to-s3

Backs up Cassandra to an s3 bucket or to a locally accessible path.

## Environment Variables

Either specify:
* `AWS_ACCESS_KEY_ID:` AWS Access Key
* `AWS_SECRET_ACCESS_KEY` AWS Secret Access Key
* `AWS_KMS_ID` AWS KMS ID to encrypt the contents of the bucket with
* `AWS_BUCKET_NAME` The name of the AWS Bucket to backup to

Or:
* `CASSANDRA_BACKUPS` The directory to store locally accessible backups
* `RETAIN_DAYS` How many days to retain backups for

Optional variables:
* `CASSANDRA_HOST:-localhost` the cassandra host to connect to
* `CASSANDRA_PORT:-7199` The cassandra port to connect to
* `CASSANDRA_KEYSPACE:-draios` The cassandra keyspace to backup
* `CASSANDRA_DATA:-/var/lib/cassandra/data` The cassandra data directory
* `CRON_TIME_SPEC:-0    0       *       *       *` When to backup (in [cron](https://en.wikipedia.org/wiki/Cron) format)

## Restore process

Use the node restart method:
http://docs.datastax.com/en/archived/cassandra/2.0/cassandra/operations/ops_backup_noderestart_t.html
