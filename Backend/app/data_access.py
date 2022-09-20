'''
Contains the logic for storing and retrieving data from the database
'''
# library imports
import pymongo
import os

collection_created = False
client = pymongo.MongoClient(os.environ['ME_CONFIG_MONGODB_URL'])
db = client.url_database
urlCollection = db.urls
adminCollection = db.admin

'''
Checks if there exists a shortened url that points to the same url
'''
def checkLongUrl(longUrl):
    pass

'''
Get the latest entry id from the admin collection.
Increments the value immediately to ensure the next call produces a different id
Should only be called if the url has been deemed to be valid
'''
def getNextId():
    pass

'''
Called once on startup, initializes the collections if not already created
This is to ensure the indexes are setup properly, so looking up both original
and shortened urls are done on an index
'''
def initCollection():
    pass
