#import "SingleValueEnumerator.h"


@implementation SingleValueEnumerator {
    id value;
    BOOL valueRetrieved;
}
- (SingleValueEnumerator *)initWithValue:(id)aValue {
    self = [super init];
    value = [aValue retain];
    valueRetrieved = FALSE;
    return self;

}

+ (SingleValueEnumerator *)singleValue:(id)value {
    return [[[SingleValueEnumerator alloc] initWithValue:value] autorelease];
}

- (id)nextObject {
    if (valueRetrieved) {
        return nil;
    }
    valueRetrieved = TRUE;
    return value;
}

- (void)dealloc {
    [value release];
    [super dealloc];
}

@end