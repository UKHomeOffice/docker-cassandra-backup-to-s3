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

To do this in kubernetes you will need to:

1. Deploy the petset with:
```
command:
  - sh
  - "-c"
  - sleep 100000000
```

2. Exec into each PetSet
```
kubectl exec -it cassandra-0 -c backup bash
```

3. Copy the revelant file from S3
```
cd /var/lib/cassandra/
aws s3 cp --sse-kms-key-id ${AWS_KMS_ID} --sse aws:kms s3://${AWS_BUCKET_NAME}/${FILENAME} .

rm -rf /var/lib/cassandra/commitlog/*

find /var/lib/cassandra/data/draios -name *.db -exec rm -f {} \;

tar zxvf ${FILENAME}

for f in $(ls /var/lib/cassandra/var/lib/cassandra/data/draios/)
do
mv /var/lib/cassandra/var/lib/cassandra/data/draios/$f .
done

cd /var/lib/cassandra/data/draios
for f in $(ls)
do
mv $f/snapshots/20170509_0000/* $f/.
rm -rf $f/snapshots/20170509_0000
done

rm -rf /var/lib/cassandra/cassandra*.tar.gz /var/lib/cassandra/var
chown -R 999:ping /var/lib/cassandra/data/draios/
```

4. Redeploy petset without the sleep command

5. Exec into each pod and run repair:
```
kubectl exec -it cassandra-0 -c cassandra bash
nodetool repair
```
