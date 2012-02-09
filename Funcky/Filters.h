#import <Foundation/Foundation.h>

static id FY_equalTo(id comparable) {
    return [[^(id item) { return (BOOL)[item isEqual:comparable]; } copy] autorelease];
}
static id FY_greaterThan(NSNumber *comparable) {
    return [[^(NSNumber *item) { return item.doubleValue > comparable.doubleValue;} copy] autorelease];
}
static id FY_startsWith(NSString *prefix) {
    return [[^(NSString *item) { return [item hasPrefix:prefix];} copy] autorelease];
}
static id FY_everyNth(int n) {
    __block int count = 0;
    return [[^(id item) { 
        count++;
        if (count == n) {
            count = 0;
            return TRUE;
        }
        return FALSE;
    } copy] autorelease];
}
static id FY_alternate(BOOL startState) {
    __block BOOL state = !startState;
    return [[^(id item) {
        state = !state;
        return state;
    } copy] autorelease];
}
