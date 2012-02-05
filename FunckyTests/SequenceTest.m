#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "Sequence.h"
#import "Callables.h"
#import "Some.h"
#import "None.h"

@interface SequenceTest : SenTestCase
@end

@implementation SequenceTest

-(void)testConversions {
    Sequence *args = sequence(@"one", @"one", @"two", nil);
    assertThat([args asArray], equalTo([NSArray arrayWithObjects:@"one", @"one", @"two", nil]));
    assertThat([args asSet], equalTo([NSSet setWithObjects:@"one", @"two", nil]));
}

- (void)testFilter {
    Sequence *items = sequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], equalTo(sequence(@"a", @"ab", nil)));
}

- (void)testFlatMap {
    Sequence *items = sequence(
            sequence(@"one", @"two", nil),
            sequence(@"three", @"four", nil),
            nil);
    assertThat([items flatMap:[Callables toUpperCase]], equalTo(sequence(@"ONE", @"TWO", @"THREE", @"FOUR", nil)));
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