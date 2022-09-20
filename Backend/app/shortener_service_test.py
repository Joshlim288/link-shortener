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
        from shortener_service import encode
        response = encode(1684663179371) # Test123, from an online converter
        # We expect the reversed string. It's still unique, and we rather do the reversing in the test than for it to be an
        # extra step in the actual logic
        assert response == '321tseT', "Base62 encoding failed: expected 321tseT, got " + str(response)

    #TODO: test invalid inputs

if __name__ == "__main__":
    unittest.main()