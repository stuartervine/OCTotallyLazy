#import <Foundation/Foundation.h>
#import "Option.h"
#import "Mappable.h"
#import "Enumerations.h"

static NSArray * array() {
    return [NSArray array];
}

static id arrayWith(id items, ...) {
    NSMutableArray *array = [NSMutableArray array];
    va_list args;
    va_start(args, items);
    for (id arg = items; arg != nil; arg = va_arg(args, id)) {
        [array addObject:arg];
    }
    va_end(args);
    return array;
}

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
- (NSSet *)asSet;
@end