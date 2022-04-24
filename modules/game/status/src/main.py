import json
from os import environ
from pickletools import stringnl_noescape_pair

from flask import make_response, Request
import google.cloud.compute_v1 as compute_v1


SERVER = environ['SERVER']
PROJECT = environ['PROJECT_ID']
ZONE = f"{environ['REGION']}-a"

def get_server_status(request: Request):
    instance_client = compute_v1.InstancesClient()

    print(f"Stopping {SERVER}")
    instance = instance_client.get(
        project=PROJECT, 
        zone=ZONE,
        instance=SERVER
    )

    return make_response(f"{SERVER} is {instance.status}")