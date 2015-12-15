#import "OCTotallyLazyTestCase.h"

@interface RepeatEnumeratorTest : OCTotallyLazyTestCase
@end

@implementation RepeatEnumeratorTest

-(void)testRewindsGivenEnumeratorWhenItReachsTheEnd {
    MemoisedEnumerator *enumerator = [MemoisedEnumerator with:[array(@(1), @(2), nil) toEnumerator]];
    RepeatEnumerator *repeatEnumerator = [RepeatEnumerator with:enumerator];
    assertThat([repeatEnumerator nextObject], equalTo(@(1)));
    assertThat([repeatEnumerator nextObject], equalTo(@(2)));
    assertThat([repeatEnumerator nextObject], equalTo(@(1)));
    assertThat([repeatEnumerator nextObject], equalTo(@(2)));
    assertThat([repeatEnumerator nextObject], equalTo(@(1)));
    assertThat([repeatEnumerator nextObject], equalTo(@(2)));
    assertThat([repeatEnumerator nextObject], equalTo(@(1)));
}

@end