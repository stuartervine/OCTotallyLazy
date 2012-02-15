#import <Foundation/Foundation.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <Funcky/Funcky.h>
#import "LazySequence.h"
#import "Filters.h"
#import "Callables.h"
#import "None.h"
#import "Some.h"
#import "FunckyTestCase.h"
#import "Funcky.h"

@interface LazySequenceTest : FunckyTestCase
@end

@implementation LazySequenceTest

-(void)testAdd {
    LazySequence *items = lazySequence(@"one", @"two", nil);
    assertThat([[items add:@"three"] asSequence], equalTo(sequence(@"one", @"two", @"three", nil)));
}

-(void)testCons {
    LazySequence *items = lazySequence(@"one", @"two", nil);
    assertThat([[items cons:@"three"] asSequence], equalTo(sequence(@"three", @"one", @"two", nil)));
}

-(void)testCycle {
    LazySequence *cycle = [lazySequence(num(1), num(2), num(3), nil) cycle];
    Sequence *const subsetSeq = [[cycle take:5] asSequence];
    assertThat(subsetSeq, equalTo(sequence(num(1), num(2), num(3), num(1), num(2), nil)));
}

-(void)testDrop {
    LazySequence *items = lazySequence(num(1), num(5), num(7), nil);
    assertThat([[items drop:2] asSequence], equalTo(sequence(num(7), nil)));
}

-(void)testDropWhile {
    LazySequence *items = lazySequence(num(7), num(5), num(4), nil);
    assertThat([[items dropWhile:FY_greaterThan(num(4))] asSequence], equalTo(sequence(num(4), nil)));
}

- (void)testFind {
    LazySequence *items = lazySequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items find:FY_startsWith(@"b")], equalTo(option(@"b")));
    assertThat([items find:FY_startsWith(@"d")], equalTo([None none]));
}

- (void)testFilter {
    LazySequence *items = lazySequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([[items filter:FY_startsWith(@"a")] asSequence], equalTo(sequence(@"a", @"ab", nil)));
}

-(void)testFlatten {
    LazySequence *items = lazySequence(
            @"one",
            lazySequence(@"two", option(@"three"), nil),
            option(@"four"),
            nil);
    assertThat([[items flatten] asSequence], equalTo(sequence(@"one", @"two", @"three", @"four", nil)));
}

- (void)testFlatMap {
    LazySequence *items = lazySequence(
            lazySequence(@"one", @"two", nil),
            lazySequence(@"three", @"four", nil),
            nil);
    assertThat([[items flatMap:[Callables toUpperCase]] asSequence], equalTo(sequence(@"ONE", @"TWO", @"THREE", @"FOUR", nil)));
}

- (void)testFold {
    LazySequence *items = lazySequence(@"one", @"two", @"three", nil);
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    LazySequence *items = lazySequence(@"one", @"two", @"three", nil);
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    LazySequence *items = lazySequence(@"one", @"two", @"three", nil);
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([sequence(nil) headOption], equalTo([None none]));
}

- (void)testJoin {
    LazySequence *joined = [lazySequence(@"one", nil) join:lazySequence(@"two", @"three", nil)];
    assertThat([joined asSequence], equalTo(sequence(@"one", @"two", @"three", nil)));
}

-(void)testMap {
    LazySequence *lazy = lazySequence(num(1), num(2), num(3), nil);
    LazySequence *doubled = [lazy map:^(NSNumber *item){return num([item intValue]*2);}];
    assertThat([doubled asSequence], hasItems(num(2), num(4), num(6), nil));
}

- (void)testReduce {
    LazySequence *items = lazySequence(@"one", @"two", @"three", nil);
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testTake {
    LazySequence *items = lazySequence(@"one", @"two", @"three", nil);
    assertThat([[items take:2] asSequence], equalTo(sequence(@"one", @"two", nil)));
}

- (void)testTakeWhile {
    LazySequence *items = lazySequence(num(3), num(2), num(1), num(3), nil);
    assertThat([[items takeWhile:FY_greaterThan(num(1))] asSequence], equalTo(sequence(num(3), num(2), nil)));
}

-(void)testZip {
    LazySequence *items = lazySequence(@"one", @"two", nil);
    LazySequence *zip = [items zip:lazySequence(num(1), num(2), nil)];
    assertThat([zip asSequence], equalTo(sequence([Pair left:@"one" right:num(1)], [Pair left:@"two" right:num(2)], nil)));
}

@end