#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "LazySequence.h"
#import "Filters.h"
#import "Callables.h"
#import "None.h"

@interface LazySequenceTest : SenTestCase
@end

@implementation LazySequenceTest

static NSNumber *number(int i) {
    return [NSNumber numberWithInt:i];
}

-(void)testDrop {
    LazySequence *items = lazySequence(number(1), number(5), number(7), nil);
    assertThat([[items drop:2] asSequence], equalTo(sequence(number(7), nil)));
}

-(void)testDropWhile {
    LazySequence *items = lazySequence(number(7), number(5), number(4), nil);
    assertThat([[items dropWhile:FY_greaterThan(number(4))] asSequence], equalTo(sequence(number(4), nil)));
}

- (void)testFind {
    LazySequence *items = lazySequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items find:FY_startsWith(@"b")], equalTo(option(@"b")));
    assertThat([items find:FY_startsWith(@"d")], equalTo([None none]));
}

- (void)testFlatMap {
    LazySequence *items = lazySequence(
            lazySequence(@"one", @"two", nil),
            lazySequence(lazySequence(@"three", nil), @"four", nil),
            nil);
    assertThat([[items flatMap:[Callables toUpperCase]] asSequence], equalTo(sequence(@"ONE", @"TWO", @"THREE", @"FOUR", nil)));
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

-(void)testMap {
    LazySequence *lazy = lazySequence(number(1), number(2), number(3), nil);
    LazySequence *doubled = [lazy map:^(NSNumber *item){return number([item intValue]*2);}];
    assertThat([doubled asSequence], hasItems(number(2), number(4), number(6), nil));
}

@end