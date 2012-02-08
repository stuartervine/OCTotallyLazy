#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "Sequence.h"
#import "Callables.h"
#import "Filters.h"
#import "Some.h"
#import "None.h"

@interface SequenceTest : SenTestCase
@end

@implementation SequenceTest

static NSNumber *number(int i) {
    return [NSNumber numberWithInt:i];
}

-(void)testConversions {
    Sequence *args = sequence(@"one", @"one", @"two", nil);
    assertThat([args asArray], equalTo([NSArray arrayWithObjects:@"one", @"one", @"two", nil]));
    assertThat([args asSet], equalTo([NSSet setWithObjects:@"one", @"two", nil]));
}

-(void)testDrop {
    Sequence *items = sequence(number(1), number(5), number(7), nil);
    assertThat([items drop:2], equalTo(sequence(number(7), nil)));
    assertThat([items drop:1], equalTo(sequence(number(5), number(7), nil)));
    assertThat([sequence(nil) drop:1], equalTo(sequence(nil)));
}

-(void)testDropWhile {
    Sequence *items = sequence(number(7), number(5), number(4), nil);
    assertThat([items dropWhile:FY_greaterThan(number(4))], equalTo(sequence(number(4), nil)));
    assertThat([items dropWhile:FY_greaterThan(number(5))], equalTo(sequence(number(5), number(4), nil)));
}

- (void)testFilter {
    Sequence *items = sequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items filter:FY_startsWith(@"a")], equalTo(sequence(@"a", @"ab", nil)));
}

- (void)testFind {
    Sequence *items = sequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items find:FY_startsWith(@"b")], equalTo(option(@"b")));
    assertThat([items find:FY_startsWith(@"d")], equalTo([None none]));
}

- (void)testFlatMap {
    Sequence *items = sequence(
            sequence(@"one", @"two", nil),
            sequence(@"three", @"four", nil),
            nil);
    assertThat([items flatMap:[Callables toUpperCase]], equalTo(sequence(@"ONE", @"TWO", @"THREE", @"FOUR", nil)));
}

-(void)testFlatMapSupportsNDepthSequences {
    Sequence *items = sequence(
            @"one",
            sequence(@"two", @"three", nil),
            sequence(sequence(@"four", nil), nil),
            nil);
    assertThat([items flatMap:[Callables toUpperCase]], equalTo(sequence(@"ONE", @"TWO", @"THREE", @"FOUR", nil)));
}

-(void)testFlattenResolvesOptions {
    Sequence *items = sequence(
            option(@"one"),
            sequence(option(nil), option(@"two"), nil),
            nil);
    assertThat([items flatten], equalTo(sequence(@"one", @"two", nil)));
}

- (void)testFold {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([sequence(nil) headOption], equalTo([None none]));
}

- (void)testJoin {
    Sequence *joined = [sequence(@"one", nil) join:sequence(@"two", @"three", nil)];
    assertThat(joined, equalTo(sequence(@"one", @"two", @"three", nil)));
}

- (void)testMap {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items map:[Callables toUpperCase]], equalTo(sequence(@"ONE", @"TWO", @"THREE", nil)));
}

- (void)testReduce {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

-(void)testReverse {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items reverse], equalTo(sequence(@"three", @"two", @"one", nil)));
}

- (void)testTail {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items tail], equalTo(sequence(@"two", @"three", nil)));
}

- (void)testTake {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items take:2], equalTo(sequence(@"one", @"two", nil)));
    assertThat([items take:0], equalTo(sequence(nil)));
}

- (void)testTakeWhile {
    Sequence *items = sequence([NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil);
    assertThat(
        [items takeWhile:^(NSNumber *number) { return (BOOL)(number.intValue < 2); }],
        equalTo(sequence([NSNumber numberWithInt:1], nil))
    );
}

- (void)testTakeRight {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items takeRight:2], equalTo(sequence(@"two", @"three", nil)));
    assertThat([items takeRight:0], equalTo(sequence(nil)));
}

@end