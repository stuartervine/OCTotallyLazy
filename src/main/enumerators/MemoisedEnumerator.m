#import "MemoisedEnumerator.h"


@implementation MemoisedEnumerator {
    NSEnumerator *enumerator;
    NSMutableArray *memory;
    NSInteger position;
}

- (int)previousIndex {
    return position - 1;
}

- (int)nextIndex {
    return position;
}

- (id)previousObject {
    return position > 0 ? [memory objectAtIndex:(NSUInteger) --position] : nil;
}

- (BOOL)hasCachedAnswer {
    return position < [memory count];
}

- (id)cachedAnswer:(NSInteger)index {
    return [memory objectAtIndex:(NSUInteger) index];
}

- (id)nextObject {
    if ([self hasCachedAnswer]) {
        return [self cachedAnswer:position++];
    }
    id item = [enumerator nextObject];
    if (item != nil) {
        [memory addObject:item];
        position++;
        return item;
    }
    return nil;
}

- (MemoisedEnumerator *)initWith:(NSEnumerator *)anEnumerator {
    self = [super init];
    enumerator = [anEnumerator retain];
    memory = [[NSMutableArray array] retain];
    position = 0;
    return self;
}

- (void)dealloc {
    [enumerator release];
    [memory release];
    [super dealloc];
}

- (id)firstObject {
    position = 0;
    return [self nextObject];
}

+ (MemoisedEnumerator *)with:(NSEnumerator *)enumerator {
    return [[[MemoisedEnumerator alloc] initWith:enumerator] autorelease];
}
@end