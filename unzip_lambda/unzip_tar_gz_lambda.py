# s3 bucket suffix를 통해 tar.gz file이 upload 되었을 경우에만 본 lambda trigger 됨.
import boto3
import json
import tarfile
from io import BytesIO

s3 = boto3.client('s3')

def lambda_handler(event, context):
    
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    
    # 만약 on_premise에서 오는 tar.gz file이 아닌 경우?
    
    
    input_tar_file = s3.get_object(Bucket = bucket_name, Key = file_key)
    input_tar_content = input_tar_file['Body'].read()
    
    with tarfile.open(fileobj = BytesIO(input_tar_content)) as tar: # with ... as : file stream 다루기 위한 기능. with as 구문이 끝나면 file close() 따로 호출할 필요 없음
        for tar_resource in tar:
            if (tar_resource.isfile()):
                inner_file_bytes = tar.extractfile(tar_resource).read()
                new_key = 'on-premise-data/unzip_data/' + tar_resource.name
                s3.upload_fileobj(BytesIO(inner_file_bytes), Bucket = bucket_name, Key = new_key) 
                print("File untared. Check " + new_key + " prefix in " + bucket_name)
    return {
        'statusCode': 200,
        'body': json.dumps('SUCCESS UNTAR FILE')
    } 
    
    # 파일 확장자 확인
    extension = os.path.splitext(file_name)[1]
    
    if file_name.endswith("tar.gz"):
        tar_file = tarfile.open(file_name, "r:gz")
        tar_file.extractall("./tmp")
        tar.close()
        
    elif file_name.endswith("tar"):
        tar = tarfile.open(file_name, "r:")
        tar.extractall()
        tar.close()
        
   
    
    # # .zip 또는 .gzip 파일이 아닌 경우 함수 종료
    # if extension not in ['.zip', '.gzip']:
    #     return {
    #         'statusCode': 400,
    #         'body': 'Unsupported file type'
    #     }

    
    # # S3에서 파일 다운로드
    # s3.download_file(bucket_name, file_name, '/tmp/' + file_name)
    
    # # .zip 파일인 경우 압축 해제
    # if extension == '.zip':
    #     with zipfile.ZipFile('/tmp/' + file_name, 'r') as zip_ref:
    #         zip_ref.extractall('/tmp/')
    
    # # .gzip 파일인 경우 압축 해제
    # if extension == '.gzip':
    #     with gzip.open('/tmp/' + file_name, 'rb') as f_in:
    #         with open('/tmp/' + os.path.splitext(file_name)[0], 'wb') as f_out:
    #             f_out.write(f_in.read())

