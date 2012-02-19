#import <SenTestingKit/SenTestingKit.h>
#import <OCTotallyLazy/OCTotallyLazy.h>
#import "OCTotallyLazyTestCase.h"
#import "MemoisedEnumerator.h"

@interface MemoisedEnumeratorTest : OCTotallyLazyTestCase
@end

@implementation MemoisedEnumeratorTest

-(void)testRemembersEnumeratedObjects {
    NSArray *numbers = array(num(10), num(20), num(30), num(40), nil);
    MemoisedEnumerator *memorisedEnumerator = [MemoisedEnumerator with:[numbers toEnumerator]];

    assertThatInt([memorisedEnumerator previousIndex], equalToInt(-1));
    assertThatInt([memorisedEnumerator nextIndex], equalToInt(0));

    assertThat([memorisedEnumerator nextObject], equalTo(num(10)));
    assertThat([memorisedEnumerator nextObject], equalTo(num(20)));
    assertThat([memorisedEnumerator nextObject], equalTo(num(30)));
    assertThat([memorisedEnumerator nextObject], equalTo(num(40)));
    assertThat([memorisedEnumerator previousObject], equalTo(num(40)));
    assertThat([memorisedEnumerator previousObject], equalTo(num(30)));
    assertThat([memorisedEnumerator previousObject], equalTo(num(20)));
    assertThat([memorisedEnumerator previousObject], equalTo(num(10)));
    assertThat([memorisedEnumerator previousObject], equalTo(nil));
    assertThat([memorisedEnumerator nextObject], equalTo(num(10)));
}

@end