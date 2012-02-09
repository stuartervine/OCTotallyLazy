#import "Pair.h"


@implementation Pair {

@private
    id _left;
    id _right;
}
@synthesize left = _left;
@synthesize right = _right;

- (Pair *)initWithLeft:(id)aLeft right:(id)aRight {
    self = [super init];
    _left = [aLeft retain];
    _right = [aRight retain];
    return self;
}

+ (Pair *)left:(id)aLeft right:(id)aRight {
    return [[[Pair alloc] initWithLeft:aLeft right:aRight] autorelease];
}

- (void)dealloc {
    [_right release];
    [_left release];
    [super dealloc];
}


@end