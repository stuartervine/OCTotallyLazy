#import "EasyEnumerable.h"


@implementation EasyEnumerable {
    NSEnumerator *(^convertToEnumerator)();
}
-(EasyEnumerable *)initWith:(NSEnumerator *(^)())aConvertToEnumerator {
    self = [super init];
    convertToEnumerator = [aConvertToEnumerator copy];
    return self;
}

+(EasyEnumerable *)with:(NSEnumerator *(^)())aConvertToEnumerator {
    return [[[EasyEnumerable alloc] initWith:aConvertToEnumerator] autorelease];
}

- (NSEnumerator *)toEnumerator {
    return convertToEnumerator();
}

- (void)dealloc {
    [convertToEnumerator release];
    [super dealloc];
}
@end