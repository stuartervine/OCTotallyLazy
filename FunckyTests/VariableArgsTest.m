#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "../Funcky/Sequence.h"

@interface VariableArgsTest : SenTestCase
@end

@implementation VariableArgsTest

-(void)testConversions {
    Sequence *args = sequence(@"one", @"one", @"two", nil);
    assertThat([args asArray], equalTo([NSArray arrayWithObjects:@"one", @"one", @"two", nil]));
    assertThat([args asSet], equalTo([NSSet setWithObjects:@"one", @"two", nil]));
}
@end