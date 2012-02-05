#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "NSSet+Funcky.h"
#import "Callables.h"
#import "Sequence.h"

@interface NSSetTest : SenTestCase
@end

@implementation NSSetTest

- (void)testFilter {
    NSSet *items = [sequence(@"a", @"ab", @"b", @"bc", nil) asSet];
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], equalTo([sequence(@"a", @"ab", nil) asSet]));
}

- (void)testFold {
    NSSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    NSSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    NSSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([set() headOption], equalTo([None none]));
}

@end