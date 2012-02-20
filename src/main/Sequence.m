#import <OCTotallyLazy/OCTotallyLazy.h>
#import "Sequence.h"
#import "NSEnumerator+OCTotallyLazy.h"
#import "PairEnumerator.h"
#import "MemoisedEnumerator.h"
#import "RepeatEnumerator.h"
#import "EasyEnumerable.h"

@implementation Sequence {
    id <Enumerable> enumerable;
    NSEnumerator *enumerator;
}

- (Sequence *)initWith:(id <Enumerable>)anEnumerable {
    self = [super init];
    enumerable = [anEnumerable retain];
    enumerator = [[enumerable toEnumerator] retain];
    return self;
}

- (void)dealloc {
    [enumerable release];
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

    return [Sequence with:[EasyEnumerable with:^{return [[self toEnumerator] drop:toDrop];}]];
}

- (Sequence *)dropWhile:(BOOL (^)(id))funcBlock {
    return [Sequence with:[EasyEnumerable with:^{return [[self toEnumerator] dropWhile:funcBlock];}]];
}

- (Sequence *)flatMap:(id (^)(id))funcBlock {
    return [Sequence with:[EasyEnumerable with:^{return [[[self toEnumerator] flatten] map:funcBlock];}]];
}

- (Sequence *)filter:(BOOL (^)(id))predicate {
    return [Sequence with:[EasyEnumerable with:^{return [[self toEnumerator] filter:predicate];}]];
}

- (Option *)find:(BOOL (^)(id))predicate {
    return [[self toEnumerator] find:predicate];
}

- (Sequence *)flatten {
    return [Sequence with:[EasyEnumerable with:^{return [[self toEnumerator] flatten];}]];
}

- (id)fold:(id)value with:(id (^)(id, id))functorBlock {
    return [[self asArray] fold:value with:functorBlock];
}

- (id)head {
    id item = [self toEnumerator].nextObject;
    if (item == nil) {
        [NSException raise:@"NoSuchElementException" format:@"Expected a sequence with at least one element, but sequence was empty."];
    }
    return item;
}

- (Option *)headOption {
    return option([self toEnumerator].nextObject);
}

- (Sequence *)join:(id<Enumerable>)toJoin {
    return [sequence(self, toJoin, nil) flatten];
}

- (id)reduce:(id (^)(id, id))functorBlock {
    return [[self asArray] reduce:functorBlock];
}

- (Sequence *)map:(id (^)(id))funcBlock {
    return [Sequence with:[EasyEnumerable with:^{return [[self toEnumerator] map:funcBlock];}]];
}

- (Sequence *)tail {
    return [Sequence with:[EasyEnumerable with:^{
        NSEnumerator *const anEnumerator = [self toEnumerator];
        [anEnumerator nextObject];
        return anEnumerator;
    }]];
}

- (Sequence *)take:(int)n {
    return [Sequence with:[EasyEnumerable with:^{return [[self toEnumerator] take:n];}]];
}

- (Sequence *)takeWhile:(BOOL (^)(id))funcBlock {
    return [Sequence with:[EasyEnumerable with:^{return [[self toEnumerator] takeWhile:funcBlock];}]];
}

- (Sequence *)zip:(Sequence *)otherSequence {
    return [Sequence with:[EasyEnumerable with:^{return [PairEnumerator withLeft:[self toEnumerator] right:[otherSequence toEnumerator]];}]];
}

- (Sequence *)cycle {
    return [Sequence with:[EasyEnumerable with:^{return [RepeatEnumerator with:[MemoisedEnumerator with:[self toEnumerator]]];}]];
}

+ (Sequence *)with:(id <Enumerable>)enumerable {
    return [[[Sequence alloc] initWith:enumerable] autorelease];
}

- (NSDictionary *)asDictionary {
    return [[self asArray] asDictionary];
}

- (NSArray *)asArray {
    NSEnumerator *itemsEnumerator = [self toEnumerator];
    NSMutableArray *collect = [NSMutableArray array];
    id object;
    while ((object = [itemsEnumerator nextObject]) != nil) {
        [collect addObject:object];
    }
    return collect;
}

- (NSSet *)asSet {
    return [NSSet setWithArray: [self asArray]];
}

-(NSString *)description {
    NSString *description = @"Sequence [";
    int count = 3;
    id item;
    while((item = enumerator.nextObject) && count-- >0) {
        description = [description stringByAppendingFormat:@"%@, ", item];
    }
    return [description stringByAppendingString:@"]"];
}

- (NSEnumerator *)toEnumerator {
    return [enumerable toEnumerator];
}

@end