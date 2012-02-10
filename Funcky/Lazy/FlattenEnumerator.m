#import "FlattenEnumerator.h"
#import "EmptyEnumerator.h"
#import "SingleValueEnumerator.h"
#import "Enumerable.h"


@implementation FlattenEnumerator {
    NSEnumerator *enumerator;
    NSEnumerator *currentEnumerator;
}

- (FlattenEnumerator *)initWithEnumerator:(NSEnumerator *)anEnumerator {
    self = [super init];
    enumerator = [anEnumerator retain];
    currentEnumerator = [EmptyEnumerator emptyEnumerator];
    return self;
}

- (void)dealloc {
    [enumerator release];
    [super dealloc];
}

- (id)getCurrentIterator {
    id item = [currentEnumerator nextObject];
    if(item != nil) {
        return [SingleValueEnumerator singleValue:item];
    }
    currentEnumerator = [enumerator nextObject];
    return currentEnumerator;
}

- (id)nextObject {
    id item;
    while((item = [currentEnumerator nextObject]) == nil) {
        id nextItem = [enumerator nextObject];
        if ([nextItem respondsToSelector:@selector(enumerator)]) {
            currentEnumerator = [nextItem enumerator];
            continue;
        }
        return nextItem;
    }
    return item;
}

+ (NSEnumerator *)withEnumerator:(NSEnumerator *)enumerator {
    return [[[FlattenEnumerator alloc] initWithEnumerator:enumerator] autorelease];
}

@end