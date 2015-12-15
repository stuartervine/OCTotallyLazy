#define TL_COERCIONS

#import "OCTotallyLazyTestCase.h"

@interface GroupedEnumeratorTest : OCTotallyLazyTestCase
@end

@implementation GroupedEnumeratorTest

-(void)testGroupsItemsIntoSequencesOfNSize {
    NSArray *items = array(@(1), @(2), @(3) , @(4), @(5), nil);
    NSEnumerator *groups = [GroupedEnumerator with:[items toEnumerator] groupSize:2];
    assertThat([groups nextObject], contains(@(1), @(2), nil));
    assertThat([groups nextObject], contains(@(3), @(4), nil));
    assertThat([groups nextObject], contains(@(5), nil));
    assertThat([groups nextObject], equalTo(nil));

    groups = [GroupedEnumerator with:[items toEnumerator] groupSize:3];
    assertThat([groups nextObject], contains(@(1), @(2), @(3), nil));
    assertThat([groups nextObject], contains(@(4), @(5), nil));
}

@end