#import "Sequence.h"
#import "Some.h"
#import "None.h"
#import "NSArray+Funcky.h"

@implementation Sequence {
    NSArray *arguments;
}

- (id)initWith:(NSArray *)someArguments {
    self = [super init];
    arguments = [someArguments retain];
    return self;
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

- (Sequence *)flatMap:(id (^)(id))functorBlock {
    Sequence *aSequence = [self flatten];
    return [aSequence map: functorBlock];
}

- (id)fold:(id)value with:(id (^)(id, id))functorBlock {
    id accumulator = value;
    for (id item in arguments) {
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
    return [sequence(self, toJoin, nil) flatMap:^(id item) { return item; }];
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


- (NSArray *)asArray {
    return arguments;
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

+ (id)with:(NSArray *)someArguments {
    return [[[Sequence alloc] initWith:someArguments] autorelease];
}

@end