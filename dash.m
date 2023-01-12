// clang -shared -undefined dynamic_lookup -o /Applications/Dash.app/Contents/MacOS/libDash.dylib Dash.m
// optool install -c load -p @executable_path/libDash.dylib -t /Applications/Dash.app/Contents/MacOS/Dash

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@implementation NSTimer(MY)

+ (NSTimer *)my_scheduledTimerWithTimeInterval:(NSTimeInterval)ti 
                                     target:(id)aTarget 
                                   selector:(SEL)aSelector 
                                   userInfo:(id)userInfo 
                                    repeats:(BOOL)yesOrNo {
    printf("%s", aSelector);
    if (strcmp(aSelector, "waitTick") == 0) {
        ti = 0.0001;
    }
    return [self my_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

@end

__attribute__((constructor)) static void fixWaitTick() {
    Method originalMethod = class_getClassMethod([NSTimer class], @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
    Method swizzledMethod = class_getClassMethod([NSTimer class], @selector(my_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));
    NSLog(@"fixWaitTick exchange %p, %p", originalMethod, swizzledMethod);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}