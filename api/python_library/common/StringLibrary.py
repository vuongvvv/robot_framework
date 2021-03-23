import base64

class StringLibrary:

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '0.1'

    def Encode_Base64_String(self, encodeString):
        return base64.b64encode(bytes(encodeString, 'utf-8'))