#import "NSSet+Funcky.h"
#import "Enumerations.h"

@implementation NSSet (Functional)

- (NSSet *)filter:(BOOL (^)(id))filterBlock {
    return [NSSet setWithArray:[[Enumerations with:self.objectEnumerator] filter:filterBlock]];
}

@end