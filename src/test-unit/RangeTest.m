#define TL_COERCIONS
#define TL_SHORTHAND
#define TL_LAMBDA
#define TL_LAMBDA_SHORTHAND
#import "OCTotallyLazy.h"
#import "OCTotallyLazyTestCase.h"

@interface RangeTest : OCTotallyLazyTestCase
@end

@implementation RangeTest

-(void)testRangeOfNumbersWithStart {
    NSEnumerator *range = [[Range range:num(5)] toEnumerator];
    assertThat([range nextObject], equalTo(num(5)));
    assertThat([range nextObject], equalTo(num(6)));
    assertThat([range nextObject], equalTo(num(7)));
}

-(void)testRangeOfNumbersWithStartAndEnd {
    Sequence *range = [Range range:num(5) end:num(9)];
    assertThat([range asArray], equalTo(array(num(5), num(6), num(7), num(8), num(9), nil)));
}

-(void)testShorthand {
    NSEnumerator *range = [range(num(10)) toEnumerator];
    assertThat([range nextObject], equalTo(num(10)));
    assertThat([range nextObject], equalTo(num(11)));
    assertThat([range nextObject], equalTo(num(12)));
}



@end