#import "EmptyEnumerator.h"


@implementation EmptyEnumerator

+ (NSEnumerator *)emptyEnumerator {
    return [[[EmptyEnumerator alloc] init] autorelease];
}

- (id)nextObject {
    return nil;
}

@end