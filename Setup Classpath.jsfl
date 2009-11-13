// Figure out the appropriate path
if (fl.configDirectory.substr(0,1) == "/") {
    hypePath = "$(LocalData)/ActionScript 3.0/Classes";
} else {
    hypePath = "$(LocalData)\\ActionScript 3.0\\Classes";
}
    
// make sure it's in the class path    
if (fl.as3PackagePaths.indexOf(hypePath) == -1) {
    fl.as3PackagePaths=fl.as3PackagePaths + ";" + hypePath
    alert("The HYPE framework class path is now setup.");
} else {
    alert("The HYPE framework class was already setup. No changes were made.");
}