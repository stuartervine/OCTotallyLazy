#import "NSSet+OCTotallyLazy.h"
#import "Sequence.h"

@implementation NSSet (Functional)

- (Option *)find:(PREDICATE)filterBlock {
    return [[self asSequence] find:filterBlock];
}

- (NSMutableSet *)filter:(BOOL (^)(id))filterBlock {
    return [[[self asSequence] filter:filterBlock] asSet];
}

- (id)fold:(id)value with:(id (^)(id, id))functorBlock {
    return [[self asSequence] fold:value with:functorBlock];
}

- (NSMutableSet *)groupBy:(FUNCTION1)groupingBlock {
    return [[[self asSequence] groupBy:groupingBlock] asSet];
}

- (id)head {
    return [[self asSequence] head];
}

- (Option *)headOption {
    return [[self asSequence] headOption];
}

- (NSMutableSet *)join:(NSMutableSet *)toJoin {
    return [[[self asSequence] join:[toJoin asSequence]] asSet];
}

- (id)map:(id (^)(id))funcBlock {
    return [[[self asSequence] map:funcBlock] asSet];
}

- (id)reduce:(id (^)(id, id))functorBlock {
    return [[self asSequence] reduce:functorBlock];
}

- (Sequence *)asSequence {
    return [Sequence with:self];
}

- (NSMutableArray *)asArray {
    return [[self asSequence] asArray];
}

- (NSEnumerator *)toEnumerator {
    return [self objectEnumerator];
}


@end