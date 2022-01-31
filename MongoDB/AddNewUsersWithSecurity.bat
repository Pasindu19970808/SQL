Rem This script is used to add users with access to project DBs if you are converting from a server which didnt have security previously 
Rem change the file path to the MongoDB instance you want to shutdown
cd "C:\Progra~1\MongoDB\Server\4.2\bin"
Rem change subid, password,db_name as required
Rem too add more than one project at a time, add BsonDocument of {role:\"dbOwner\",db:\"db_name\"} format to the roles BsonArray 
mongo --port=27017 -u irescsuperuser -p iresc -authenticationDatabase admin < "C:\Users\pasindu.s\Desktop\DB Dumps\createusers.js"