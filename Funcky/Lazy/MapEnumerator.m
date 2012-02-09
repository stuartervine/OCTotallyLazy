#import "MapEnumerator.h"


@implementation MapEnumerator {
    NSEnumerator *enumerator;
    id (^func)(id);
}

- (MapEnumerator *)initWithEnumerator:(NSEnumerator *)anEnumerator andFunction:(id (^)(id))aFunc {
    self = [super init];
    enumerator = [anEnumerator retain];
    func = [aFunc copy];
    return self;
}

+ (NSEnumerator *)withEnumerator:(NSEnumerator *)enumerator andFunction:(id (^)(id))func {
    return [[[MapEnumerator alloc] initWithEnumerator:enumerator andFunction:func] autorelease];
}

- (id)nextObject {
    id item = [enumerator nextObject];
    return (item == nil) ? nil : func(item);
}

- (void)dealloc {
    [enumerator release];
    [func release];
    [super dealloc];
}


@end