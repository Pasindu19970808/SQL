//admin admin --eval "db.createUser({user:\"subid\",pwd:\"password\",roles:[{role:\"dbOwner\",db:\"db_name\"}]});"
var rolesarray = [];
db.adminCommand({listDatabases:1,filter:{$and:[{"name":/^11281189_/},{"name":{$ne:"11281189_Users"}}]}})["databases"].forEach(function(x){
	dbbsondoc = {};
	dbbsondoc.role = "dbOwner";
	dbbsondoc.db = "`"x["name"];
	rolesarray.push(dbbsondoc)
});
curs = db.getSiblingDB("admin");
curs.createUser({user:"11281189",pwd:"cb6LHMg",roles:rolesarray});
db.adminCommand({listDatabases:1,filter:{$and:[{"name":/^11281189_/},{"name":{$ne:"11281189_Users"}}]}})["databases"].forEach(function(x){
	//Updates Projectmaster in Project DB
	curs = db.getSiblingDB(x["name"]);
	curs.ProjectMaster.update({},{$set:{projectdb_password:"cb6LHMg"}})
	//Updates Projectmaster in User DB
	curs = db.getSiblingDB("11281189_Users");
	curs.ProjectMaster.update({db:x["name"]},{$set:{projectdb_password:"cb6LHMg"}})
});
exit;
