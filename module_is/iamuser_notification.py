import boto3
import botocore
from datetime import datetime
from datetime import date
import json
import os

a = os.environ['snsarn']
b = a.split(':')[-2]
iam_client = boto3.client('iam')
sns_client = boto3.client('sns')
response1 = iam_client.list_users()
def lambda_handler(event, context):
    # TODO implement
    for i in response1['Users']:
        response7 = iam_client.get_user(UserName = i['UserName'])
        response2 = iam_client.list_access_keys(UserName = i['UserName'])
        for j in response2['AccessKeyMetadata']:
            response3 = iam_client.get_access_key_last_used(AccessKeyId = j['AccessKeyId'])
            create_day = j['CreateDate'].date()
            elapsed_days = (date.today() - j['CreateDate'].date()).days
            user_name = j['UserName']
            access_key_id = j['AccessKeyId']
            key_status = j['Status']
            if 'LastUsedDate' in response3['AccessKeyLastUsed']:
                last_used = response3['AccessKeyLastUsed'].get('LastUsedDate')
                if key_status == 'Active':
                    if elapsed_days>=90:
                        response = sns_client.publish(
                            TopicArn= a,
                            Message=f'Hello Team,\nPlease be informed, as part of IAM User Access Review, we have observed the below mentioned IAM user has not used the Access/Secret Key in the last {elapsed_days} days.\nAccount ID: {b}\nIAM User: {user_name}\nAccess Key: {access_key_id}\nLastUseDate: {last_used}\nAccess Key Status: {key_status}\nPlease take necessary action.\n\nNote: To adhere to AWS Security Standards, IAM User Access/Secret Keys must be rotated in every 90 days.',
                            Subject='IAM User Access Review',
                            MessageStructure='string'
                        )
                        print("Message_activekey published")
                elif key_status == 'Inactive':
                    response11 = sns_client.publish(
                        TopicArn= a,
                        Message=f'Hello Team,\nPlease be informed, as part of IAM User Access Review, we have observed the below mentioned IAM user is in inactive state.\nAccount ID: {b}\nIAM User: {user_name}\nAccess Key: {access_key_id}\nLastUseDate: {last_used}\nAccess Key Status: {key_status}\nPlease take necessary action.\n\nNote: To adhere to AWS Security Standards, IAM User Access/Secret Keys must be rotated in every 90 days.',
                        Subject='IAM User Access Review',
                        MessageStructure='string'
                    )
                    print("Message_inactivekey published")
            else:
                if key_status == 'Active':
                    response12 = sns_client.publish(
                        TopicArn= a,
                        Message=f'Hello Team,\nPlease be informed, as part of IAM User Access Review, we have observed the below mentioned IAM user has not used the Access/Secret Key ever since created on {create_day}.\nAccount ID: {b}\nIAM User: {user_name}\nAccess Key: {access_key_id}\nLastUseDate: {last_used}\nAccess Key Status: {key_status}\nPlease take necessary action.\n\nNote: To adhere to AWS Security Standards, IAM User Access/Secret Keys must be rotated in every 90 days.',
                        Subject='IAM User Access Review',
                        MessageStructure='string'
                    )
                    print("Message_activekey never_used published")

    
    
    
    
    
