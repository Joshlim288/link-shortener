'''
SHORTENER SERVICE
Single responsibility of handling shortened URLs, and calling the appropriate services to perform a high-level use case
'''
# library imports
import validators
import data_access

# Constants
ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
CODE_LENGTH = 7
'''
Handles the conversion from document ID (base10) to shortened code (currently base62)
We currently limit the result to be 7 characters long, to ensure url remains short. 26^7 can handle about 8 billion unique urls
We only need a one-way conversion, actual document ID is not used for anything at the moment
'''
def encode(num):
    arr = []
    base = len(ALPHABET)
    while num:
        num, rem = divmod(num, base)
        arr.append(ALPHABET[rem]) 
    # reversing the arr would be more accurate, but it doesn't matter for our use case, just needs to be unique
    return ''.join(arr).ljust(CODE_LENGTH, ALPHABET[0])

'''
Shortens a url to generate a unique short code corresponding to that website
We want to reduce collisions, and thus simply generate the IDs in order instead of hashing the url
If the url already exists in the database, return the same string to avoid redundancy
Returns (Message, StatusCode)
'''
def shorten(url):
    # validate url
    # validators package does not recognize google.com and some other valid formats, area for possible improvement
    if not validators.url(url): 
        return 'Not a valid URL', 400
    
    # check url exists in database -> we do this to maximise storage space
    exiistingDoc = data_access.getByLongUrl(url)
    if exiistingDoc:
        return exiistingDoc['_id'], 200

    # get next id, and create the base62code
    nextId = data_access.getNextId()
    encodedId = encode(nextId)
    data_access.addNewId(encodedId, url)
    return encodedId, 200
    

'''
Returns a url when given a base62code from a previously shortened url
No need to validate the code, existence in the database is all that is needed at this point
'''
def retrieve(base62code):
    # return corresponding url if exists in database
    doc = data_access.getByBase62Code(base62code)
    if not doc:
        return 'Invalid url entered', 400
    return doc['originalUrl'], 200
