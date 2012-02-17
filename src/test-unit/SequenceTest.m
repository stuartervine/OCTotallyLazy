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

static NSNumber *num(int i) {
    return [NSNumber numberWithInt:i];
}

-(void)testConversions {
    Sequence *args = sequence(@"one", @"one", @"two", nil);
    assertThat([args asArray], equalTo([NSArray arrayWithObjects:@"one", @"one", @"two", nil]));
    assertThat([args asSet], equalTo([NSSet setWithObjects:@"one", @"two", nil]));
}

-(void)testDrop {
    Sequence *items = sequence(num(1), num(5), num(7), nil);
    assertThat([items drop:2], equalTo(sequence(num(7), nil)));
    assertThat([items drop:1], equalTo(sequence(num(5), num(7), nil)));
    assertThat([sequence(nil) drop:1], equalTo(sequence(nil)));
}

-(void)testDropWhile {
    Sequence *items = sequence(num(7), num(5), num(4), nil);
    assertThat([items dropWhile:TL_greaterThan(num(4))], equalTo(sequence(num(4), nil)));
    assertThat([items dropWhile:TL_greaterThan(num(5))], equalTo(sequence(num(5), num(4), nil)));
}

- (void)testFilter {
    Sequence *items = sequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items filter:TL_startsWith(@"a")], equalTo(sequence(@"a", @"ab", nil)));
}

- (void)testFind {
    Sequence *items = sequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items find:TL_startsWith(@"b")], equalTo(option(@"b")));
    assertThat([items find:TL_startsWith(@"d")], equalTo([None none]));
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

-(void)testPartition {
    Sequence *items = sequence(@"one", @"two", @"three", @"four", nil);
    Pair *partitioned = [items partition:TL_alternate(TRUE)];
    assertThat(partitioned.left, equalTo(sequence(@"one", @"three", nil)));
    assertThat(partitioned.right, equalTo(sequence(@"two", @"four", nil)));
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

-(void)testToString {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items toString], equalTo(@"onetwothree"));
    assertThat([items toString:@","], equalTo(@"one,two,three"));
    assertThat([items toString:@"(" separator:@"," end:@")"], equalTo(@"(one,two,three)"));
}

-(void)testZip {
    Sequence *items = sequence(@"one", @"two", nil);
    Sequence *zip = [items zip:sequence(num(1), num(2), nil)];
    assertThat(zip, equalTo(sequence([Pair left:@"one" right:num(1)], [Pair left:@"two" right:num(2)], nil)));
}

@end