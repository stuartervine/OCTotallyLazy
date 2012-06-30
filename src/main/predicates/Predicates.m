#import "Predicates.h"

@implementation Predicates
+ (PREDICATE)alternate:(BOOL)startState {
    __block BOOL state = !startState;
    return [[^(id item) {
        state = !state;
        return state;
    } copy] autorelease];
}

+ (PREDICATE)andLeft:(PREDICATE)left withRight:(PREDICATE)right {
    return [[^(id item) {
        return left(item) && right(item);
    } copy] autorelease];
}

+ (PREDICATE)orLeft:(PREDICATE)left withRight:(PREDICATE)right {
    return [[^(id item) {
        return left(item) || right(item);
    } copy] autorelease];
}

+ (PREDICATE)countTo:(int)n {
    __block int count = n;
    return [[^(id item) {
        return (count-- > 0);
    } copy] autorelease];
}

+ (PREDICATE)containedIn:(NSArray *)existing {
    return [[^(id item) { return [existing containsObject:item];} copy] autorelease];
}

+ (PREDICATE)containsString:(NSString *)toMatch {
    return [[^(id item) { return [[item description] rangeOfString:toMatch].length > 0;} copy] autorelease];
}

+ (PREDICATE)equalTo:(id)comparable {
    return [[^(id item) { return (BOOL)[item isEqual:comparable]; } copy] autorelease];
}

+ (PREDICATE)everyNth:(int)n {
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

+ (PREDICATE)greaterThan:(NSNumber *)comparable {
    return [[^(NSNumber *item) { return item.doubleValue > comparable.doubleValue;} copy] autorelease];
}

+ (PREDICATE)lessThan:(NSNumber *)comparable {
    return [[^(NSNumber *item) { return item.doubleValue < comparable.doubleValue;} copy] autorelease];
}

+ (PREDICATE)lessThanOrEqualTo:(NSNumber *)comparable {
    return [[^(NSNumber *item) { return item.doubleValue <= comparable.doubleValue;} copy] autorelease];
}

+ (PREDICATE)not:(PREDICATE)predicate {
    return [[^(id item) {
        return !predicate(item);
    } copy] autorelease];
}

+ (PREDICATE)startsWith:(NSString *)prefix {
    return [[^(NSString *item) { return [item hasPrefix:prefix];} copy] autorelease];
}

+ (PREDICATE)whileTrue:(PREDICATE)predicate {
    __block BOOL boolState = TRUE;
    return [[^(id item) {
        boolState = boolState && predicate(item);
        return boolState;
    } copy] autorelease];
}
@end