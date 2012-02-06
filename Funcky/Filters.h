#import <Foundation/Foundation.h>

@interface Filters : NSObject
+ (BOOL (^)(NSString *))isEqualToString:(NSString *)comparable;
+ (BOOL (^)(id))isEqual:(id)comparable;
+ (BOOL (^)(id))isGreaterThan:(NSNumber *)comparable;
@end