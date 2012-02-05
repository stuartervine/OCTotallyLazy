#import <SenTestingKit/SenTestingKit.h>
#import "NSArray+Funcky.h"
#import "NSSet+Funcky.h"
#import "Callables.h"

#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface NSArrayTest : SenTestCase
@end

@implementation NSArrayTest

- (void)testFilter {
    NSArray *items = [sequence(@"a", @"ab", @"b", @"bc", nil) asArray];
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], equalTo([sequence(@"a", @"ab", nil) asArray]));
}

- (void)testFlatMap {
    NSArray *items = [sequence(
            [sequence(@"one", @"two", nil) asArray],
            [sequence(@"three", @"four", nil) asArray],
            nil) asArray];
    assertThat([items flatMap:[Callables toUpperCase]], equalTo([sequence(@"ONE", @"TWO", @"THREE", @"FOUR", nil) asArray]));
}

- (void)testFold {
    NSArray *items = [sequence(@"one", @"two", @"three", nil) asArray];
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    NSArray *items = [sequence(@"one", @"two", @"three", nil) asArray];
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    NSArray *items = [sequence(@"one", @"two", @"three", nil) asArray];
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([array() headOption], equalTo([None none]));
}

- (void)testJoin {
    NSArray *join = [[sequence(@"one", nil) asArray] join:[sequence(@"two", @"three", nil) asArray]];
    assertThat(join, equalTo([sequence(@"one", @"two", @"three", nil) asArray]));
}

- (void)testMap {
    NSArray *items = [sequence(@"one", @"two", @"three", nil) asArray];
    assertThat([items map:[Callables toUpperCase]], equalTo([sequence(@"ONE", @"TWO", @"THREE", nil) asArray]));
}

- (void)testReduce {
    NSArray *items = [sequence(@"one", @"two", @"three", nil) asArray];
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testTail {
    NSArray *items = [sequence(@"one", @"two", @"three", nil) asArray];
    assertThat([items tail], equalTo([sequence(@"two", @"three", nil) asArray]));
}

- (void)testTake {
    NSArray *items = [sequence(@"one", @"two", @"three", nil) asArray];
    assertThat([items take:2], equalTo([sequence(@"one", @"two", nil) asArray]));
    assertThat([items take:0], equalTo(array()));
}

- (void)testTakeWhile {
    NSArray *items = [sequence([NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil) asArray];
    assertThat(
        [items takeWhile:^(NSNumber *number) { return (BOOL)(number.intValue < 2); }],
        equalTo([sequence([NSNumber numberWithInt:1], nil) asArray])
    );
}

- (void)testTakeRight {
    NSArray *items = [sequence(@"one", @"two", @"three", nil) asArray];
    assertThat([items takeRight:2], equalTo([sequence(@"two", @"three", nil) asArray]));
    assertThat([items takeRight:0], equalTo(array()));
}

-(void)testAsSet {
    NSArray *items = [sequence(@"one", @"two", @"two", nil) asArray];
    assertThat([items asSet], equalTo([sequence(@"one", @"two", nil) asSet]));
}

@end