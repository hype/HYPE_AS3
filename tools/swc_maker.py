import os

framework = []
extended = []

for path, dirs, files in os.walk('../src/hype/framework/'):
	for name in files:
		if name[-3:] == ".as":
			framework.append(path[7:].replace("/", ".") + "." + name[:-3])

for path, dirs, files in os.walk('../src/hype/extended/'):
	for name in files:
		if name[-3:] == ".as":
			extended.append(path[7:].replace("/", ".") + "." + name[:-3])

command = "compc -target-player 10 -output ../hype-framework.swc -source-path ../src/ -include-classes "
command = command + " ".join(framework)
os.system(command);

command = "compc -target-player 10 -output ../hype-extended.swc -source-path ../src/ -include-classes "
command = command + " ".join(extended)
os.system(command);
