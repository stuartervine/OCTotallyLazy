#import "NSArray+OCTotallyLazy.h"
#import "Callables.h"
#import "Sequence.h"
#import "Predicates.h"

@implementation NSArray (OCTotallyLazy)

- (NSArray *)drop:(int)n {
    return [[[self asSequence] drop:n] asArray];
}

- (NSArray *)dropWhile:(BOOL (^)(id))funcBlock {
    return [[[self asSequence] dropWhile:funcBlock] asArray];
}

- (NSArray *)filter:(BOOL (^)(id))filterBlock {
    return [[[self asSequence] filter:filterBlock] asArray];
}

- (NSArray *)flatMap:(id (^)(id))functorBlock {
    return [[[self asSequence] flatMap:functorBlock] asArray];
}

- (NSArray *)flatten {
    return [[[self asSequence] flatten] asArray];
}

- (Option *)find:(BOOL (^)(id))filterBlock {
    return [[self asSequence] find:filterBlock];
}

- (id)fold:(id)value with:(id (^)(id, id))functorBlock {
    id accumulator = value;
    for (id item in self) {
        accumulator = functorBlock(accumulator, item);
    }
    return accumulator;
}

- (void)foreach:(void (^)(id))funcBlock {
    for (id item in self) {
        funcBlock(item);
    }
}

- (BOOL)isEmpty {
    return self.count == 0;
}

- (NSArray *)grouped:(int)n {
    return [[[self asSequence] grouped:n] asArray];
}

- (id)head {
    return [[self asSequence] head];
}

- (Option *)headOption {
    return [[self asSequence] headOption];
}

- (NSArray *)join:(id <Enumerable>)toJoin {
    return [[[self asSequence] join:toJoin] asArray];
}

- (id)map:(id (^)(id))funcBlock {
    return [[[self asSequence] map:funcBlock] asArray];
}

- (id)mapWithIndex:(id (^)(id, NSInteger))funcBlock {
    return [[[self asSequence] mapWithIndex:funcBlock] asArray];
}

- (Pair *)partition:(BOOL (^)(id))filterBlock {
    NSMutableArray *left = [NSMutableArray array];
    NSMutableArray *right = [NSMutableArray array];
    for (id object in self) {
        if (filterBlock(object)) {
            [left addObject:object];
        } else {
            [right addObject:object];
        }
    }
    return [Pair left:left right:right];
}

- (id)reduce:(id (^)(id, id))functorBlock {
    return [self isEmpty] ? nil : [[self tail] fold:[self head] with:functorBlock];
}

- (NSArray *)reverse {
    NSMutableArray *collectedArray = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator *reversed = [self reverseObjectEnumerator];
    id object;
    while ((object = reversed.nextObject)) {
        [collectedArray addObject:object];
    }
    return collectedArray;
}

- (NSArray *)tail {
    return [self takeRight:[self count] - 1];
}

- (NSArray *)take:(int)n {
    return [[[self asSequence] take:n] asArray];
}

- (NSArray *)takeWhile:(BOOL (^)(id))funcBlock {
    return [[[self asSequence] takeWhile:funcBlock] asArray];
}

- (NSArray *)takeRight:(int)n {
    return [self subarrayWithRange:NSMakeRange([self count] - n, (NSUInteger) n)];
}

- (NSEnumerator *)toEnumerator {
    return [self objectEnumerator];
}

- (NSString *)toString {
    return [self toString:@""];
}

- (NSString *)toString:(NSString *)separator {
    return [self reduce:TL_appendWithSeparator(separator)];
}

- (NSString *)toString:(NSString *)start separator:(NSString *)separator end:(NSString *)end {
    return [[start stringByAppendingString:[self toString:separator]] stringByAppendingString:end];
}

- (NSArray *)zip:(NSArray *)otherArray {
    return [[[self asSequence] zip:[otherArray asSequence]] asArray];
}

- (NSArray *)zipWithIndex {
    return [[[self asSequence] zipWithIndex] asArray];
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

- (NSDictionary *)asDictionary {
    Pair *keysAndValues = [self partition:TL_alternate(YES)];
    NSArray *keys = keysAndValues.left;
    NSArray *values = keysAndValues.right;
    values = [values take:[keys count]];
    keys = [keys take:[values count]];
    NSEnumerator *valueEnumerator = [keysAndValues.right objectEnumerator];
    return [keys fold:[NSMutableDictionary dictionary] with:^(NSMutableDictionary *accumulator, id key) {
        [accumulator setObject:[valueEnumerator nextObject] forKey:key];
        return accumulator;
    }];
}
@end