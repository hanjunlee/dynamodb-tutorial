# Dynamodb tutorial

## What is covered?

- [From SQL to NoSQL](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SQLtoNoSQL.html)

## Index

1. [Set up](#set-up)
2. [Create a Table](#create-a-table)
3. [Writing Data a Table](#writing-data)
4. [Reading Data from a Table](#reading-data)
    - [GetItem](#getitem)
    - [Querying](#querying)
    - [Scaning](#scaning)
5. [Managing Indexes](#managing-indexes)

## Set up

Set up with [Dynamodb docker image](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.UsageNotes.html#DynamoDBLocal.Endpoint).

```shell
# run dynamodb service.
$ docker run -p 8000:8000 amazon/dynamodb-local:1.12.0 \
    -jar DynamoDBLocal.jar -inMemory  -sharedDb
```

```shell
# set up for the client and test the connection with the Docker container.
$ export AWS_ACCESS_KEY_ID=key; export AWS_SECRET_ACCESS_KEY=secret; export AWS_DEFAULT_REGION=ap-northeast-1;
$ export ENDPOINT=http://localhost:8000/

$ aws dynamodb list-tables --endpoint-url $ENDPOINT
{
    "TableNames": []
}
```

## Create a Table

```shell
# create the Music table.
$ aws dynamodb create-table \
    --endpoint $ENDPOINT \
    --table-name Music \
    --attribute-definitions \
        AttributeName=Artist,AttributeType=S \
        AttributeName=SongTitle,AttributeType=S \
    --key-schema \
        AttributeName=Artist,KeyType=HASH \
        AttributeName=SongTitle,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=1,WriteCapacityUnits=1 \

$ aws dynamodb list-tables --endpoint-url $ENDPOINT
{
    "TableNames": [
        "Music"
    ]
}
```

## Getting information

```shell
$ aws dynamodb describe-table --table-name Music --endpoint $ENDPOINT

{
    "Table": {
        "AttributeDefinitions": [
            {
                "AttributeName": "Artist",
                "AttributeType": "S"
            },
            {
                "AttributeName": "SongTitle",
                "AttributeType": "S"
            }
        ],
        "TableName": "Music",
        "KeySchema": [
            {
                "AttributeName": "Artist",
                "KeyType": "HASH"
            },
            {
                "AttributeName": "SongTitle",
                "KeyType": "RANGE"
            }
        ],
        ...
    }
}
```

## Writing data

Seed datas same as [doc](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SQLtoNoSQL.WriteData.html).

```shell
$ sh scripts/seed.sh
```

## Reading data

There are three options to read data in DynamoDB([doc](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SQLtoNoSQL.ReadData.html)).

### GetItem

Retrieves a single item from a table. 

```shell
# the entire item with all of its attributes.
$ aws dynamodb get-item --endpoint $ENDPOINT \
    --consistent-read \
    --table-name Music \
    --key \
        '{ 
            "Artist": {"S": "No One You Know"}, 
            "SongTitle": {"S": "Call Me Today"}
        }'

# add a ProjectionExpression parameter to return only some of the attributes.
$ aws dynamodb get-item --endpoint $ENDPOINT \
    --consistent-read \
    --table-name Music \
    --projection-expression "AlbumTitle,Price" \
    --key \
        '{ 
            "Artist": {"S": "No One You Know"}, 
            "SongTitle": {"S": "Call Me Today"}
        }'
    
```

### Querying

You can use Query with **any table that has a composite primary key (partition key and sort key).** You must specify an equality condition for the partition key, and you can optionally provide another condition for the sort key.

`KeyConditionExpression` parameter specifies the key values that you want to query.

```shell
$ aws dynamodb query \
    --endpoint $ENDPOINT \
    --table-name Music \
    --key-condition-expression "Artist = :a and SongTitle = :t" \
    --expression-attribute-values \
        '{
            ":a": {"S":"No One You Know"},
            ":t": {"S":"Call Me Today"}
        }'

# return all of the songs by an artist
$ aws dynamodb query \
    --endpoint $ENDPOINT \
    --table-name Music \
    --key-condition-expression "Artist = :a" \
    --expression-attribute-values \
        '{
            ":a": {"S":"No One You Know"}
        }'
```

### Scaning

Retrieves all of the items, but it support `FilterExpression` parameter, which you can use to discard items.

## Managing indexes
