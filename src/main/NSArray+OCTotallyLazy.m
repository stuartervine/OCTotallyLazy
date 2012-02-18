#import "NSArray+OCTotallyLazy.h"
#import "Callables.h"

@implementation NSArray (Functional)

-(NSArray *)drop:(int)n {
   return  (n >= [self count]) ? array(nil) : [self subarrayWithRange:NSMakeRange((NSUInteger) n, [self count] - n)];
}

- (NSArray *)dropWhile:(BOOL (^)(id))funcBlock {
   return [self drop:[[[self takeWhile:funcBlock] asArray] count]];
}

- (NSArray *)filter:(BOOL (^)(id))filterBlock {
    return [[[self asSequence] filter:filterBlock] asArray];
}

- (NSArray *)flatMap:(id (^)(id))functorBlock {
    return [[[self asSequence] flatMap:functorBlock] asArray];
}

-(NSArray *)flatten {
    NSMutableArray *flatten = [NSMutableArray array];
    for(id object in self) {
        if([object respondsToSelector:@selector(flatten)]) {
            [flatten addObjectsFromArray:[[object flatten] asArray]];
        } else {
            [flatten addObject:object];
        }
    }
    return flatten;
}

- (Option *)find:(BOOL (^)(id))filterBlock {
    return [[self filter:filterBlock] headOption];
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

- (NSArray *)join:(id<Enumerable>)toJoin {
    return [array(self, toJoin, nil) flatten];
}

- (id)map:(id (^)(id))funcBlock {
    NSMutableArray *collectedArray = [NSMutableArray array];
    for(id object in self) {
        [collectedArray addObject:funcBlock(object)];
    }
    return collectedArray;
}

- (Pair *)partition:(BOOL (^)(id))filterBlock {
    NSMutableArray *left = [NSMutableArray array];
    NSMutableArray *right = [NSMutableArray array];
    for(id object in self) {
        if(filterBlock(object)) {
            [left addObject:object];
        } else {
            [right addObject:object];
        }
    }
    return [Pair left:left right:right];
}


- (id)reduce:(id (^)(id, id))functorBlock {
    return [[self asSequence] reduce:functorBlock];
}

- (NSArray *)reverse {
    NSMutableArray *collectedArray = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator *reversed = [self reverseObjectEnumerator];
    id object;
    while((object = reversed.nextObject)) {
        [collectedArray addObject:object];
    }
    return collectedArray;
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
    while(((item1 = [enumerator1 nextObject]) != nil) && ((item2 = [enumerator2 nextObject]) != nil)) {
        [pairs addObject:[Pair left:item1 right:item2]];
    }
    return pairs;
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