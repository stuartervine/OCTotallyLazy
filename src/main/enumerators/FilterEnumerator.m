#import "FilterEnumerator.h"


@implementation FilterEnumerator {
    NSEnumerator *enumerator;
    BOOL (^filterBlock)(id);
}

- (FilterEnumerator *)initWithEnumerator:(NSEnumerator *)anEnumerator andFilter:(BOOL (^)(id))aFilterBlock {
    self = [super init];
    enumerator = [anEnumerator retain];
    filterBlock = [aFilterBlock copy];
    return self;
}

+ (NSEnumerator *)withEnumerator:(NSEnumerator *)enumerator andFilter:(BOOL (^)(id))filterBlock {
    return [[[FilterEnumerator alloc] initWithEnumerator:enumerator andFilter:filterBlock] autorelease];
}

- (id)nextObject {
    id item;
    while((item = [enumerator nextObject])) {
        if(filterBlock(item)) {
            return item;
        }
    }
    return nil;
}

- (void)dealloc {
    [enumerator release];
    [filterBlock release];
    [super dealloc];
}


@end