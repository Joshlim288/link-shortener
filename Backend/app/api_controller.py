'''
Contains the API definitions to request data from the server
'''
# library imports
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS = CORS(app)

@app.route("/")
def landing_page():
    return "<p>URL shortening server</p>"
