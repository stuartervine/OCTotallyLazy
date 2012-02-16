#import "NSEnumerator+OCTotallyLazy.h"
#import "FlattenEnumerator.h"
#import "MapEnumerator.h"
#import "FilterEnumerator.h"
#import "Some.h"
#import "None.h"
#import "TakeWhileEnumerator.h"

@implementation NSEnumerator (Funcky)

- (NSEnumerator *)drop:(int)toDrop {
    return [self dropWhile:FY_countTo(toDrop)];
}

- (NSEnumerator *)dropWhile:(PREDICATE)predicate {
    return [self filter:FY_not(FY_whileTrue(predicate))];
}

- (NSEnumerator *)filter:(PREDICATE)predicate {
    return [FilterEnumerator withEnumerator:self andFilter:predicate];
}

- (Option *)find:(PREDICATE)predicate {
    for(id item in self) {
        if (predicate(item)) {
            return [Some some:item];
        }
    }
    return [None none];
}

-(NSEnumerator *)flatten {
    return [FlattenEnumerator withEnumerator:self];
}

- (NSEnumerator *)map:(id (^)(id))func {
    return [MapEnumerator withEnumerator:self andFunction:func];
}

- (NSEnumerator *)take:(int)n {
    return [self takeWhile:FY_countTo(n)];
}

- (NSEnumerator *)takeWhile:(BOOL (^)(id))predicate {
    return [TakeWhileEnumerator with:self predicate:FY_whileTrue(predicate)];
}

@end