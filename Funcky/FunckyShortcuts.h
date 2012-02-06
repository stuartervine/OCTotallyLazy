#import "Option.h"

static Option* option(id value) {
    return [Option option:value];
}

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
