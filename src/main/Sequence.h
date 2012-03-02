#import <Foundation/Foundation.h>
#import "Mappable.h"
#import "Option.h"
#import "Enumerable.h"
#import "NSArray+OCTotallyLazy.h"

@interface Sequence : NSObject <NSFastEnumeration, Mappable, Enumerable>

- (Sequence *)initWith:(id <Enumerable>)enumerator;
- (Sequence *)add:(id)value;
- (Sequence *)cons:(id)value;
- (Sequence *)cycle;
- (Sequence *)drop:(int)toDrop;
- (Sequence *)dropWhile:(BOOL (^)(id))funcBlock;
- (Option *)find:(BOOL (^)(id))predicate;
- (Sequence *)flatMap:(id (^)(id))funcBlock;
- (id)filter:(BOOL (^)(id))filterBlock;
- (Sequence *)flatten;
- (id)fold:(id)value with:(id (^)(id accumulator, id item))functorBlock;
- (void)foreach:(void (^)(id))funcBlock;
- (Sequence *)grouped:(int)n;
- (id)head;
- (Option *)headOption;
- (Sequence *)join:(id<Enumerable>)toJoin;
- (id)reduce:(id (^)(id, id))functorBlock;
- (Sequence *)tail;
- (Sequence *)take:(int)n;
- (Sequence *)takeWhile:(BOOL (^)(id))funcBlock;
- (NSString *)toString;
- (NSString *)toString:(NSString *)separator;
- (NSString *)toString:(NSString *)start separator:(NSString *)separator end:(NSString *)end;
- (Sequence *)zip:(Sequence *)otherSequence;

- (NSArray *)asArray;
- (NSSet *)asSet;
- (NSDictionary *)asDictionary;

- (Sequence *)mapWithIndex:(id (^)(id, NSInteger))func;

+ (Sequence *)with:(id <Enumerable>)enumerable;

@end

static Sequence *sequence(id items , ...) {
    NSMutableArray *array = [NSMutableArray array];
    va_list args;
    va_start(args, items);
    for (id arg = items; arg != nil; arg = va_arg(args, id)) {
        [array addObject:arg];
    }
    va_end(args);
    return [Sequence with:array];
}