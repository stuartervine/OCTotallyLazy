#import "NSSet+Funcky.h"

@implementation NSSet (Functional)

- (NSSet *)filter:(BOOL (^)(id))filterBlock {
    return [[[self asSequence] filter:filterBlock] asSet];
}

- (id)fold:(id)value with:(id (^)(id, id))functorBlock {
    return [[self asSequence] fold:value with:functorBlock];
}

- (id)head {
    return [[self asSequence] head];
}

- (Option *)headOption {
    return [[self asSequence] headOption];
}

- (NSSet *)join:(NSSet *)toJoin {
    return [[[self asSequence] join:[toJoin asSequence]] asSet];
}

- (id)map:(id (^)(id))funcBlock {
    return [[[self asSequence] map:funcBlock] asSet];
}

- (id)reduce:(id (^)(id, id))functorBlock {
    return [[self asSequence] reduce:functorBlock];
}

- (Sequence *)asSequence {
    return [Sequence with:[self allObjects]];
}

- (NSArray *)asArray {
    return [[self asSequence] asArray];
}

@end