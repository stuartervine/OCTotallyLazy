#import <Foundation/Foundation.h>

@interface Callables : NSObject
+ (NSString * (^)(NSString *))toUpperCase;
+ (NSString * (^)(NSString *, NSString *))appendString;
@end