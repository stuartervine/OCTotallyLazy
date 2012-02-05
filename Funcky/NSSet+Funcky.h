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
- (NSSet *)join:(NSSet *)toJoin;
- (id)map:(id (^)(id))functorBlock;
- (id)reduce:(id (^)(id, id))functorBlock;

- (Sequence *)asSequence;
- (NSArray *)asArray;
@end