import json

def lambda_handler(event, context):
    print("Lambda function executed by cron job")
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
