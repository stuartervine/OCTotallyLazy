#import "Predicates.h"

@implementation Predicates

+ (PREDICATE)alternate:(BOOL)startState {
    __block BOOL state = !startState;
    return [^(id item) {
        state = !state;
        return state;
    } copy];
}

+ (PREDICATE)andLeft:(PREDICATE)left withRight:(PREDICATE)right {
    return [^(id item) {
        return left(item) && right(item);
    } copy];
}

+ (PREDICATE)orLeft:(PREDICATE)left withRight:(PREDICATE)right {
    return [^(id item) {
        return left(item) || right(item);
    } copy];
}

+ (PREDICATE)countTo:(int)n {
    __block int count = n;
    return [^(id item) {
        return (count-- > 0);
    } copy];
}

+ (PREDICATE)containedIn:(NSArray *)existing {
    return [^(id item) { return [existing containsObject:item];} copy];
}

+ (PREDICATE)containsString:(NSString *)toMatch {
    return [^(id item) { return [[item description] rangeOfString:toMatch].length > 0;} copy];
}

+ (PREDICATE)equalTo:(id)comparable {
    return [^(id item) { return (BOOL)[item isEqual:comparable]; } copy];
}

+ (PREDICATE)everyNth:(int)n {
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

+ (PREDICATE)greaterThan:(NSNumber *)comparable {
    return [^(NSNumber *item) { return item.doubleValue > comparable.doubleValue;} copy];
}

+ (PREDICATE)lessThan:(NSNumber *)comparable {
    return [^(NSNumber *item) { return item.doubleValue < comparable.doubleValue;} copy];
}

+ (PREDICATE)lessThanOrEqualTo:(NSNumber *)comparable {
    return [^(NSNumber *item) { return item.doubleValue <= comparable.doubleValue;} copy];
}

+ (PREDICATE)not:(PREDICATE)predicate {
    return [^(id item) {
        return !predicate(item);
    } copy];
}

+ (PREDICATE)startsWith:(NSString *)prefix {
    return [^(NSString *item) { return [item hasPrefix:prefix];} copy];
}

+ (PREDICATE)whileTrue:(PREDICATE)predicate {
    __block BOOL boolState = TRUE;
    return [^(id item) {
        boolState = boolState && predicate(item);
        return boolState;
    } copy];
}
@end

extern PREDICATE TL_alternate(BOOL startState) {
    return [Predicates alternate:startState];
}
extern PREDICATE TL_and(PREDICATE left, PREDICATE right) {
    return [Predicates andLeft:left withRight:right];
}
extern PREDICATE TL_or(PREDICATE left, PREDICATE right) {
    return [Predicates orLeft:left withRight:right];
}
extern PREDICATE TL_countTo(int n) {
    return [Predicates countTo:n];
}
extern PREDICATE TL_containedIn(NSArray *existing) {
    return [Predicates containedIn:existing];
}
extern PREDICATE TL_containsString(NSString *toMatch) {
    return [Predicates containsString:toMatch];
}
extern PREDICATE TL_equalTo(id comparable) {
    return [Predicates equalTo:comparable];
}
extern PREDICATE TL_everyNth(int n) {
    return [Predicates everyNth:n];
}
extern PREDICATE TL_greaterThan(NSNumber *comparable) {
    return [Predicates greaterThan:comparable];
}
extern PREDICATE TL_lessThan(NSNumber *comparable) {
    return [Predicates lessThan:comparable];
}
extern PREDICATE TL_lessThanOrEqualTo(NSNumber *comparable) {
    return [Predicates lessThanOrEqualTo:comparable];
}
extern PREDICATE TL_not(PREDICATE predicate) {
    return [Predicates not:predicate];
}
extern PREDICATE TL_startsWith(NSString *prefix) {
    return [Predicates startsWith:prefix];
}
extern PREDICATE TL_whileTrue(PREDICATE predicate) {
    return [Predicates whileTrue:predicate];
}
