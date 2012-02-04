#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "NSSet+Funcky.h"

@interface NSSetTest : SenTestCase
@end

@implementation NSSetTest

- (void)testFilter {
    NSSet *items = setWith(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], equalTo(setWith(@"a", @"ab", nil)));
}

@end