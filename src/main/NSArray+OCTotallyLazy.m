#import "NSArray+OCTotallyLazy.h"
#import "Callables.h"
#import "None.h"
#import "Some.h"
#import "Sequence.h"

@implementation NSArray (Functional)

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
    return [[self tail] fold:[self head] with:functorBlock];
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

- (NSArray *)zip:(id <Enumerable>)otherEnumerable {
    NSEnumerator *enumerator1 = [self toEnumerator];
    NSEnumerator *enumerator2 = [otherEnumerable toEnumerator];
    id item1;
    id item2;
    NSMutableArray *pairs = [NSMutableArray array];
    while (((item1 = [enumerator1 nextObject]) != nil) && ((item2 = [enumerator2 nextObject]) != nil)) {
        [pairs addObject:[Pair left:item1 right:item2]];
    }
    return pairs;
}

- (Sequence *)asSequence {
    return [Sequence with:[self toEnumerator]];
}

- (NSSet *)asSet {
    return [[self asSequence] asSet];
}

- (NSArray *)asArray {
    return self;
}

- (NSDictionary *)asDictionary {
    return [self fold:[NSMutableDictionary dictionary] with:^(NSMutableDictionary *accumulator, NSArray *keyValues) {
        [accumulator setObject:[[keyValues tail] head] forKey:[keyValues head]];
        return accumulator;
    }];
}
@end