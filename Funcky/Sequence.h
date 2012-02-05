#import <Foundation/Foundation.h>
#import "Enumerations.h"

@interface Sequence : NSObject
- (id)initWith:(NSArray *)arguments;

+ (id)with:(NSMutableArray *)array1;

- (NSArray *)asArray;
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
