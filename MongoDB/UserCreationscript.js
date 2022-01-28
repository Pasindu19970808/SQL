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
exit;
