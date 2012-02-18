#import <Foundation/Foundation.h>
#import "Option.h"
#import "Mappable.h"
#import "Sequence.h"
#import "Flattenable.h"

@interface NSArray (Functional) <Mappable, Foldable, Enumerable, Flattenable>

- (NSArray *)drop:(int)toDrop;
- (NSArray *)dropWhile:(BOOL (^)(id))funcBlock;
- (NSArray *)filter:(BOOL (^)(id))filterBlock;
- (Option *)find:(BOOL (^)(id))filterBlock;
- (NSArray *)flatMap:(id (^)(id))functorBlock;
- (NSArray *)flatten;
- (id)fold:(id)value with:(id (^)(id accumulator, id item))functorBlock;
- (id)head;
- (Option *)headOption;
- (NSArray *)join:(id<Enumerable>)toJoin;
- (Pair *)partition:(BOOL (^)(id))toJoin;
- (id)reduce:(id (^)(id, id))functorBlock;
- (NSArray *)reverse;
- (NSArray *)tail;
- (NSArray *)take:(int)n;
- (NSArray *)takeWhile:(BOOL (^)(id))funcBlock;
- (NSArray *)takeRight:(int)n;
- (NSString *)toString;
- (NSString *)toString:(NSString *)separator;
- (NSString *)toString:(NSString *)start separator:(NSString *)separator end:(NSString *)end;
- (NSArray *)zip:(id<Enumerable>)otherSequence;

- (Sequence *)asSequence;
- (NSSet *)asSet;
- (NSArray *)asArray;
@end

static NSArray *array(id items , ...) {
    NSMutableArray *array = [NSMutableArray array];
    va_list args;
    va_start(args, items);
    for (id arg = items; arg != nil; arg = va_arg(args, id)) {
        [array addObject:arg];
    }
    va_end(args);
    return array;
}
