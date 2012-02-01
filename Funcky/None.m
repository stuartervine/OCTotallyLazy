#import "None.h"

@implementation None
+ (Option *)none {
   return [[[None alloc] init] autorelease];
}

- (id)get {
    return nil;
}

- (BOOL)isEqual:(id)otherObject {
    return [otherObject isKindOfClass:[None class]];
}

@end