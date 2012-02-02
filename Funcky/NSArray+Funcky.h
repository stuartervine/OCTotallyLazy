#import <Foundation/Foundation.h>
#import "Option.h"
#import "Mappable.h"

@interface NSArray (Functional) <Mappable>
- (NSArray *)filter:(BOOL (^)(id))filterBlock;
- (NSArray *)flatMap:(id (^)(id))functorBlock;
- (id)fold:(id)value with:(id (^)(id, id))functorBlock;
- (id)head;
- (Option *)headOption;
- (NSArray *)join:(NSArray *)toJoin;
- (id)map:(id (^)(id))functorBlock;
- (id)reduce:(id (^)(id, id))functorBlock;
- (NSArray *)tail;
- (NSArray *)take:(int)n;
- (NSArray *)takeWhile:(BOOL (^)(id))funcBlock;
- (NSArray *)takeRight:(int)n;
@end