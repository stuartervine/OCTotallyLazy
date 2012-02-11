#import <Foundation/Foundation.h>

@interface NSEnumerator (Funcky)
- (NSEnumerator *)flatten;
- (NSEnumerator *)map:(id (^)(id))func;
- (NSEnumerator *)filter:(id (^)(id))filterBlock;
@end