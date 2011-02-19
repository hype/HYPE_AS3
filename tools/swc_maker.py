import os

hype = []

for path, dirs, files in os.walk('../src/hype/'):
	for name in files:
		if name[-3:] == ".as":
			hype.append(path[7:].replace("/", ".") + "." + name[:-3])

command = "compc -target-player 10 -output ../hype.swc -source-path ../src/ -include-classes "
command = command + " ".join(hype)
os.system(command);
