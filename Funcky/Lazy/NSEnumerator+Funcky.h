#import <Foundation/Foundation.h>

@interface NSEnumerator (Funcky)
- (NSEnumerator *)drop:(int)toDrop;
- (NSEnumerator *)dropWhile:(BOOL (^)(id))filterBlock;
- (NSEnumerator *)flatten;
- (NSEnumerator *)map:(id (^)(id))func;
- (NSEnumerator *)filter:(BOOL (^)(id))filterBlock;
@end