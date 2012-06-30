#import "Callables.h"

@implementation Callables
+ (NSString * (^)(NSString *))toUpperCase {
    return [[^(NSString *item) { return item.uppercaseString; } copy] autorelease];
}
+(NSString * (^)(NSString *, NSString *))appendString {
    return [[^(NSString *left, NSString *right) { return [left stringByAppendingString:right]; } copy] autorelease];
}

+ (ACCUMULATOR_TO_STRING)appendWithSeparator:(NSString *)separator {
        return [[^(id left, id right) {
            return [[[left description] stringByAppendingString:separator] stringByAppendingString:[right description]];
        } copy] autorelease];
}

+ (CALLABLE_TO_STRING)upperCase {
    return [[^(id <NSObject> item) {
        return [item description].uppercaseString;
    } copy] autorelease];
}

+ (CALLABLE_TO_NUMBER)increment {
    return [[^(NSNumber *item) {
        return [NSNumber numberWithLong:item.longValue + 1];
    } copy] autorelease];

}
@end