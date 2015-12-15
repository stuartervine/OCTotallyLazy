#import "OCTotallyLazyTestCase.h"

@interface MemoisedEnumeratorTest : OCTotallyLazyTestCase
@end

@implementation MemoisedEnumeratorTest

-(void)testRemembersEnumeratedObjects {
    NSArray *numbers = array(@(10), @(20), @(30), @(40), nil);
    MemoisedEnumerator *memorisedEnumerator = [MemoisedEnumerator with:[numbers toEnumerator]];

    assertThatInt([memorisedEnumerator previousIndex], equalToInt(-1));
    assertThatInt([memorisedEnumerator nextIndex], equalToInt(0));

    assertThat([memorisedEnumerator nextObject], equalTo(@(10)));
    assertThat([memorisedEnumerator nextObject], equalTo(@(20)));
    assertThat([memorisedEnumerator nextObject], equalTo(@(30)));
    assertThat([memorisedEnumerator nextObject], equalTo(@(40)));
    assertThat([memorisedEnumerator previousObject], equalTo(@(40)));
    assertThat([memorisedEnumerator previousObject], equalTo(@(30)));
    assertThat([memorisedEnumerator previousObject], equalTo(@(20)));
    assertThat([memorisedEnumerator previousObject], equalTo(@(10)));
    assertThat([memorisedEnumerator previousObject], equalTo(nil));
    assertThat([memorisedEnumerator nextObject], equalTo(@(10)));
}

@end