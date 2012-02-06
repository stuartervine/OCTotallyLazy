#import <Foundation/Foundation.h>
#import "Option.h"
#import "Mappable.h"
#import "Sequence.h"

@interface NSArray (Functional) <Mappable, Foldable>
- (NSArray *)filter:(BOOL (^)(id))filterBlock;
- (NSArray *)flatMap:(id (^)(id))functorBlock;
- (id)head;
- (Option *)headOption;
- (NSArray *)join:(NSArray *)toJoin;
- (id)reduce:(id (^)(id, id))functorBlock;
- (NSArray *)tail;
- (NSArray *)take:(int)n;
- (NSArray *)takeWhile:(BOOL (^)(id))funcBlock;
- (NSArray *)takeRight:(int)n;
- (Sequence *)asSequence;
- (NSSet *)asSet;
- (NSArray *)asArray;
@end

static NSArray * array() {
    return [NSArray array];
}