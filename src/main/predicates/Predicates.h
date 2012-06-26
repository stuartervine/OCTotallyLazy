#import "Types.h"

static PREDICATE TL_alternate(BOOL startState) {
    __block BOOL state = !startState;
    return [^(id item) {
        state = !state;
        return state;
    } copy];
}
static PREDICATE TL_and(PREDICATE left, PREDICATE right) {
    return [^(id item) {
        return left(item) && right(item);
    } copy];
}
static PREDICATE TL_or(PREDICATE left, PREDICATE right) {
    return [^(id item) {
        return left(item) || right(item);
    } copy];
}
static PREDICATE TL_countTo(int n) {
    __block int count = n;
    return [^(id item) {
        return (count-- > 0);
    } copy];

}
static PREDICATE TL_containedIn(NSArray *existing) {
    return [^(id item) { return [existing containsObject:item];} copy];
}
static PREDICATE TL_containsString(NSString *toMatch) {
    return [^(id item) { return [[item description] rangeOfString:toMatch].length > 0;} copy];
}
static PREDICATE TL_equalTo(id comparable) {
    return [^(id item) { return (BOOL)[item isEqual:comparable]; } copy];
}
static PREDICATE TL_everyNth(int n) {
    __block int count = 0;
    return [^(id item) {
        count++;
        if (count == n) {
            count = 0;
            return TRUE;
        }
        return FALSE;
    } copy];
}
static PREDICATE TL_greaterThan(NSNumber *comparable) {
    return [^(NSNumber *item) { return item.doubleValue > comparable.doubleValue;} copy];
}
static PREDICATE TL_lessThan(NSNumber *comparable) {
    return [^(NSNumber *item) { return item.doubleValue < comparable.doubleValue;} copy];
}
static PREDICATE TL_lessThanOrEqualTo(NSNumber *comparable) {
    return [^(NSNumber *item) { return item.doubleValue <= comparable.doubleValue;} copy];
}
static PREDICATE TL_not(PREDICATE predicate) {
    return [^(id item) {
        return !predicate(item);
    } copy];
}
static PREDICATE TL_startsWith(NSString *prefix) {
    return [^(NSString *item) { return [item hasPrefix:prefix];} copy];
}
static PREDICATE TL_whileTrue(PREDICATE predicate) {
    __block BOOL boolState = TRUE;
    return [^(id item) {
        boolState = boolState && predicate(item);
        return boolState;
    } copy];
}

#ifdef TL_LAMBDA
    #define lambda(s, statement) ^(id s){return statement;}
#endif

#ifdef TL_LAMBDA_SHORTHAND
    #define _(statement) ^(id _){return statement;}
#endif

#ifdef TL_SHORTHAND
    #define alternate(startState) TL_alternate(startState)
    #define and(left, right) TL_and(left, right)
    #define containsStr(comparable) TL_containsString(comparable)
    #define countTo(comparable) TL_countTo(comparable)
    #define eqTo(comparable) TL_equalTo(comparable)
    #define everyNth TL_everyNth
    #define gtThan(comparable) TL_greaterThan(comparable)
    #define in(array) TL_containedIn(array)
    #define ltThan(comparable) TL_lessThan(comparable)
    #define not(predicate) TL_not(predicate)
    #define or(left, right) TL_or(left, right)
    #define startingWith(comparable) TL_startsWith(comparable)
#endif
