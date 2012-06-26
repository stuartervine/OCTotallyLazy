#import "EnumerateEnumerator.h"


@implementation EnumerateEnumerator {
    id (^callableFunc)(id);
}
@synthesize seed;


- (EnumerateEnumerator *)initWithCallable:(id (^)(NSNumber *))aCallableFunc seed:(NSNumber *)aSeed {
    self = [super init];
    callableFunc = [aCallableFunc copy];
    self.seed = aSeed;
    return self;
}

- (id)nextObject {
    id result = self.seed;
    self.seed = callableFunc(self.seed);
    return result;
}



+ (EnumerateEnumerator *)withCallable:(id (^)(NSNumber *))callableFunc seed:(NSNumber *)aSeed {
    return [[EnumerateEnumerator alloc] initWithCallable:callableFunc seed:aSeed];
}

@end