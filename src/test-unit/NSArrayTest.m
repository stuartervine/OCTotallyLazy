#import <SenTestingKit/SenTestingKit.h>
#import "../main/OCTotallyLazy.h"
#import "Callables.h"

#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface NSArrayTest : SenTestCase
@end

@implementation NSArrayTest

static NSNumber *num(int i) {
    return [NSNumber numberWithInt:i];
}

-(void)testDrop {
    NSArray *items = array(num(1), num(5), num(7), nil);
    assertThat([items drop:2], hasItems(num(7), nil));
    assertThat([items drop:1], hasItems(num(5), num(7), nil));
    assertThat([array(nil) drop:1], empty());
}

-(void)testDropWhile {
    NSArray *items = array(num(7), num(5), num(4), nil);
    assertThat([items dropWhile:TL_greaterThan(num(4))], hasItems(num(4), nil));
    assertThat([items dropWhile:TL_greaterThan(num(5))], hasItems(num(5), num(4), nil));
}

- (void)testFilter {
    NSArray *items = array(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], hasItems(@"a", @"ab", nil));
}

- (void)testFind {
    NSArray *items = array(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items find:TL_startsWith(@"b")], equalTo(option(@"b")));
    assertThat([items find:TL_startsWith(@"d")], equalTo([None none]));
}

- (void)testFlatMap {
    NSArray *items = array(
            array(@"one", @"two", nil),
            array(@"three", @"four", nil),
            nil);
    assertThat([items flatMap:[Callables toUpperCase]], hasItems(@"ONE", @"TWO", @"THREE", @"FOUR", nil));
}

-(void)testFlatMapSupportsNDepthSequences {
    NSArray *items = array(
            @"one",
            array(@"two", @"three", nil),
            array(array(@"four", nil), nil),
            nil);
    assertThat([items flatMap:[Callables toUpperCase]], hasItems(@"ONE", @"TWO", @"THREE", @"FOUR", nil));
}

-(void)testFlattenResolvesOptions {
    NSArray *items = array(
            option(@"one"),
            array(option(nil), option(@"two"), nil),
            nil);
    assertThat([items flatten], hasItems(@"one", @"two", nil));
}

- (void)testFold {
    NSArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    NSArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    NSArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([array(nil) headOption], equalTo([None none]));
}

- (void)testJoin {
    NSArray *join = [array(@"one", nil) join:array(@"two", @"three", nil)];
    assertThat(join, hasItems(@"one", @"two", @"three", nil));
}

- (void)testMap {
    NSArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items map:[Callables toUpperCase]], hasItems(@"ONE", @"TWO", @"THREE", nil));
}

-(void)testPartition {
    NSArray *items = array(@"one", @"two", @"three", @"four", nil);
    Pair *partitioned = [items partition:TL_alternate(TRUE)];
    assertThat(partitioned.left, hasItems(@"one", @"three", nil));
    assertThat(partitioned.right, hasItems(@"two", @"four", nil));
}

- (void)testReduce {
    NSArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

-(void)testReverse {
    NSArray *items = array(@"one", @"two", @"three", nil);
    assertThat([items reverse], hasItems(@"three", @"two", @"one", nil));
}

- (void)testTail {
    NSArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items tail], hasItems(@"two", @"three", nil));
}

- (void)testTake {
    NSArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items take:2], hasItems(@"one", @"two", nil));
    assertThat([items take:0], empty());
}

- (void)testTakeWhile {
    NSArray *items = [array([NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil) asArray];
    assertThat(
        [items takeWhile:^(NSNumber *number) { return (BOOL)(number.intValue < 2); }],
        equalTo([array([NSNumber numberWithInt:1], nil) asArray])
    );
}

- (void)testTakeRight {
    NSArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items takeRight:2], equalTo([array(@"two", @"three", nil) asArray]));
    assertThat([items takeRight:0], empty());
}

-(void)testToString {
    NSArray *items = array(@"one", @"two", @"three", nil);
    assertThat([items toString], equalTo(@"onetwothree"));
    assertThat([items toString:@","], equalTo(@"one,two,three"));
    assertThat([items toString:@"(" separator:@"," end:@")"], equalTo(@"(one,two,three)"));
    
    NSArray *numbers = array(num(1), num(2), num(3), nil);
    assertThat([numbers toString], equalTo(@"123"));
}

-(void)testZip {
    NSArray *items = array(@"one", @"two", nil);
    NSArray *zip = [items zip:array(num(1), num(2), nil)];
    assertThat(zip, hasItems([Pair left:@"one" right:num(1)], [Pair left:@"two" right:num(2)], nil));
}

-(void)testAsSet {
    NSArray *items = [array(@"one", @"two", @"two", nil) asArray];
    assertThat([items asSet], equalTo([array(@"one", @"two", nil) asSet]));
}

@end