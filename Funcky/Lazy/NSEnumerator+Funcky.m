#import "NSEnumerator+Funcky.h"
#import "FlattenEnumerator.h"
#import "MapEnumerator.h"
#import "FilterEnumerator.h"
#import "Filters.h"

@implementation NSEnumerator (Funcky)

- (NSEnumerator *)drop:(int)toDrop {
    return [self dropWhile:FY_countTo(toDrop)];
}

- (NSEnumerator *)dropWhile:(BOOL (^)(id))filterBlock {
    return [self filter:FY_not(FY_whileTrue(filterBlock))];
}

-(NSEnumerator *)flatten {
    return [FlattenEnumerator withEnumerator:self];
}

- (NSEnumerator *)map:(id (^)(id))func {
    return [MapEnumerator withEnumerator:self andFunction:func];
}

- (NSEnumerator *)filter:(BOOL (^)(id))filterBlock {
    return [FilterEnumerator withEnumerator:self andFilter:filterBlock];
}


@end