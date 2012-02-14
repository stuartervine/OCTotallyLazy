#import <Funcky/Funcky.h>
#import "TakeWhileEnumerator.h"


@implementation TakeWhileEnumerator {
    NSEnumerator *enumerator;

    BOOL (^predicate)(id);

}

- (NSEnumerator *)initWith:(NSEnumerator *)anEnumerator predicate:(PREDICATE)aPredicate {
    self = [super init];
    enumerator = [anEnumerator retain];
    predicate = [aPredicate retain];
    return self;

}

- (id)nextObject {
    id item = [enumerator nextObject];
    return predicate(item) ? item : nil;
}

- (void)dealloc {
    [enumerator release];
    [predicate release];
    [super dealloc];
}

+ (NSEnumerator *)with:(NSEnumerator *)anEnumerator predicate:(PREDICATE)predicate {
    return [[[TakeWhileEnumerator alloc] initWith:anEnumerator predicate:predicate] autorelease];
}
@end