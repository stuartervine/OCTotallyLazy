#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <SenTestingKit/SenTestingKit.h>

#import "NSSet+OCTotallyLazy.h"
#import "Callables.h"

@interface NSMutableSetTest : SenTestCase
@end

@implementation NSMutableSetTest

- (void)testFilter {
    NSMutableSet *items = [sequence(@"a", @"ab", @"b", @"bc", nil) asSet];
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], equalTo([sequence(@"a", @"ab", nil) asSet]));
}

- (void)testFold {
    NSMutableSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    NSMutableSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    NSMutableSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([set() headOption], equalTo([None none]));
}

- (void)testJoin {
    NSMutableSet *otherset = [sequence(@"two", @"three", nil) asSet];
    NSMutableSet *join = [[sequence(@"one", @"two", nil) asSet] join:otherset];
    assertThat(join, equalTo([sequence(@"one", @"two", @"three", nil) asSet]));
}

- (void)testMap {
    NSMutableSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items map:[Callables toUpperCase]], equalTo([sequence(@"ONE", @"TWO", @"THREE", nil) asSet]));
}

- (void)testReduce {
    NSMutableSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

@end