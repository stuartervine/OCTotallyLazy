#import <Foundation/Foundation.h>


@interface Enumerations : NSObject
- (Enumerations *)initWith:(NSEnumerator *)enumerator1;

- (NSArray *)filter:(BOOL (^)(id))filterBlock;
- (NSArray *)map:(id (^)(id))functorBlock;
- (NSArray *)flatMap:(id (^)(id))functorBlock;


+ (Enumerations *)with:(NSEnumerator *)enumerator;
@end