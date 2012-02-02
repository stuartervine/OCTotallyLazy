#import "Callables.h"

@implementation Callables
+ (NSString * (^)(NSString *))toUpperCase {
    return [[^(NSString *item) { return item.uppercaseString; } copy] autorelease];
}
+(NSString * (^)(NSString *, NSString *))appendString {
    return [[^(NSString *left, NSString *right) { return [left stringByAppendingString:right]; } copy] autorelease];
}
@end