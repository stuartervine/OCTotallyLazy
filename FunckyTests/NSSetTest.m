#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "NSSet+Funcky.h"

@interface NSSetTest : SenTestCase
@end

@implementation NSSetTest

- (void)testFilter {
    NSSet *items = [NSSet setWithObjects:@"a", @"ab", @"b", @"bc", nil];
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], equalTo([NSSet setWithObjects:@"a", @"ab", nil]));
}

@end