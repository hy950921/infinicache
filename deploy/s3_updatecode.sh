#!/bin/bash

PWD=`dirname $0`
PREFIX="Proxy2Node"
KEY="redeo_lambda"
cluster=400
mem=1536

S3="ao.lambda.code"

echo "compiling lambda code..."
GOOS=linux go build $PWD/$KEY.go
echo "compress file..."
zip $KEY $KEY
echo "updating lambda code.."

echo "putting code zip to s3"
aws s3api put-object --bucket ${S3} --key $KEY.zip --body $KEY.zip

go run $PWD/../../sbin/deploy_function.go -S3 ${S3} -code=true -config=true -prefix=$PREFIX -vpc=true -key=$KEY -cluster=$cluster -mem=$mem -timeout=$1\
go clean