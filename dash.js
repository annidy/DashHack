const scheduledTimerWithTimeInterval = ObjC.classes["NSTimer"]["+ scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:"].implementation
Interceptor.replace(scheduledTimerWithTimeInterval, new NativeCallback((NSTimer, sel, interval, target, selector, userInfo, repeats) => {
    if (ptr(selector).readCString() == "waitTick") {
        interval = 0.0001
    }
    console.log("Callback", interval, ptr(selector).readCString())
    return scheduledTimerWithTimeInterval(NSTimer, sel, interval, target, selector, userInfo, repeats);
}, 'pointer', ['pointer', 'pointer', 'double', 'pointer', 'pointer', 'pointer', 'bool']));

// bug: https://github.com/frida/frida/issues/266
/*
Interceptor.attach(ObjC.classes["NSTimer"]["+ scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:"].implementation, {
    onEnter: function (args) {
        if (ptr(args[3]).readCString() == "waitTick") {
            console.log("Enter interval ", args[0], args[1] ,ObjC.Object(args[2]).toString(), args[3]);
        }
    },
})
*/