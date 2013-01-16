#import <Foundation/Foundation.h>
#import "Some.h"
#import "None.h"
#import "Sequence.h"

@interface NSSet (Functional) <Mappable, Foldable, Enumerable>
- (Option *)find:(PREDICATE)filterBlock;
- (NSMutableSet *)filter:(PREDICATE)filterBlock;
- (NSMutableSet *)groupBy:(FUNCTION1)groupingBlock;
- (id)head;
- (Option *)headOption;
- (NSMutableSet *)join:(NSMutableSet *)toJoin;
- (id)reduce:(FUNCTION2)functorBlock;

- (Sequence *)asSequence;
- (NSMutableArray *)asArray;
@end

static NSMutableSet *set() {
    return [NSMutableSet set];
}