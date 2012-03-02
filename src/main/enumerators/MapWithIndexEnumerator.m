#import "MapWithIndexEnumerator.h"


@implementation MapWithIndexEnumerator {
    NSEnumerator *enumerator;
    id (^func)(id, NSInteger);
    NSInteger index;
}

- (MapWithIndexEnumerator *)initWithEnumerator:(NSEnumerator *)anEnumerator andFunction:(id (^)(id item, NSInteger i))aFunc {
    self = [super init];
    enumerator = [anEnumerator retain];
    func = [aFunc copy];
    index = 0;
    return self;
}

+ (NSEnumerator *)withEnumerator:(NSEnumerator *)enumerator andFunction:(id (^)(id item, NSInteger index))func {
    return [[[MapWithIndexEnumerator alloc] initWithEnumerator:enumerator andFunction:func] autorelease];
}

- (id)nextObject {
    id item = [enumerator nextObject];
    return (item == nil) ? nil : func(item, index++);
}

- (void)dealloc {
    [enumerator release];
    [func release];
    [super dealloc];
}

@end