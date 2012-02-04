#import <Foundation/Foundation.h>

static NSSet * set() {
    return [NSSet set];
}

static id setWith(id items, ...) {
    NSMutableSet *set = [NSMutableSet set];
    va_list args;
    va_start(args, items);
    for (id arg = items; arg != nil; arg = va_arg(args, id)) {
        [set addObject:arg];
    }
    va_end(args);
    return set;
}

@interface NSSet (Functional)
- (NSSet *)filter:(BOOL (^)(id))filterBlock;
@end