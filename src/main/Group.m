#import "Group.h"

@implementation Group
@synthesize key;


- (Group *)initWithKey:(id <NSObject>)aKey enumerable:(id <Enumerable>)anEnumerable {
    self = [super initWith:anEnumerable];
    if (self) {
        self.key = aKey;
    }
    return self;
}

- (void)dealloc {
    [key release];
    [super dealloc];
}

+(Group *)group:(id)key enumerable:(id<Enumerable>)enumerable {
    return [[[Group alloc] initWithKey:key enumerable:enumerable] autorelease];
}
@end