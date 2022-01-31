db = db.getSiblingDB('admin')
db.createUser({"user":"irescsuperuser",
			   "pwd":"iresc",
			   "roles":[{role:"root",db:"admin"}]});
db.shutdownServer();
exit;