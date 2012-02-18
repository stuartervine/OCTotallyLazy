#import "Sequence.h"
#import "Some.h"
#import "None.h"
#import "NSArray+OCTotallyLazy.h"
#import "Callables.h"

@implementation Sequence {
    NSArray *arguments;
}

- (id)initWith:(NSArray *)someArguments {
    self = [super init];
    arguments = [someArguments retain];
    return self;
}

- (Sequence *)drop:(int)n {
    return  (n >= [arguments count]) ? sequence(nil) : [[arguments subarrayWithRange:NSMakeRange((NSUInteger) n, [arguments count] - n)] asSequence];
}

- (Sequence *)dropWhile:(BOOL (^)(id))funcBlock {
    return [self drop:[[[self takeWhile:funcBlock] asArray] count]];
}

- (Sequence *)filter:(BOOL (^)(id))filterBlock {
    NSMutableArray *collectedArray = [[[NSMutableArray alloc] init] autorelease];
    for(id object in self) {
        if (filterBlock(object)) {
            [collectedArray addObject:object];
        }
    }
    return [collectedArray asSequence];
}

-(Sequence *)flatten {
    NSMutableArray *flatten = [NSMutableArray array];
    for(id object in self) {
        if([object respondsToSelector:@selector(asSequence)]) {
            [flatten addObjectsFromArray:[[[object asSequence] flatten] asArray]];
        } else {
            [flatten addObject:object];
        }
    }
    return [flatten asSequence];
}

- (Option *)find:(BOOL (^)(id))filterBlock {
    return [[self filter:filterBlock] headOption];
}

- (Sequence *)flatMap:(id (^)(id))functorBlock {
    Sequence *aSequence = [self flatten];
    return [aSequence map: functorBlock];
}

- (id)fold:(id)value with:(id (^)(id acc, id item))functorBlock {
    id accumulator = value;
    for (id item in self) {
        accumulator = functorBlock(accumulator, item);
    }
    return accumulator;
}

- (id)head {
    if ([arguments count] == 0) {
        [NSException raise:@"ArrayBoundsException" format:@"Expected array with at least one element, but array was empty."];
    }
    return [arguments objectAtIndex:0];
}

- (Option *)headOption {
    return ([arguments count] > 0) ? [Some some:[self head]] : [None none];
}

- (Sequence *)join:(Sequence *)toJoin {
    return [sequence(self, toJoin, nil) flatten];
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
    return [Pair left:[left asSequence] right:[right asSequence]];
}


- (id)map:(id (^)(id))funcBlock {
    NSMutableArray *collectedArray = [NSMutableArray array];
    for(id object in self) {
        [collectedArray addObject:funcBlock(object)];
    }
    return [collectedArray asSequence];
}

- (id)reduce:(id (^)(id, id))functorBlock {
    return [[self tail] fold:[self head] with:functorBlock];
}

- (Sequence *)reverse {
    NSMutableArray *collectedArray = [[[NSMutableArray alloc] init] autorelease];
    NSEnumerator *reversed = [arguments reverseObjectEnumerator];
    id object;
    while((object = reversed.nextObject)) {
        [collectedArray addObject:object];
    }
    return [collectedArray asSequence];
}

- (Sequence *)tail {
    return [self takeRight:[arguments count] - 1];
}

- (Sequence *)take:(int)n {
    return [[arguments subarrayWithRange:NSMakeRange(0, (NSUInteger) n)] asSequence];
}

- (Sequence *)takeWhile:(BOOL (^)(id))funcBlock {
    NSMutableArray *collectedArray = [[[NSMutableArray alloc] init] autorelease];
    for (id item in arguments) {
        if (funcBlock(item)) {
            [collectedArray addObject:item];
        } else {
            break;
        }
    }
    return [collectedArray asSequence];
}

- (Sequence *)takeRight:(int)n {
    return [[arguments subarrayWithRange:NSMakeRange([arguments count] - n, (NSUInteger) n)] asSequence];
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


- (NSArray *)asArray {
    return arguments;
}

- (NSDictionary *)asDictionary {
    return [self fold:[NSMutableDictionary dictionary]with:^(NSMutableDictionary *accumulator, Sequence *keyValues) {
        [accumulator setObject:[[keyValues tail] head] forKey:[keyValues head]];
        return accumulator;
    }];
}

- (Sequence *)asSequence {
    return self;
}

- (NSSet *)asSet {
    return [NSSet setWithArray:arguments];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[Sequence class]]) {
        return false;
    }
    Sequence *otherObject = object;
    return [arguments isEqualToArray:[otherObject asArray]];
}


- (void)dealloc {
    [arguments release];
    [super dealloc];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id[])buffer count:(NSUInteger)len {
    return [arguments countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Sequence [%@]", [arguments description]];
}

- (Sequence *)zip:(Sequence *)otherSequence {
    NSEnumerator *enumerator1 = [self toEnumerator];
    NSEnumerator *enumerator2 = [otherSequence toEnumerator];
    id item1;
    id item2;
    NSMutableArray *pairs = [NSMutableArray array];
    while(((item1 = [enumerator1 nextObject]) != nil) && ((item2 = [enumerator2 nextObject]) != nil)) {
        [pairs addObject:[Pair left:item1 right:item2]];
    }
    return [pairs asSequence];
}

- (NSEnumerator *)toEnumerator {
    return [arguments objectEnumerator];
}

+ (id)with:(NSArray *)someArguments {
    return [[[Sequence alloc] initWith:someArguments] autorelease];
}

@end