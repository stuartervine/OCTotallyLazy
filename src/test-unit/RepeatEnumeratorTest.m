#import <OCTotallyLazy/OCTotallyLazy.h>
#import "OCTotallyLazyTestCase.h"
#import "MemoisedEnumerator.h"
#import "RepeatEnumerator.h"

@interface RepeatEnumeratorTest : OCTotallyLazyTestCase
@end

@implementation RepeatEnumeratorTest

-(void)testRewindsGivenEnumeratorWhenItReachsTheEnd {
    MemoisedEnumerator *enumerator = [MemoisedEnumerator with:[sequence(num(1), num(2), nil) toEnumerator]];
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