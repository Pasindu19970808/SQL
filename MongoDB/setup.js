//Change DB Name as Required
db = db.getSiblingDB('11281188_Users');
db.UserProfiles.updateMany({},{$set:{"Status":"Active"}});
db.menu.insert({"m_module" : "Admin","m_modulename" : "Admin","m_menu" : "Users","m_action" : "UserProfile","m_label" : "UserProfile","m_order" : 300000,"m_active" : "Y"});
db.access.insert({"a_group" : "admin","a_menu" : 300000});
db.dbpath.deleteMany({});
//Change DB Path as required
db.dbpath.insert({"path":"C:\Progra~1\MongoDB\Server\4.2\bin\"});
//Used to add  projectdb_password for all ProjectMaster documents in UserProfile. This is required to allow for making the connection string to access the database. If this is not there
//MongoDBContext will fail when trying to cnnect to the project db after project selection. 
//Change projectdb_password as required
db.ProjectMaster.find({}).forEach(function(x){db.ProjectMaster.updateOne({"_id":x["_id"]},{$set:{"projectdb_password":"abcdef"}})})
db.ProjectMaster.updateMany({},{$set:{"Locked":false}})
exit;