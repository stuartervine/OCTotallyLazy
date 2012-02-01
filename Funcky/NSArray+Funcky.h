#import <Foundation/Foundation.h>
#import "Option.h"

@interface NSArray (Functional)
- (NSArray *)filter:(BOOL (^)(id))filterBlock;
- (NSArray *)flatMap:(id (^)(id))functorBlock;
- (id)fold:(id)value with:(id (^)(id, id))functorBlock;
- (id)head;
- (Option *)headOption;
- (NSArray *)map:(id (^)(id))functorBlock;
- (id)reduce:(id (^)(id, id))functorBlock;
- (NSArray *)tail;
- (NSArray *)take:(int)n;
- (NSArray *)takeRight:(int)n;
@end