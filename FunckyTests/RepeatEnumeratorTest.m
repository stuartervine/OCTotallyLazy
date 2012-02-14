#import <Funcky/Funcky.h>
#import "FunckyTestCase.h"
#import "Enumerable.h"
#import "MemoisedEnumerator.h"
#import "RepeatEnumerator.h"

@interface RepeatEnumeratorTest : FunckyTestCase
@end

@implementation RepeatEnumeratorTest

-(void)testRewindsGivenEnumeratorWhenItReachsTheEnd {
    MemoisedEnumerator *enumerator = [MemoisedEnumerator with:[sequence(num(1), num(2), nil) objectEnumerator]];
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