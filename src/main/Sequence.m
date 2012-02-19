#import <OCTotallyLazy/OCTotallyLazy.h>
#import "Sequence.h"
#import "NSEnumerator+OCTotallyLazy.h"
#import "NSArray+OCTotallyLazy.h"
#import "PairEnumerator.h"
#import "MemoisedEnumerator.h"
#import "RepeatEnumerator.h"

@implementation Sequence {
    NSEnumerator *enumerator;
}

- (Sequence *)initWith:(NSEnumerator *)anEnumerator {
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

- (Sequence *)add:(id)value {
    return [self join:sequence(value, nil)];
}

- (Sequence *)cons:(id)value {
    return [sequence(value,nil) join:self];
}

- (Sequence *)drop:(int)toDrop {
    return [Sequence with:[enumerator drop:toDrop]];
}

- (Sequence *)dropWhile:(BOOL (^)(id))funcBlock {
    return [Sequence with:[enumerator dropWhile:funcBlock]];
}

- (Sequence *)flatMap:(id (^)(id))funcBlock {
    return [Sequence with:[[enumerator flatten] map:funcBlock]];
}

- (Sequence *)filter:(BOOL (^)(id))predicate {
    return [Sequence with:[enumerator filter:predicate]];
}

- (Option *)find:(BOOL (^)(id))predicate {
    return [enumerator find:predicate];
}

- (Sequence *)flatten {
    return [Sequence with:[enumerator flatten]];
}

- (id)fold:(id)value with:(id (^)(id, id))functorBlock {
    return [[self asArray] fold:value with:functorBlock];
}

- (id)head {
    id item = enumerator.nextObject;
    if (item == nil) {
        [NSException raise:@"NoSuchElementException" format:@"Expected a sequence with at least one element, but sequence was empty."];
    }
    return item;
}

- (Option *)headOption {
    return option(enumerator.nextObject);
}

- (Sequence *)join:(id<Enumerable>)toJoin {
    return [sequence(self, toJoin, nil) flatten];
}

- (id)reduce:(id (^)(id, id))functorBlock {
    return [self fold:enumerator.nextObject with:functorBlock];
}

- (Sequence *)map:(id (^)(id))funcBlock {
    return [Sequence with:[enumerator map:funcBlock]];
}

- (Sequence *)tail {
    [enumerator nextObject];
    return [Sequence with:enumerator];
}

- (Sequence *)take:(int)n {
    return [Sequence with:[enumerator take:n]];
}

- (Sequence *)takeWhile:(BOOL (^)(id))funcBlock {
    return [Sequence with:[enumerator takeWhile:funcBlock]];
}

- (Sequence *)zip:(Sequence *)otherSequence {
    return [Sequence with:[PairEnumerator withLeft:enumerator right:[otherSequence toEnumerator]]];
}

- (Sequence *)cycle {
    return [Sequence with:[RepeatEnumerator with:[MemoisedEnumerator with:enumerator]]];
}

+ (Sequence *)with:(NSEnumerator *)enumerator {
    return [[[Sequence alloc] initWith:enumerator] autorelease];
}

- (NSDictionary *)asDictionary {
    return [[self asArray] asDictionary];
}

- (NSArray *)asArray {
    NSMutableArray *collect = [NSMutableArray array];
    id object;
    while ((object = [enumerator nextObject]) != nil) {
        [collect addObject:object];
    }
    return collect;
}

- (NSSet *)asSet {
    return [NSSet setWithArray: [self asArray]];
}

- (NSEnumerator *)toEnumerator {
    return enumerator;
}

@end