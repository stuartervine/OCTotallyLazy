#import <Foundation/Foundation.h>
#import "Some.h"
#import "None.h"
#import "Sequence.h"

@interface NSSet (Functional) <Mappable, Foldable>
- (NSSet *)filter:(BOOL (^)(id))filterBlock;
- (id)head;
- (Option *)headOption;
- (NSSet *)join:(NSSet *)toJoin;
- (id)reduce:(id (^)(id, id))functorBlock;

- (Sequence *)asSequence;
- (NSArray *)asArray;
@end

static NSSet *set() {
    return [NSSet set];
}