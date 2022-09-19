'''
Contains the API definitions to request data from the server
'''
# library imports
from flask import Flask, request, jsonify
from flask_cors import CORS

# project imports
from shortener_service import *

app = Flask(__name__)
CORS = CORS(app)

@app.route("/")
def landing_page():
    return "<p>URL shortening server</p>"

'''
shorten the provided url, and get the assigned base62code
'''
@app.route("shorten", methods=['GET'])
def shorten():
    args = request.args
    url = args.get('url')
    return shorten(url)

'''
get the url corresponding to the base62code previously issued
'''
@app.route("retrieve", methods=['GET'])
def shorten():
    args = request.args
    base62code = args.get('base62code')
    return retrieve(base62code)