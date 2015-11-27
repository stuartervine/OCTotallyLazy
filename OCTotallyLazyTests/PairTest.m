#define TL_COERCIONS
#define TL_SHORTHAND
#define TL_LAMBDA
#define TL_LAMBDA_SHORTHAND
#import "OCTotallyLazy.h"
#import "OCTotallyLazyTestCase.h"

@interface PairTest : OCTotallyLazyTestCase
@end

@implementation PairTest

-(void)testConvertsToSequence {
    Pair *pair = [Pair left:@"a" right:@"b"];
    assertThat([[pair toSequence] asArray], onlyContains(@"a", @"b", nil));
}

@end