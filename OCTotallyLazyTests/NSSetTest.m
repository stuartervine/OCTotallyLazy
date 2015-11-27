#define HC_SHORTHAND
#import <XCTest/XCTest.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#import "NSSet+OCTotallyLazy.h"
#import "Callables.h"

@interface NSSetTest : XCTestCase
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

- (void)testJoin {
    NSSet *otherset = [sequence(@"two", @"three", nil) asSet];
    NSSet *join = [[sequence(@"one", @"two", nil) asSet] join:otherset];
    assertThat(join, equalTo([sequence(@"one", @"two", @"three", nil) asSet]));
}

- (void)testMap {
    NSSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items map:[Callables toUpperCase]], equalTo([sequence(@"ONE", @"TWO", @"THREE", nil) asSet]));
}

- (void)testReduce {
    NSSet *items = [sequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

@end