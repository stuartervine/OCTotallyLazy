#import <Foundation/Foundation.h>
#import "Option.h"
#import "Mappable.h"
#import "Flattenable.h"
#import "Types.h"
@class Sequence;
@class Pair;

@interface NSArray (OCTotallyLazy) <Mappable, Foldable, Enumerable, Flattenable>

- (NSMutableArray *)drop:(int)toDrop;
- (NSMutableArray *)dropWhile:(PREDICATE)funcBlock;
- (NSMutableArray *)filter:(PREDICATE)filterBlock;
- (Option *)find:(PREDICATE)filterBlock;
- (NSMutableArray *)flatMap:(FUNCTION1)functorBlock;
- (NSMutableArray *)flatten;
- (id)fold:(id)value with:(id (^)(id accumulator, id item))functorBlock;
- (void)foreach:(void (^)(id))funcBlock;
- (BOOL)isEmpty;
- (NSMutableArray *)groupBy:(FUNCTION1)groupingBlock;
- (NSMutableArray *)grouped:(int)n;
- (id)head;
- (Option *)headOption;
- (NSMutableArray *)join:(id<Enumerable>)toJoin;
- (id)mapWithIndex:(id (^)(id, NSInteger))funcBlock;
- (Pair *)partition:(PREDICATE)toJoin;
- (id)reduce:(id (^)(id, id))functorBlock;
- (NSMutableArray *)reverse;
- (Pair *)splitWhen:(PREDICATE)predicate;
- (NSMutableArray *)tail;
- (NSMutableArray *)take:(int)n;
- (NSMutableArray *)takeWhile:(PREDICATE)funcBlock;
- (NSMutableArray *)takeRight:(int)n;
- (NSString *)toString;
- (NSString *)toString:(NSString *)separator;
- (NSString *)toString:(NSString *)start separator:(NSString *)separator end:(NSString *)end;
- (NSMutableArray *)zip:(NSArray *)otherSequence;
- (NSMutableArray *)zipWithIndex;

- (Sequence *)asSequence;
- (NSSet *)asSet;
- (NSMutableArray *)asArray;
- (NSDictionary *)asDictionary;

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
