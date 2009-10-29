var selectionList = fl.getDocumentDOM().selection;
var max = selectionList.length;
var showError = false;
var updatedList = new Array();

for (var i=0; i<max; ++i) {
    instance = selectionList[i];
    if (instance.instanceType == "symbol" && instance.symbolType == "button") {
        instance.libraryItem.linkageExportForAS = true;
        instance.libraryItem.linkageExportInFirstFrame = true;
        instance.libraryItem.linkageBaseClass = "hype.framework.interactive.EasyButton";
        updatedList.push(instance.libraryItem.name);
    } else {
        showError = true;
    }
}

if (showError) {
    alert("One or more of the selected items is not a button instance, and thus could not be turned into a HYPE EasyButton.");
}

if (updatedList.length > 0) {
    alert("The following symbols were converted into HYPE EasyButtons: " + updatedList.toString());
}