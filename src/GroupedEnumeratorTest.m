#import <Foundation/Foundation.h>
#import "OCTotallyLazyTestCase.h"
#define TL_COERCIONS
#import <OCTotallyLazy/OCTotallyLazy.h>
#import "GroupedEnumerator.h"

@interface GroupedEnumeratorTest : OCTotallyLazyTestCase
@end

@implementation GroupedEnumeratorTest

-(void)testGroupsItemsIntoSequencesOfNSize {
    NSArray *items = array(num(1), num(2), num(3) , num(4), num(5), nil);
    NSEnumerator *groups = [GroupedEnumerator with:[items toEnumerator] groupSize:2];
    assertThat([groups nextObject], hasItems(num(1), num(2), nil));
    assertThat([groups nextObject], hasItems(num(3), num(4), nil));
    assertThat([groups nextObject], hasItems(num(5), nil));
    assertThat([groups nextObject], equalTo(nil));

    groups = [GroupedEnumerator with:[items toEnumerator] groupSize:3];
    assertThat([groups nextObject], hasItems(num(1), num(2), num(3), nil));
    assertThat([groups nextObject], hasItems(num(4), num(5), nil));
}

@end