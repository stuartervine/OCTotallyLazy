#import "OCTotallyLazyTestCase.h"

@interface RepeatEnumeratorTest : OCTotallyLazyTestCase
@end

@implementation RepeatEnumeratorTest

-(void)testRewindsGivenEnumeratorWhenItReachsTheEnd {
    MemoisedEnumerator *enumerator = [MemoisedEnumerator with:[array(num(1), num(2), nil) toEnumerator]];
    RepeatEnumerator *repeatEnumerator = [RepeatEnumerator with:enumerator];
    assertThat([repeatEnumerator nextObject], equalTo(num(1)));
    assertThat([repeatEnumerator nextObject], equalTo(num(2)));
    assertThat([repeatEnumerator nextObject], equalTo(num(1)));
    assertThat([repeatEnumerator nextObject], equalTo(num(2)));
    assertThat([repeatEnumerator nextObject], equalTo(num(1)));
    assertThat([repeatEnumerator nextObject], equalTo(num(2)));
    assertThat([repeatEnumerator nextObject], equalTo(num(1)));
}

@end