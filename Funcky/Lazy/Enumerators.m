#import "Enumerators.h"
#import "MapEnumerator.h"
#import "FilterEnumerator.h"
#import "FlattenEnumerator.h"

@implementation Enumerators

+ (NSEnumerator *)map:(NSEnumerator *)enumerator with:(id (^)(id))func {
    return [MapEnumerator withEnumerator:enumerator andFunction:func];
}

+ (NSEnumerator *)filter:(NSEnumerator *)enumerator with:(id (^)(id))filterBlock {
    return [FilterEnumerator withEnumerator:enumerator andFilter:filterBlock];
}

+ (NSEnumerator *)flatten:(NSEnumerator *)enumerator {
    return [FlattenEnumerator withEnumerator:enumerator];
}
@end