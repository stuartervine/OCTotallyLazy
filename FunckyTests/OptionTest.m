#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "Some.h"
#import "None.h"


@interface OptionTest : SenTestCase
@end

@implementation OptionTest

-(void)testSomesWithSameValueAreEqual {
    assertThat([Some some:@"bob"], equalTo([Some some:@"bob"]));
}

-(void)testNoneGetGivesNil {
    assertThat([[None none] get], equalTo(nil));
}
@end