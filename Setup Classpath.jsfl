if (fl.as3PackagePaths.indexOf("$(LocalData)/ActionScript 3.0/Classes") == -1) {
    fl.as3PackagePaths=fl.as3PackagePaths + ";$(LocalData)/ActionScript 3.0/Classes";
    alert("The HYPE framework class path is now setup.");
} else {
    alert("The HYPE framework class was already setup. No changes were made.");
}