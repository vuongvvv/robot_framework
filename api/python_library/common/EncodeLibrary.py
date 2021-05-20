from time import time
import urllib.parse
import hashlib
import hmac
import base64

class EncodeLibrary:
    def Encode_Base64_String(self, encodeString):
        return base64.b64encode(bytes(encodeString, 'utf-8'))

    def Encode_SHA384(self, secret, payload):
        sign = hmac.new(secret.encode(), payload, hashlib.sha384).hexdigest()
        return sign