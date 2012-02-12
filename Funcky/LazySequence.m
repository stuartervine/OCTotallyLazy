#import <Sequence.h>
#import <Filters.h>
#import "LazySequence.h"
#import "NSEnumerator+Funcky.h"

@implementation LazySequence {
    NSEnumerator *enumerator;
}

- (LazySequence *)initWith:(NSEnumerator *)anEnumerator {
    self = [super init];
    enumerator = [anEnumerator retain];
    return self;
}

- (void)dealloc {
    [enumerator release];
    [super dealloc];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id[])buffer count:(NSUInteger)len {
    return [enumerator countByEnumeratingWithState:state objects:buffer count:len];
}

- (LazySequence *)drop:(int)toDrop {
    return [LazySequence with:[enumerator drop:toDrop]];
}

- (LazySequence *)dropWhile:(BOOL (^)(id))funcBlock {
    return [LazySequence with:[enumerator dropWhile:funcBlock]];
}

- (LazySequence *)flatMap:(id (^)(id))funcBlock {
    return [LazySequence with:[[enumerator flatten] map:funcBlock]];
}

- (LazySequence *)filter:(BOOL (^)(id))predicate {
    return [LazySequence with:[enumerator filter:predicate]];
}

- (Option *)find:(BOOL (^)(id))predicate {
    return [enumerator find:predicate];
}

- (LazySequence *)flatten {
    return [LazySequence with:[enumerator flatten]];
}

- (id)fold:(id)value with:(id (^)(id, id))functorBlock {
    return [[self asSequence] fold:value with:functorBlock];
}

- (LazySequence *)map:(id (^)(id))funcBlock {
    return [LazySequence with:[enumerator map:funcBlock]];
}

- (Sequence *)asSequence {
    NSMutableArray *collect = [NSMutableArray array];
    id object;
    while((object = [enumerator nextObject])) {
        [collect addObject:object];
    }
    return [Sequence with:collect];
}

- (NSEnumerator *)objectEnumerator {
    return enumerator;
}

+ (LazySequence *)with:(NSEnumerator *)enumerator {
 return [[[LazySequence alloc] initWith:enumerator] autorelease];

}
@end