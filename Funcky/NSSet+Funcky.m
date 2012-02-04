#import "NSSet+Funcky.h"
#import "Enumerations.h"

@implementation NSSet (Functional)

- (NSSet *)filter:(BOOL (^)(id))filterBlock {
    return [NSSet setWithArray:[[Enumerations with:self.objectEnumerator] filter:filterBlock]];
}

- (id)fold:(id)value with:(id (^)(id, id))functorBlock {
    id accumulator = value;
    for (id item in self) {
        accumulator = functorBlock(accumulator, item);
    }
    return accumulator;
}

- (id)head {
    if ([self count] == 0) {
        [NSException raise:@"ArrayBoundsException" format:@"Expected array with at least one element, but array was empty."];
    }
    return [self objectEnumerator].nextObject;
}

- (Option *)headOption {
    return ([self count] > 0) ? [Some some:[self head]] : [None none];
}

@end