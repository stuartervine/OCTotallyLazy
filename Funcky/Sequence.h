#import <Foundation/Foundation.h>
#import "Option.h"

@interface Sequence : NSObject <NSFastEnumeration, Mappable>
- (id)initWith:(NSArray *)arguments;

+ (id)with:(NSArray *)arguments;

- (Sequence *)drop:(int)toDrop;
- (Sequence *)dropWhile:(BOOL (^)(id))funcBlock;
- (Sequence *)filter:(BOOL (^)(id))filterBlock;
- (Option *)find:(BOOL (^)(id))filterBlock;
- (Sequence *)flatMap:(id (^)(id))functorBlock;
- (Sequence *)flatten;
- (id)fold:(id)value with:(id (^)(id, id))functorBlock;
- (id)head;
- (Option *)headOption;
- (Sequence *)join:(Sequence *)toJoin;
- (id)reduce:(id (^)(id, id))functorBlock;
- (Sequence *)reverse;
- (Sequence *)tail;
- (Sequence *)take:(int)n;
- (Sequence *)takeWhile:(BOOL (^)(id))funcBlock;
- (Sequence *)takeRight:(int)n;

- (NSArray *)asArray;
- (Sequence *)asSequence;
- (NSSet *)asSet;
@end

static Sequence *sequence(id items, ...) {
    NSMutableArray *array = [NSMutableArray array];
    va_list args;
    va_start(args, items);
    for (id arg = items; arg != nil; arg = va_arg(args, id)) {
        [array addObject:arg];
    }
    va_end(args);
    return [Sequence with:array];
}
