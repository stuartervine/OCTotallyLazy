#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "NSSet+Funcky.h"
#import "Callables.h"

@interface NSSetTest : SenTestCase
@end

@implementation NSSetTest

- (void)testFilter {
    NSSet *items = setWith(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], equalTo(setWith(@"a", @"ab", nil)));
}

- (void)testFold {
    NSSet *items = setWith(@"one", @"two", @"three", nil);
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    NSSet *items = setWith(@"one", @"two", @"three", nil);
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    NSSet *items = setWith(@"one", @"two", @"three", nil);
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([set() headOption], equalTo([None none]));
}

@end