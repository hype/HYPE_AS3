import os

for path, dirs, files in os.walk('../'):
	for name in files:
		if name[-3:] == ".as":
			fullPath = path[3:] + '/' + name
			pathOnly = path[6:] + '/'
			print "<file name=\"%s\" destination=\"$flash/ActionScript 3.0/Classes%s\" />" % (fullPath, pathOnly)
