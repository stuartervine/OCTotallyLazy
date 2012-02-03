#import <Foundation/Foundation.h>

@interface NSSet (Functional)
- (NSSet *)filter:(BOOL (^)(id))filterBlock;
@end