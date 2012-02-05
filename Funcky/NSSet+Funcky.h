#import <Foundation/Foundation.h>
#import "Some.h"
#import "None.h"
#import "Sequence.h"

static NSSet * set() {
    return [NSSet set];
}

@interface NSSet (Functional)
- (NSSet *)filter:(BOOL (^)(id))filterBlock;
- (id)fold:(id)value with:(id (^)(id, id))functorBlock;
- (id)head;
- (Option *)headOption;

- (Sequence *)asSequence;
- (NSArray *)asArray;
@end