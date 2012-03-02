#import <Foundation/Foundation.h>

@interface MapWithIndexEnumerator : NSEnumerator
+ (NSEnumerator *)withEnumerator:(NSEnumerator *)enumerator andFunction:(id (^)(id, NSInteger))func;
@end