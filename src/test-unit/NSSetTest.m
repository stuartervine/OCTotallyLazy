#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "NSSet+OCTotallyLazy.h"
#import "LazySequence.h"
#import "Callables.h"

@interface NSSetTest : SenTestCase
@end

@implementation NSSetTest

- (void)testFilter {
    NSSet *items = [lazySequence(@"a", @"ab", @"b", @"bc", nil) asSet];
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], equalTo([lazySequence(@"a", @"ab", nil) asSet]));
}

- (void)testFold {
    NSSet *items = [lazySequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    NSSet *items = [lazySequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    NSSet *items = [lazySequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([set() headOption], equalTo([None none]));
}

- (void)testJoin {
    NSSet *otherset = [lazySequence(@"two", @"three", nil) asSet];
    NSSet *join = [[lazySequence(@"one", @"two", nil) asSet] join:otherset];
    assertThat(join, equalTo([lazySequence(@"one", @"two", @"three", nil) asSet]));
}

- (void)testMap {
    NSSet *items = [lazySequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items map:[Callables toUpperCase]], equalTo([lazySequence(@"ONE", @"TWO", @"THREE", nil) asSet]));
}

- (void)testReduce {
    NSSet *items = [lazySequence(@"one", @"two", @"three", nil) asSet];
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

@end