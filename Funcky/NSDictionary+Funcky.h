#import <Foundation/Foundation.h>

@interface NSDictionary (Functional)
-(NSDictionary *)filterKeys:(BOOL (^)(id))functorBlock;
-(NSDictionary *)filterValues:(BOOL (^)(id))functorBlock;
@end