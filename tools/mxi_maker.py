import os
import sys

fileSet = ""

for path, dirs, files in os.walk('../'):
	for name in files:
		if name[-3:] == ".as" and path[3:6] == "src":
			fullPath = path[3:] + '/' + name
			pathOnly = path[6:] + '/'
			fileSet += "\t\t<file name=\"%s\" destination=\"$flash/ActionScript 3.0/Classes%s\" />\n" % (fullPath, pathOnly)

f = open("template.mxi", "rU")
template = f.read()
f.close();

template = template.replace("[[VERSION]]", sys.argv[1])
template = template.replace("[[FILE_SET]]", fileSet);

f = open("../HYPE.mxi", "w")
f.write(template)
f.close()
