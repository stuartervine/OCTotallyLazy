#import "Enumerations.h"


@implementation Enumerations {
    NSEnumerator *enumerator;
}

- (Enumerations *)initWith:(NSEnumerator *)anEnumerator {
    self = [super init];
    if (self) {
        enumerator = [anEnumerator retain];
    }
    return self;
}

- (NSArray *)filter:(BOOL (^)(id))filterBlock {
    NSMutableArray *collectedArray = [[[NSMutableArray alloc] init] autorelease];
    id object;
    while ((object = [enumerator nextObject])) {
        if (filterBlock(object)) {
            [collectedArray addObject:object];
        }
    }
    return collectedArray;
}

- (NSArray *)map:(id (^)(id))functorBlock {
    NSMutableArray *collectedArray = [[[NSMutableArray alloc] init] autorelease];
    id object;
    while ((object = [enumerator nextObject])) {
        [collectedArray addObject:functorBlock(object)];
    }
    return collectedArray;

}

- (NSArray *)flatMap:(id (^)(id))functorBlock {
    NSMutableArray *collectedArray = [NSMutableArray array];
    id object;
    while ((object = [enumerator nextObject])) {
        [collectedArray addObjectsFromArray:[object map:functorBlock]];
    }
    return collectedArray;
}

- (void)dealloc {
    [enumerator release];
    [super dealloc];
}

+ (Enumerations *)with:(NSEnumerator *)enumerator {
    return [[[Enumerations alloc] initWith:enumerator] autorelease];
}

@end