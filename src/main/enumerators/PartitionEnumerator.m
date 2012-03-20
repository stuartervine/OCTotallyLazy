#import "PartitionEnumerator.h"
#import "Queue.h"


@implementation PartitionEnumerator {
    NSEnumerator *underlyingEnumerator;
    PREDICATE predicate;
    Queue *matched;
    Queue *unmatched;
}

- (id)nextObject {
    if(![matched isEmpty]) {
        return [matched remove];
    }
    id result = [underlyingEnumerator nextObject];
    if (result == nil) {
        return nil;
    }
    if (predicate(result)) {
        return result;
    }
    [unmatched add:result];
    return [self nextObject];
}

- (PartitionEnumerator *)initWith:(NSEnumerator *)anEnumerator predicate:(PREDICATE)aPredicate matched:(Queue *)aMatched unmatched:(Queue *)anUnmatched {
    self = [super init];
    underlyingEnumerator = [anEnumerator retain];
    predicate = [aPredicate copy];
    matched = [aMatched retain];
    unmatched = [anUnmatched retain];
    return self;
}

- (void)dealloc {
    [underlyingEnumerator release];
    [predicate release];
    [matched release];
    [unmatched release];
    [super dealloc];
}

+ (PartitionEnumerator *)with:(NSEnumerator *)enumerator predicate:(PREDICATE)predicate matched:(Queue *)matched unmatched:(Queue *)unmatched {
    return [[[PartitionEnumerator alloc] initWith:enumerator predicate:predicate matched:matched unmatched:unmatched] autorelease];
}
@end