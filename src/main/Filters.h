#import <Foundation/Foundation.h>

typedef BOOL(^PREDICATE)(id);

static PREDICATE TL_equalTo(id comparable) {
    return [[^(id item) { return (BOOL)[item isEqual:comparable]; } copy] autorelease];
}
static PREDICATE TL_greaterThan(NSNumber *comparable) {
    return [[^(NSNumber *item) { return item.doubleValue > comparable.doubleValue;} copy] autorelease];
}
static PREDICATE TL_startsWith(NSString *prefix) {
    return [[^(NSString *item) { return [item hasPrefix:prefix];} copy] autorelease];
}
static PREDICATE TL_whileTrue(PREDICATE predicate) {
    __block BOOL boolState = TRUE;
    return [[^(id item) {
        boolState = boolState && predicate(item);
        return boolState;
    } copy] autorelease];
}
static PREDICATE TL_not(PREDICATE predicate) {
    return [[^(id item) {
        return !predicate(item);
    } copy] autorelease];
}
static PREDICATE TL_countTo(int n) {
    __block int count = n;
    return [[^(id item) {
        return (count-- > 0);
    } copy] autorelease];

}
static PREDICATE TL_everyNth(int n) {
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
static PREDICATE TL_alternate(BOOL startState) {
    __block BOOL state = !startState;
    return [[^(id item) {
        state = !state;
        return state;
    } copy] autorelease];
}
