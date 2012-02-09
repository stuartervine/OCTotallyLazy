#import <Foundation/Foundation.h>
#import "Mappable.h"
#import "Sequence.h"

@interface LazySequence : NSObject <NSFastEnumeration, Mappable>

- (LazySequence *)initWith:(NSEnumerator *)enumerator;

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