'''
Unit tests for shortener_service.py
'''
# library imports
import unittest
import os
from unittest import mock
from datetime import datetime

class ScoreControllerCase(unittest.TestCase):
    @mock.patch.dict(os.environ, {"ME_CONFIG_MONGODB_URL": "placeholder"})
    def testEncode(self):
        from shortener_service import encode # needs to be inside the test case, database initialization takes place on import, we need the mock
        response = encode(1684663179371) # Test123, from an online converter
        # We expect the reversed string. It's still unique, and we rather do the reversing in the test than for it to be an
        # extra step in the actual logic
        assert response == '321tseT', "Base62 encoding failed: expected 321tseT, got " + str(response)
    
    def testShortenUrlInvalidUrl(self):
        from shortener_service import shorten
        response = shorten('alksdjalksdjl') # TODO can test more invalid data formats in the future
        assert response[1] == 400, 'Invalid url accepted: alksdjalksdjl'

    @mock.patch('shortener_service.data_access')
    def testShortenUrlUrlExists(self, mock_DAL):
        from shortener_service import shorten
        # setup mock DAL
        mock_DAL.getByLongUrl.return_value = {
            '_id': 0,
            '_url': 'http://www.google.com'
        }
        response = shorten('http://www.google.com')
        assert response == (0, 200), 'Does not return existing value, got: ' + str(response)
    
    @mock.patch('shortener_service.data_access')
    def testShortenUrlNewUrl(self, mock_DAL):
        from shortener_service import shorten, encode
        # setup mock DAL
        mock_DAL.getByLongUrl.return_value = None
        mock_DAL.getNextId.return_value = 100
        response = shorten('http://www.google.com')
        assert response == (encode(100), 200), 'Valid response rejected, got: ' + str(response)


    #TODO: test invalid inputs

if __name__ == "__main__":
    unittest.main()