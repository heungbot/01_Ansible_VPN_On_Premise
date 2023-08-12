# dynamodb output = .gz
# op_premise = .tar.gz

# eventbridge rule 만들고 s3 bucket에 upload되는 파일의 형식 중, .gz or .tar.gz file의 upload가 됐을 때만 lambda 호출
import json
import boto3
import gzip

s3 = boto3.client('s3')

def lambda_handler(event, context):
    print(event, "\n")
    bucket_name = event['detail']['bucket']['name']
    key = event['detail']['object']['key']
    if key.endswith('.gz'):
        obj = s3.get_object(Bucket=bucket_name, Key=key)
        with gzip.GzipFile(fileobj=obj['Body']) as gzipfile:
            uncompressed_data = gzipfile.read()
            new_key = 'dynamodb/unzip_data/'
            s3.put_object(Bucket=bucket_name, Key=new_key, Body=uncompressed_data) # upload unziped data to new key
            s3.delete_object(Bucket=bucket_name, Key=key) # remove old file.gz
            
    return {
        'statusCode': 200,
        'body': json.dumps('SUCCESS UNZIPPING FILE IN S3 BUCKET!!!')
    }

