import json
import boto3
import gzip

s3 = boto3.client('s3')

def lambda_handler(event, context):
    print(event, "\n")
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    print(bucket_name, "\n", key)

    if key.endswith('.gz'):
        obj = s3.get_object(Bucket=bucket_name, Key=key)
        print("start unzip process")
        with gzip.GzipFile(fileobj=obj['Body']) as gzipfile:
            uncompressed_data = gzipfile.read()
            filename=key.split("/")[-1].split(".")[0]
            new_key = 'dynamodb/unzip_data/' + filename
            s3.put_object(Bucket=bucket_name, Key=new_key, Body=uncompressed_data) # upload unziped data to new key
            print("end of unzipping process")
            
    return {
        'statusCode': 200,
        'body': json.dumps('SUCCESS UNZIPPING FILE IN S3 BUCKET!!!')
    }
