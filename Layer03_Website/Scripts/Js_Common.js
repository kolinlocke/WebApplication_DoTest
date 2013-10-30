function noenter(e) {
    var key;

    if (window.event) {
        key = window.event.keyCode;   //IE
    }
    else {
        key = e.which;   //firefox
    }

    if (key == 13)
        return false;
    else
        return true;
}

function EOCb_BE(callback) {
    var d = eo_GetObject("EODialog_Loader");
    d.show(true);
}

function EOCb_AE(callback, output, extraData) {
    var d = eo_GetObject("EODialog_Loader");
    d.close(1);
}

function EOCb_AE_Eval(callback, output, extraData) {
    EOCb_AE();
    if (extraData != '') {
        eval(extraData);
    }
}

function EOCb_AE_NdcEval(callback, output, extraData) {
    //EOCb_AE(); //Loading Dialog Clear Removed
    if (extraData != '') {
        eval(extraData);
    }
}

function EOCb_AE_OpenWindow(callback, output, extraData) {
    EOCb_AE();
    if (extraData != '') {
        window.open(extraData);
    }
}

function EOControl_ErrorHandler(control, error, message) {
    alert('An error occured while processing an ajax call: ' + message);
}

