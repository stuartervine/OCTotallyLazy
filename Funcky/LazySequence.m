#import <Sequence.h>
#import "LazySequence.h"
#import "Enumerators.h"


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

- (id)filter:(id (^)(id))filterBlock {
    return [LazySequence with:[Enumerators filter:enumerator with:filterBlock]];
}

- (id)map:(id (^)(id))funcBlock {
    return [LazySequence with:[Enumerators map:enumerator with:funcBlock]];
}

- (Sequence *)asSequence {
    NSMutableArray *collect = [NSMutableArray array];
    id object;
    while((object = [enumerator nextObject])) {
        [collect addObject:object];
    }
    return [Sequence with:collect];
}

+ (LazySequence *)with:(NSEnumerator *)enumerator {
 return [[[LazySequence alloc] initWith:enumerator] autorelease];

}
@end