import json
from os import environ
from pickletools import stringnl_noescape_pair

from flask import make_response, Request
import google.cloud.compute_v1 as compute_v1


GAMES = environ['GAMES'].split(':')

def info(request: Request):
    response = []

    for game in GAMES:
        urls = environ[game]
        start, stop, status = urls.split(";")

        response.append(
            {
                "name": game,
                "urls": {
                    "start": start,
                    "stop": stop,
                    "status": status,
                }
            }
        )

    response = make_response(json.dumps({"games": response}))
    response.headers = {
        'Access-Control-Allow-Origin': '*'
    }
    return response