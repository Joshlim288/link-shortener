'''
Contains the logic for storing and retrieving data from the database
'''
# library imports
import pymongo
import os

client = pymongo.MongoClient(os.environ['ME_CONFIG_MONGODB_URL'])
db = client.url_database
collection = db.teams
