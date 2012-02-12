#import <Foundation/Foundation.h>
#import "Option.h"
#import "Filters.h"

@interface NSEnumerator (Funcky)
- (NSEnumerator *)drop:(int)toDrop;
- (NSEnumerator *)dropWhile:(BOOL (^)(id))filterBlock;
- (NSEnumerator *)flatten;
- (NSEnumerator *)map:(id (^)(id))func;
- (NSEnumerator *)filter:(BOOL (^)(id))filterBlock;

- (Option *)find:(PREDICATE)predicate;

@end