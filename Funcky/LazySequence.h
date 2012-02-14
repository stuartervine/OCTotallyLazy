#import <Foundation/Foundation.h>
#import "Mappable.h"
#import "Sequence.h"
#import "Enumerable.h"

@interface LazySequence : NSObject <NSFastEnumeration, Mappable, Enumerable>

- (LazySequence *)initWith:(NSEnumerator *)enumerator;
- (LazySequence *)drop:(int)toDrop;
- (LazySequence *)dropWhile:(BOOL (^)(id))funcBlock;
- (Option *)find:(BOOL (^)(id))predicate;
- (LazySequence *)flatMap:(id (^)(id))funcBlock;
- (id)filter:(BOOL (^)(id))filterBlock;
- (LazySequence *)flatten;
- (id)fold:(id)value with:(id (^)(id accumulator, id item))functorBlock;
- (id)head;
- (Option *)headOption;
- (LazySequence *)join:(LazySequence *)toJoin;
- (id)reduce:(id (^)(id, id))functorBlock;
- (LazySequence *)take:(int)n;
- (LazySequence *)takeWhile:(BOOL (^)(id))funcBlock;
- (LazySequence *)zip:(LazySequence *)otherSequence;

- (Sequence *)asSequence;


+ (LazySequence *)with:(NSEnumerator *)enumerator;
@end

static LazySequence *lazySequence(id items , ...) {
    NSMutableArray *array = [NSMutableArray array];
    va_list args;
    va_start(args, items);
    for (id arg = items; arg != nil; arg = va_arg(args, id)) {
        [array addObject:arg];
    }
    va_end(args);
    return [LazySequence with:[array objectEnumerator]];
}