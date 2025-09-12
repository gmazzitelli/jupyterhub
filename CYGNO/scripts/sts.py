#!/usr/bin/env python3

import boto3
import json
import os
import sys

def main():
    try:
        role_arn = os.environ["AWS_ROLE_ARN"]
        endpoint = os.environ["AWS_ENDPOINT_URL"]

        # Leggi il token dal file
        with open("/tmp/token", "r") as f:
            token = f.read().strip()

        # Crea il client STS
        sts_client = boto3.client(
            "sts",
            endpoint_url=endpoint,
            aws_access_key_id="",
            aws_secret_access_key="",
            aws_session_token=""
        )

        assume_response = sts_client.assume_role_with_web_identity(
            RoleArn=role_arn,
            RoleSessionName="bob",
            DurationSeconds=3600,
            WebIdentityToken=token
        )

        creds = assume_response['Credentials']
        print(json.dumps({
            "Version": 1,
            "AccessKeyId": creds['AccessKeyId'],
            "SecretAccessKey": creds['SecretAccessKey'],
            "SessionToken": creds['SessionToken'],
            "Expiration": creds['Expiration'].isoformat()
        }, indent=2))

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
