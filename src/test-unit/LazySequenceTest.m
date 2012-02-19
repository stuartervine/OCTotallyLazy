#import <Foundation/Foundation.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCTotallyLazy/OCTotallyLazy.h>
#import "LazySequence.h"
#import "Callables.h"
#import "OCTotallyLazyTestCase.h"

@interface LazySequenceTest : OCTotallyLazyTestCase
@end

@implementation LazySequenceTest

-(void)testAdd {
    LazySequence *items = lazySequence(@"one", @"two", nil);
    assertThat([[items add:@"three"] asArray], hasItems(@"one", @"two", @"three", nil));
}

-(void)testCons {
    LazySequence *items = lazySequence(@"one", @"two", nil);
    assertThat([[items cons:@"three"] asArray], hasItems(@"three", @"one", @"two", nil));
}

-(void)testCycle {
    LazySequence *cycle = [lazySequence(num(1), num(2), num(3), nil) cycle];
    assertThat([[cycle take:5] asArray], hasItems(num(1), num(2), num(3), num(1), num(2), nil));
}

-(void)testDrop {
    LazySequence *items = lazySequence(num(1), num(5), num(7), nil);
    assertThat([[items drop:2] asArray], hasItems(num(7), nil));
}

-(void)testDropWhile {
    LazySequence *items = lazySequence(num(7), num(5), num(4), nil);
    assertThat([[items dropWhile:TL_greaterThan(num(4))] asArray], hasItems(num(4), nil));
}

- (void)testFind {
    LazySequence *items = lazySequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items find:TL_startsWith(@"b")], equalTo(option(@"b")));
    assertThat([items find:TL_startsWith(@"d")], equalTo([None none]));
}

- (void)testFilter {
    LazySequence *items = lazySequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([[items filter:TL_startsWith(@"a")] asArray], hasItems(@"a", @"ab", nil));
}

-(void)testFlatten {
    LazySequence *items = lazySequence(
            @"one",
            lazySequence(@"two", option(@"three"), nil),
            option(@"four"),
            nil);
    assertThat([[items flatten] asArray], hasItems(@"one", @"two", @"three", @"four", nil));
}

- (void)testFlatMap {
    LazySequence *items = lazySequence(
            lazySequence(@"one", @"two", nil),
            lazySequence(@"three", @"four", nil),
            nil);
    assertThat([[items flatMap:[Callables toUpperCase]] asArray], hasItems(@"ONE", @"TWO", @"THREE", @"FOUR", nil));
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
    assertThat([lazySequence(nil) headOption], equalTo([None none]));
}

- (void)testJoin {
    LazySequence *joined = [lazySequence(@"one", nil) join:lazySequence(@"two", @"three", nil)];
    assertThat([joined asArray], hasItems(@"one", @"two", @"three", nil));
}

-(void)testMap {
    LazySequence *lazy = lazySequence(num(1), num(2), num(3), nil);
    LazySequence *doubled = [lazy map:^(NSNumber *item){return num([item intValue]*2);}];
    assertThat([doubled asArray], hasItems(num(2), num(4), num(6), nil));
}

- (void)testReduce {
    LazySequence *items = lazySequence(@"one", @"two", @"three", nil);
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testTail {
    LazySequence *items = lazySequence(@"one", @"two", @"three", nil);
    assertThat([[items tail] asArray], hasItems(@"two", @"three", nil));
}

- (void)testTake {
    LazySequence *items = lazySequence(@"one", @"two", @"three", nil);
    assertThat([[items take:2] asArray], hasItems(@"one", @"two", nil));
}

- (void)testTakeWhile {
    LazySequence *items = lazySequence(num(3), num(2), num(1), num(3), nil);
    assertThat([[items takeWhile:TL_greaterThan(num(1))] asArray], hasItems(num(3), num(2), nil));
}

-(void)testZip {
    LazySequence *items = lazySequence(@"one", @"two", nil);
    LazySequence *zip = [items zip:lazySequence(num(1), num(2), nil)];
    assertThat([zip asArray], hasItems([Pair left:@"one" right:num(1)], [Pair left:@"two" right:num(2)], nil));
}

@end