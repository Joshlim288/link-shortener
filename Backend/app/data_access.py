'''
DATA_ACCESS
Contains the logic for storing and retrieving data from the database
Note that business logic should be abstracted from this Data Access Layer
Single responsibility of managing the database
'''
# library imports
import pymongo
import os


client = pymongo.MongoClient(os.environ['ME_CONFIG_MONGODB_URL'])
db = client.url_database
urlCollection = db.urls
adminCollection = db.admin
# to ensure that collection and indexes are set up. We do not run this on init as containers are started in parallel for docker compose
initialized = False 

'''
Checks if there exists a shortened url that points to the same url, and returns the document if it exists
'''
def getByLongUrl(longUrl):
    if not initialized: initCollection()
    return urlCollection.find_one({'originalUrl': longUrl})

'''
Checks if there exists a shortened url that points to the same url, and returns the document if it exists
'''
def getByBase62Code(base62code):
    if not initialized: initCollection()
    return urlCollection.find_one({'_id': base62code})

'''
Get the latest entry id from the admin collection.
Increments the value immediately to ensure the next call produces a different id
Should only be called if the url has been deemed to be valid
'''
def getNextId():
    if not initialized: initCollection()
    id = adminCollection.find_one()['lastId'] + 1
    adminCollection.update_one({'_id':0}, {"$set": {'lastId': id}}, upsert=False)
    return id

'''
Inserts a new document into the urlCollection with the given details
'''
def addNewId(base62code, originalUrl):
    if not initialized: initCollection()
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
        global initialized
        initialized = True
