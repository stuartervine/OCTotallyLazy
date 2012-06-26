#import <OCTotallyLazy/OCTotallyLazy.h>
#import "NSArray+OCTotallyLazy.h"

@implementation NSArray (OCTotallyLazy)

- (NSMutableArray *)drop:(int)n {
    return [[[self asSequence] drop:n] asArray];
}

- (NSMutableArray *)dropWhile:(BOOL (^)(id))funcBlock {
    return [[[self asSequence] dropWhile:funcBlock] asArray];
}

- (NSMutableArray *)filter:(BOOL (^)(id))filterBlock {
    return [[[self asSequence] filter:filterBlock] asArray];
}

- (NSMutableArray *)flatMap:(id (^)(id))functorBlock {
    return [[[self asSequence] flatMap:functorBlock] asArray];
}

- (NSMutableArray *)flatten {
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

- (NSMutableArray *)groupBy:(FUNCTION1)groupingBlock {
    NSMutableDictionary *keysAndValues = [NSMutableDictionary dictionary];
    NSMutableArray *keys = [NSMutableArray array];
    [self foreach:^(id item) {
        id key = groupingBlock(item);
        if (![keys containsObject:key]) {
            [keys addObject:key];
            [keysAndValues setObject:[NSMutableArray array] forKey:key];
        }
        [[keysAndValues objectForKey:key] addObject:item];
    }];
    return [keys map:^(id key) {
        return [Group group:key enumerable:[keysAndValues objectForKey:key]];
    }];
}

- (NSMutableArray *)grouped:(int)n {
    return [[[self asSequence] grouped:n] asArray];
}

- (id)head {
    return [[self asSequence] head];
}

- (Option *)headOption {
    return [[self asSequence] headOption];
}

- (NSMutableArray *)join:(id <Enumerable>)toJoin {
    return [[[self asSequence] join:toJoin] asArray];
}

- (id)map:(id (^)(id))funcBlock {
    return [[[self asSequence] map:funcBlock] asArray];
}

- (id)mapWithIndex:(id (^)(id, NSInteger))funcBlock {
    return [[[self asSequence] mapWithIndex:funcBlock] asArray];
}

- (NSMutableArray *)merge:(NSArray *)toMerge {
    return [[[self asSequence] merge:[toMerge asSequence]] asArray];
}

- (Pair *)partition:(BOOL (^)(id))filterBlock {
    Pair *partitioned = [[self asSequence] partition:filterBlock];
    return [Pair left:[partitioned.left asArray] right:[partitioned.right asArray]];
}

- (id)reduce:(id (^)(id, id))functorBlock {
    return [self isEmpty] ? nil : [[self tail] fold:[self head] with:functorBlock];
}

- (NSMutableArray *)reverse {
    NSMutableArray *collectedArray = [[NSMutableArray alloc] init];
    NSEnumerator *reversed = [self reverseObjectEnumerator];
    id object;
    while ((object = reversed.nextObject)) {
        [collectedArray addObject:object];
    }
    return collectedArray;
}

- (Pair *)splitAt:(int)splitIndex {
    return [self splitWhen:TL_not(TL_countTo(splitIndex))];
}

- (Pair *)splitOn:(id)splitItem {
    return [self splitWhen:TL_equalTo(splitItem)];
}

- (Pair *)splitWhen:(BOOL (^)(id))predicate {
    Pair *partition = [self partition:TL_whileTrue(TL_not(predicate))];
    return [Pair left:partition.left right:[partition.right tail]];
}

- (NSMutableArray *)tail {
    return [self takeRight:[self count] - 1];
}

- (NSMutableArray *)take:(int)n {
    return [[[self asSequence] take:n] asArray];
}

- (NSMutableArray *)takeWhile:(BOOL (^)(id))funcBlock {
    return [[[self asSequence] takeWhile:funcBlock] asArray];
}

- (NSMutableArray *)takeRight:(int)n {
    return [NSMutableArray arrayWithArray:[self subarrayWithRange:NSMakeRange([self count] - n, (NSUInteger) n)]];
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

- (NSMutableArray *)zip:(NSArray *)otherArray {
    return [[[self asSequence] zip:[otherArray asSequence]] asArray];
}

- (NSMutableArray *)zipWithIndex {
    return [[[self asSequence] zipWithIndex] asArray];
}

- (Sequence *)asSequence {
    return [Sequence with:self];
}

- (NSSet *)asSet {
    return [[self asSequence] asSet];
}

- (NSMutableArray *)asArray {
    if([self isKindOfClass:[NSMutableArray class]])
        return (NSMutableArray *)self;
    else    
        return [NSMutableArray arrayWithArray:self];
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