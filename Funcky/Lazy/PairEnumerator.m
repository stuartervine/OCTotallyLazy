#import "PairEnumerator.h"
#import "Pair.h"


@implementation PairEnumerator {
    NSEnumerator *left;
    NSEnumerator *right;
}
- (PairEnumerator *)initWithLeft:(NSEnumerator *)leftEnumerator right:(NSEnumerator *)rightEnumerator {
    self = [super init];
    left = [leftEnumerator retain];
    right = [rightEnumerator retain];
    return self;
}

- (id)nextObject {
    id leftItem;
    id rightItem;
    while(((leftItem = [left nextObject]) != nil) && ((rightItem = [right nextObject]) != nil)){
        return [Pair left:leftItem right:rightItem];
    }
    return nil;
}


- (void)dealloc {
    [left release];
    [right release];
    [super dealloc];
}

+ (PairEnumerator *)withLeft:(NSEnumerator *)leftEnumerator right:(NSEnumerator *)rightEnumerator {
    return [[[PairEnumerator alloc] initWithLeft:leftEnumerator right:rightEnumerator] autorelease];
}

@end