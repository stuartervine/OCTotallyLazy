#import "Some.h"

@implementation Some {
    id <NSObject> value;
}

-(Option *)initWithValue:(id <NSObject>)aValue {
    self = [super init];
    value = [aValue retain];
    return self;
}

+ (Option *)some:(id)value {
    return [[[Some alloc] initWithValue: value] autorelease];
}

- (BOOL)isEqual:(id)otherObject {
    if (![otherObject isKindOfClass:[Some class]]) {
        return FALSE;
    }
    return [[otherObject get] isEqual:[self get]];
}

- (id)get {
    return value;
}

- (void)dealloc {
    [value release];
    [super dealloc];
}

@end