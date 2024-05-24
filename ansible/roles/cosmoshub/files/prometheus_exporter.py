#!/usr/bin/env python3

import requests
from flask import Flask, Response

app = Flask(__name__)

COSMOS_NODE_URL = 'http://localhost:26657/status'

def get_latest_block_height():
    try:
        response = requests.get(COSMOS_NODE_URL)
        response.raise_for_status()
        data = response.json()
        return data['result']['sync_info']['latest_block_height']
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from node: {e}")
        return None

@app.route('/metrics')
def metrics():
    block_height = get_latest_block_height()
    if block_height is not None:
        return Response(f'latest_block_height {block_height}\n', mimetype='text/plain')
    else:
        return Response('Error fetching block height\n', status=500, mimetype='text/plain')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
