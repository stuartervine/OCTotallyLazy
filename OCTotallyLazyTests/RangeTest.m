#define TL_SHORTHAND
#define TL_COERCIONS

#import "OCTotallyLazyTestCase.h"

@interface RangeTest : OCTotallyLazyTestCase
@end

@implementation RangeTest

-(void)testRangeOfNumbersWithStart {
    NSEnumerator *range = [[Range range:@(5)] toEnumerator];
    assertThat([range nextObject], equalTo(@(5)));
    assertThat([range nextObject], equalTo(@(6)));
    assertThat([range nextObject], equalTo(@(7)));
}

-(void)testRangeOfNumbersWithStartAndEnd {
    Sequence *range = [Range range:@(5) end:@(9)];
    assertThat([range asArray], equalTo(array(@(5), @(6), @(7), @(8), @(9), nil)));
}

-(void)testShorthand {
    NSEnumerator *aRange = [[Range range:(@(10))] toEnumerator];
    assertThat([aRange nextObject], equalTo(@(10)));
    assertThat([aRange nextObject], equalTo(@(11)));
    assertThat([aRange nextObject], equalTo(@(12)));
}



@end