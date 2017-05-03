# docker-cassandra-backup-to-s3

Backs up cassandra to an s3 bucket daily

## Environment Variables

* `AWS_ACCESS_KEY_ID:` AWS Access Key
* `AWS_SECRET_ACCESS_KEY` AWS Secret Access Key
* `AWS_KMS_ID` AWS KMS ID to encrypt the contents of the bucket with
* `AWS_BUCKET_NAME` The name of the AWS Bucket to backup to
* `CASSANDRA_HOST:-localhost` the cassandra host to connect to
* `CASSANDRA_PORT:-7199` The cassandra port to connect to
* `CASSANDRA_KEYSPACE:-draios` The cassandra keyspace to backup
* `CASSANDRA_DATA:-/var/lib/cassandra/data` The cassandra data directory

## Restore process

Use the node restart method:
http://docs.datastax.com/en/archived/cassandra/2.0/cassandra/operations/ops_backup_noderestart_t.html
