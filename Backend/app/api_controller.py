'''
API CONTROLLER
Single responsibility of extracting user input from API requests
'''
# library imports
from flask import Flask, request, jsonify
from flask_cors import CORS
import os

# project imports
import shortener_service
import data_access

app = Flask(__name__)
CORS = CORS(app)

@app.route("/")
def landing_page():
    return "<p>URL shortening server</p>"

'''
shorten the provided url, and get the assigned base62code
'''
@app.route("/shorten", methods=['GET'])
def shorten():
    args = request.args
    url = args.get('url')
    return shortener_service.shorten(url)

'''
get the url corresponding to the base62code previously issued
'''
@app.route("/retrieve", methods=['GET'])
def retrieve():
    args = request.args
    base62code = args.get('base62code')
    return shortener_service.retrieve(base62code)

'''
Entry point for the application
'''
if __name__ == "__main__":
    data_access.initCollection()
    app.run(port=int(os.getenv('PORT')))