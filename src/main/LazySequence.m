#import <Sequence.h>
#import "LazySequence.h"
#import "NSEnumerator+OCTotallyLazy.h"
#import "PairEnumerator.h"
#import "MemoisedEnumerator.h"
#import "RepeatEnumerator.h"

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

- (LazySequence *)add:(id)value {
    return [self join:lazySequence(value, nil)];
}

- (LazySequence *)cons:(id)value {
    return [lazySequence(value,nil) join:self];
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

- (id)head {
    id item = enumerator.nextObject;
    if (item == nil) {
        [NSException raise:@"NoSuchElementException" format:@"Expected sequence at least one element, but sequence was empty."];
    }
    return item;
}

- (Option *)headOption {
    return option(enumerator.nextObject);
}

- (LazySequence *)join:(LazySequence *)toJoin {
    return [lazySequence(self, toJoin, nil) flatten];
}

- (id)reduce:(id (^)(id, id))functorBlock {
    return [self fold:enumerator.nextObject with:functorBlock];
}

- (LazySequence *)map:(id (^)(id))funcBlock {
    return [LazySequence with:[enumerator map:funcBlock]];
}

- (Sequence *)asSequence {
    NSMutableArray *collect = [NSMutableArray array];
    id object;
    while ((object = [enumerator nextObject]) != nil) {
        [collect addObject:object];
    }
    return [Sequence with:collect];
}

- (NSArray *)asArray {
    NSMutableArray *collect = [NSMutableArray array];
    id object;
    while ((object = [enumerator nextObject]) != nil) {
        [collect addObject:object];
    }
    return collect;
}

- (NSEnumerator *)toEnumerator {
    return enumerator;
}

- (LazySequence *)take:(int)n {
    return [LazySequence with:[enumerator take:n]];
}

- (LazySequence *)takeWhile:(BOOL (^)(id))funcBlock {
    return [LazySequence with:[enumerator takeWhile:funcBlock]];
}

- (LazySequence *)zip:(LazySequence *)otherSequence {
    return [LazySequence with:[PairEnumerator withLeft:enumerator right:[otherSequence toEnumerator]]];
}

- (LazySequence *)cycle {
    return [LazySequence with:[RepeatEnumerator with:[MemoisedEnumerator with:enumerator]]];
}

+ (LazySequence *)with:(NSEnumerator *)enumerator {
    return [[[LazySequence alloc] initWith:enumerator] autorelease];

}
@end