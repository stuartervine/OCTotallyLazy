#import "None.h"
#import "NoSuchElementException.h"
#import "Some.h"

@implementation None
+ (Option *)none {
   return [[[None alloc] init] autorelease];
}

- (id)get {
    [NoSuchElementException raise:@"Cannot get value of None" format:@"Cannot get value of None"];
}

- (BOOL)isEqual:(id)otherObject {
    return [otherObject isKindOfClass:[None class]];
}

- (id)map:(id (^)(id))funcBlock {
    return [None none];
}

- (id)fold:(id)seed with:(id (^)(id, id))functorBlock {
    return [Some some:seed];
}
@end