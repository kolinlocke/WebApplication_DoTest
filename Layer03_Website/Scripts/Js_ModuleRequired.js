var IsCheckSave = false
var IsSave = true
var IsTempReleased = false

//Requires a Save Check
IsCheckSave = true;

function RequireSave() {
    IsSave = false;
}

function ReleaseSave() {
    IsSave = true;
}

function TempReleaseSave() {
    IsTempReleased = true;
    IsSave = true;
}

function CheckModuleSave() {
    if (IsCheckSave) {
        if (!IsSave) {
            return "Please save your work first before leaving this page.";
        }
    }

    if (IsTempReleased) {
        IsTempReleased = false;
        IsSave = false;
    }
}

function EOGrid_RowEdit(cell, newValue) {
    RequireSave();
    return newValue;
}

window.onbeforeunload = CheckModuleSave;