'''
SHORTENER SERVICE
Contains the main business logic for the application
'''

'''
Shortens a url to base62 format (a-z, A-Z, 0-9)
We currently limit the result to be 7 characters long, to ensure url remains short. 26^7 can handle about 8 billion unique urls
We want to reduce collisions, and thus simply generate the IDs in order instead of hashing the url
If the url already exists in the database, return the same string to avoid redundancy
'''
def shorten(url):
    # validate url
    # check url exists in database
    # get latest id, add 1 and create the base62code
    pass

'''
Returns a url when given a base62code from a previously shortened url
'''
def retrieve(base62code):
    # validate base62 code
    # return corresponding url if exists in database
    pass
