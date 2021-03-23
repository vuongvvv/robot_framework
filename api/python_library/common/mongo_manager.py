import json
from robot.libraries.BuiltIn import BuiltIn
from bson.objectid import ObjectId
from pymongo import ReturnDocument

class mongo_manager(object):
    """
    Connection Manager handles the connection & disconnection to the database.
    """
    def __init__(self):
        """
        Initializes _dbconnection to None.
        """
        self._dbconnection = None
        self._builtin = BuiltIn()


    def connect_to_mongodb(self, dbHost='localhost', dbPort=27017, dbMaxPoolSize=10, dbNetworkTimeout=None,
                           dbDocClass=dict, dbTZAware=False):
        """
        Loads pymongo and connects to the MongoDB host using parameters submitted.
        
        Example usage:
        | # To connect to foo.bar.org's MongoDB service on port 27017 |
        | Connect To MongoDB | foo.bar.org | ${27017} |
        | # Or for an authenticated connection, note addtion of "mongodb://" to host uri |
        | Connect To MongoDB | mongodb://admin:admin@foo.bar.org | ${27017} |
        
        """
        dbapiModuleName = 'pymongo'
        db_api_2 = __import__(dbapiModuleName)
        
        dbPort = int(dbPort)
        #print "host is               [ %s ]" % dbHost
        #print "port is               [ %s ]" % dbPort
        #print "pool_size is          [ %s ]" % dbPoolSize
        #print "timeout is            [ %s ]" % dbTimeout
        #print "slave_okay is         [ %s ]" % dbSlaveOkay
        #print "document_class is     [ %s ]" % dbDocClass
        #print "tz_aware is           [ %s ]" % dbTZAware
        print "| Connect To MongoDB | dbHost | dbPort | dbMaxPoolSize | dbNetworktimeout | dbDocClass | dbTZAware |"
        print "| Connect To MongoDB | %s | %s | %s | %s | %s | %s |" % (dbHost, dbPort, dbMaxPoolSize, dbNetworkTimeout,
                                                                        dbDocClass, dbTZAware)

        self._dbconnection = db_api_2.MongoClient(host=dbHost, port=dbPort, socketTimeoutMS=dbNetworkTimeout,
                                         document_class=dbDocClass, tz_aware=dbTZAware,
                                         maxPoolSize=dbMaxPoolSize)
        
    def disconnect_from_mongodb(self):
        """
        Disconnects from the MongoDB server.
        
        For example:
        | Disconnect From MongoDB | # disconnects from current connection to the MongoDB server | 
        """
        print "| Disconnect From MongoDB |"
        self._dbconnection.close()

    def get_mongodb_collections(self, dbName):
        """
        Returns a list of all of the collections for the database you
        passed in on the connected MongoDB server.
        Usage is:
        | @{allCollections} | Get MongoDB Collections | DBName |
        | Log Many | @{allCollections} |
        | Should Contain | ${allCollections} | CollName |
        """
        dbName = str(dbName)
        try:
            db = self._dbconnection['%s' % (dbName,)]
        except TypeError:
            self._builtin.fail("Connection failed, please make sure you have run 'Connect To Mongodb' first.")
        allCollections = db.collection_names()
        print "| @{allCollections} | Get MongoDB Collections | %s |" % dbName
        return allCollections

    def _retrieve_mongodb_records(self, dbName, dbCollName, recordJSON, fields=[], returnDocuments=False):
        dbName = str(dbName)
        dbCollName = str(dbCollName)
        criteria = dict(json.loads(recordJSON))

        if '_id' in criteria:
            criteria['_id'] = ObjectId(criteria['_id'])
        
        try:
            db = self._dbconnection['%s' % (dbName,)]
        except TypeError:
            self._builtin.fail("Connection failed, please make sure you have run 'Connect To Mongodb' first.")
        coll = db['%s' % dbCollName]

        if fields:
            results = coll.find(criteria, fields)
        else:
            results = coll.find(criteria)

        if returnDocuments:
            return list(results)
        else:
            response = ''
            for d in results:
                response = '%s%s' % (response, d.items())
            return response

    def retrieve_some_mongodb_records(self, dbName, dbCollName, recordJSON, returnDocuments=False):
        """
        Retrieve some of the records from a given MongoDB database collection
        based on the JSON entered.
        Returned value must be single quoted for comparison, otherwise you will
        get a TypeError error.
        Usage is:
        | ${allResults} | Retrieve Some MongoDB Records | DBName | CollectionName | JSON |
        | Log | ${allResults} |
        | Should Contain X Times | ${allResults} | '${recordNo1}' | 1 |
        """

        print "| ${allResults} | Retrieve Some MongoDB Records | %s | %s | %s |" % (dbName, dbCollName, recordJSON)
        
        return self._retrieve_mongodb_records(dbName, dbCollName, recordJSON, returnDocuments=returnDocuments)

    def retrieve_mongodb_records_with_desired_fields(self, dbName, dbCollName, recordJSON, fields, return__id=True,
                                                     returnDocuments=False):
        """
        Retrieves from a document(s) the desired projection. In a sql terms: select a and b from table;
        For more details about querying records from Mongodb and comparison to sql see the
        [http://docs.mongodb.org/manual/reference/sql-comparison|Mongodb]
        documentation.
        In Mongodb terms would correspond: db.collection.find({ }, { fieldA: 1, fieldB: 1 })
        For usage of the dbName, dbCollName and recordJSON arguments, see the keyword
        ``Retrieve Some Mongodb Records`` documentation.
        fields argument control what field(s) are returned from the document(s),
        it is a comma separated string of fields. It is also possible to return fields
        inside of the array element, by separating field by dot notation. See the
        usage examples for more details how to use fields argument.
        return__id controls is the _id field also returned with the projections.
        Possible values are True and False
        The following usages assume a database name account, collection named users and
        that contain documents of the following prototype:
        {"firstName": "Clark", "lastName": "Kent", "address": {"streetAddress": "21 2nd Street", "city": "Metropolis"}}
        Usage is:
        | ${firstName} | Retrieve MongoDB Records With Desired Fields | account | users | {} | firstName | 0 |
        | ${address} | Retrieve MongoDB Records With Desired Fields | account | users | {} | address | ${false} | # Robot BuiltIn boolean value |
        | ${address_city} | Retrieve MongoDB Records With Desired Fields | account | users | {} | address.city | False |
        | ${address_city_and_streetAddress} | Retrieve MongoDB Records With Desired Fields | account | users | {} | address.city, address.streetAddress | False |
        | ${_id} | Retrieve MongoDB Records With Desired Fields | account | users | {} | firstName | True |
        =>
        | ${firstName} = [(u'firstName', u'Clark')] |
        | ${address} = [(u'address', {u'city': u'Metropolis', u'streetAddress': u'21 2nd Street'})] |
        | ${address_city} = [(u'address', {u'city': u'Metropolis'})] |
        | ${address_city_and_streetAddress} = [(u'address', {u'city': u'Metropolis', u'streetAddress': u'21 2nd Street'})] # Same as retrieving only address |
        | ${_id} = [(u'_id', ObjectId('...')), (u'firstName', u'Clark')] |
        """
        # Convert return__id to boolean value because Robot Framework returns False/True as Unicode
        try:
            if return__id.isdigit():
                pass
            else:
                return__id = return__id.lower()
                if return__id == 'false':
                    return__id = False
                else:
                    return__id = True
        except AttributeError:
            pass

        # Convert the fields string as a dictionary and handle _id field
        if fields:
            data = {}
            fields = fields.replace(' ', '')
            for item in fields.split(','):
                data[item] = True

            if return__id:
                data['_id'] = True
            elif not return__id:
                data['_id'] = False
            else:
                raise Exception('Not a boolean value for return__id: %s' % return__id)
        else:
            data = []

        print "| ${allResults} | retreive_mongodb_records_with_desired_fields | %s | %s | %s | %s | %s |" % (
            dbName, dbCollName, recordJSON, fields, return__id)
        return self._retrieve_mongodb_records(dbName, dbCollName, recordJSON, data, returnDocuments)
