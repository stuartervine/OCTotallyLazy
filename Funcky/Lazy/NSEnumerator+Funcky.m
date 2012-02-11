#import "NSEnumerator+Funcky.h"
#import "FlattenEnumerator.h"
#import "MapEnumerator.h"
#import "FilterEnumerator.h"

@implementation NSEnumerator (Funcky)

-(NSEnumerator *)flatten {
    return [FlattenEnumerator withEnumerator:self];
}

- (NSEnumerator *)map:(id (^)(id))func {
    return [MapEnumerator withEnumerator:self andFunction:func];
}

- (NSEnumerator *)filter:(id (^)(id))filterBlock {
    return [FilterEnumerator withEnumerator:self andFilter:filterBlock];
}


@end