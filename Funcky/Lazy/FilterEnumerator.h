#import <Foundation/Foundation.h>


@interface FilterEnumerator : NSEnumerator
- (FilterEnumerator *)initWithEnumerator:(NSEnumerator *)anEnumerator andFilter:(id (^)(id))aFunc;

+ (NSEnumerator *)withEnumerator:(NSEnumerator *)enumerator andFilter:(id (^)(id))func;
@end