#import "NSArray+Funcky.h"
#import "Some.h"
#import "None.h"

@implementation NSArray (Functional)

- (NSArray *)filter:(BOOL (^)(id))filterBlock {
    return [[[self asSequence] filter:filterBlock] asArray];
}

- (NSArray *)flatMap:(id (^)(id))functorBlock {
    return [[[self asSequence] flatMap:functorBlock] asArray];
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

- (NSArray *)join:(NSArray *)toJoin {
    return [[[self asSequence] join:[toJoin asSequence]] asArray];
}

- (id)map:(id (^)(id))funcBlock {
    return [[[self asSequence] map:funcBlock] asArray];
}

- (id)reduce:(id (^)(id, id))functorBlock {
    return [[self asSequence] reduce:functorBlock];
}

- (NSArray *)tail {
    return [[[self asSequence] tail] asArray];
}

- (NSArray *)take:(int)n {
    return [[[self asSequence] take:n] asArray];
}

- (NSArray *)takeWhile:(BOOL (^)(id))funcBlock {
    return [[[self asSequence] takeWhile:funcBlock] asArray];
}

- (NSArray *)takeRight:(int)n {
    return [[[self asSequence] takeRight:n] asArray];
}

- (Sequence *)asSequence {
    return [Sequence with:self];
}

- (NSSet *)asSet {
    return [[self asSequence] asSet];
}

- (NSArray *)asArray {
    return self;
}


@end
