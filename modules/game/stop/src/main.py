import json
from os import environ
from pickletools import stringnl_noescape_pair

from flask import make_response, Request
import google.cloud.compute_v1 as compute_v1


SERVER = environ['SERVER']
PROJECT = environ['PROJECT_ID']
ZONE = f"{environ['REGION']}-a"

def stop_server(request: Request):
    instance_client = compute_v1.InstancesClient()
    operation_client = compute_v1.ZoneOperationsClient()

    print(f"Stopping {SERVER}")
    operation = instance_client.stop(
        project=PROJECT, 
        zone=ZONE,
        instance=SERVER
    )
    while operation.status != compute_v1.Operation.Status.DONE:
        operation = operation_client.wait(
            operation=operation.name, zone=ZONE, project=PROJECT
        )
    if operation.error:
        print("Error during stop:", operation.error)
        return make_response(json.dumps({
            "status": "error"
        }))
    if operation.warnings:
        print("Warning during stop:", operation.warnings)

    response = make_response({"name": SERVER, "status": "TERMINATED" })
    response.headers = {
        'Access-Control-Allow-Origin': '*'
    }
    return response