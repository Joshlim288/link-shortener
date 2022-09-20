'''
DATA_ACCESS
Contains the logic for storing and retrieving data from the database
Note that business logic should be abstracted from this Data Access Layer
Single responsibility of managing the database
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
def checkLongUrlExists(longUrl):
    return urlCollection.find_one({'originalUrl': longUrl})!=None

'''
Get the latest entry id from the admin collection.
Increments the value immediately to ensure the next call produces a different id
Should only be called if the url has been deemed to be valid
'''
def getNextId():
    id = adminCollection.find_one()['lastId'] + 1
    adminCollection.update_one({'_id':0}, {"$set": {'lastId': id}}, upsert=False)
    return id

'''
Inserts a new document into the urlCollection with the given details
'''
def addNewId(base62code, originalUrl):
    urlCollection.insert_one({
        '_id': base62code,
        'originalUrl': originalUrl,
    })

'''
Called once on startup, initializes the collections if not already created
This is to ensure the indexes are setup properly, so looking up both original
and shortened urls are done on an index
'''
def initCollection():
    try:
        db.validate_collection("adminCollection")  # Try to validate a collection
    except pymongo.errors.OperationFailure:  # If the collection doesn't exist
        # Initialize the databases
        adminCollection.insert_one({
            '_id': 0,
            'lastId': 0,
        })
        # we need 2 indexes: one for searching if original URL already in database, another for retrieving said url with base62code
        # we will use base62code as the _id of documents, which is already automatically indexed
        urlCollection.create_index([('originalUrl', pymongo.TEXT)], name='originalUrl_index', default_language='english')
