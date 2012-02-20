#import <Foundation/Foundation.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCTotallyLazy/OCTotallyLazy.h>
#import "OCTotallyLazyTestCase.h"

@interface SequenceTest : OCTotallyLazyTestCase
@end

@implementation SequenceTest

-(void)testAdd {
    Sequence *items = sequence(@"one", @"two", nil);
    assertThat([[items add:@"three"] asArray], hasItems(@"one", @"two", @"three", nil));
}

-(void)testCons {
    Sequence *items = sequence(@"one", @"two", nil);
    assertThat([[items cons:@"three"] asArray], hasItems(@"three", @"one", @"two", nil));
}

-(void)testCycle {
    Sequence *cycle = [sequence(num(1), num(2), num(3), nil) cycle];
    assertThat([[cycle take:5] asArray], hasItems(num(1), num(2), num(3), num(1), num(2), nil));
}

-(void)testDrop {
    Sequence *items = sequence(num(1), num(5), num(7), nil);
    assertThat([[items drop:2] asArray], hasItems(num(7), nil));
}

-(void)testDropWhile {
    Sequence *items = sequence(num(7), num(5), num(4), nil);
    assertThat([[items dropWhile:TL_greaterThan(num(4))] asArray], hasItems(num(4), nil));
}

- (void)testFind {
    Sequence *items = sequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items find:TL_startsWith(@"b")], equalTo(option(@"b")));
    assertThat([items find:TL_startsWith(@"d")], equalTo([None none]));
}

- (void)testFilter {
    Sequence *items = sequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([[items filter:TL_startsWith(@"a")] asArray], hasItems(@"a", @"ab", nil));
}

-(void)testFlatten {
    Sequence *items = sequence(
            @"one",
            sequence(@"two", option(@"three"), nil),
            option(@"four"),
            nil);
    assertThat([[items flatten] asArray], hasItems(@"one", @"two", @"three", @"four", nil));
}

- (void)testFlatMap {
    Sequence *items = sequence(
            sequence(@"one", @"two", nil),
            sequence(@"three", @"four", nil),
            nil);
    assertThat([[items flatMap:[Callables toUpperCase]] asArray], hasItems(@"ONE", @"TWO", @"THREE", @"FOUR", nil));
}

- (void)testFold {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testForEach {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    __block NSString *description = @"";
    [items foreach:^(NSString *item){description = [description stringByAppendingString:item];}];
    assertThat(description, equalTo(@"onetwothree"));
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
    assertThat([joined asArray], hasItems(@"one", @"two", @"three", nil));
}

-(void)testMap {
    Sequence *lazy = sequence(num(1), num(2), num(3), nil);
    Sequence *doubled = [lazy map:^(NSNumber *item){return num([item intValue]*2);}];
    assertThat([doubled asArray], hasItems(num(2), num(4), num(6), nil));
}

- (void)testReduce {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testTail {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([[items tail] asArray], hasItems(@"two", @"three", nil));
}

- (void)testTake {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([[items take:2] asArray], hasItems(@"one", @"two", nil));
}

- (void)testTakeWhile {
    Sequence *items = sequence(num(3), num(2), num(1), num(3), nil);
    assertThat([[items takeWhile:TL_greaterThan(num(1))] asArray], hasItems(num(3), num(2), nil));
}

-(void)testToString {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items toString], equalTo(@"onetwothree"));
    assertThat([items toString:@","], equalTo(@"one,two,three"));
    assertThat([items toString:@"(" separator:@"," end:@")"], equalTo(@"(one,two,three)"));

    Sequence *numbers = sequence(num(1), num(2), num(3), nil);
    assertThat([numbers toString], equalTo(@"123"));
}

-(void)testZip {
    Sequence *items = sequence(@"one", @"two", nil);
    Sequence *zip = [items zip:sequence(num(1), num(2), nil)];
    assertThat([zip asArray], hasItems([Pair left:@"one" right:num(1)], [Pair left:@"two" right:num(2)], nil));
}

-(void)testNonForwardBehaviour {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items drop:2], hasItem(@"three"));
    assertThat([items drop:2], hasItem(@"three"));
    assertThat([items dropWhile:TL_equalTo(@"one")], hasItems(@"two", @"three", nil));
    assertThat([items dropWhile:TL_equalTo(@"one")], hasItems(@"two", @"three", nil));

    assertThat([items filter:TL_equalTo(@"one")], hasItem(@"one"));
    assertThat([items filter:TL_equalTo(@"one")], hasItem(@"one"));
    assertThat([items find:TL_equalTo(@"one")], equalTo([Some some:@"one"]));
    assertThat([items find:TL_equalTo(@"one")], equalTo([Some some:@"one"]));

    assertThat([items head], equalTo(@"one"));
    assertThat([items head], equalTo(@"one"));
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([items tail], hasItems(@"two", @"three", nil));
    assertThat([items tail], hasItems(@"two", @"three", nil));
    assertThat([items take:1], hasItems(@"one", nil));
    assertThat([items take:1], hasItems(@"one", nil));

    Sequence *flattenable = sequence(sequence(@"one", nil), @"two", nil);
    assertThat([flattenable flatMap:^(NSString *item){return [item substringFromIndex:1];}], hasItems(@"ne", @"wo", nil));
    assertThat([flattenable flatMap:^(NSString *item){return [item substringFromIndex:1];}], hasItems(@"ne", @"wo", nil));
}

@end