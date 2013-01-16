#define TL_COERCIONS
#import <SenTestingKit/SenTestingKit.h>
#import "OCTotallyLazy.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface NSMutableArrayTest : SenTestCase
@end

@implementation NSMutableArrayTest

-(void)testDrop {
    NSMutableArray *items = array(num(1), num(5), num(7), nil);
    assertThat([items drop:2], hasItems(num(7), nil));
    assertThat([items drop:1], hasItems(num(5), num(7), nil));
    assertThat([array(nil) drop:1], empty());
}

-(void)testDropWhile {
    NSMutableArray *items = array(num(7), num(5), num(4), nil);
    assertThat([items dropWhile:TL_greaterThan(num(4))], hasItems(num(4), nil));
    assertThat([items dropWhile:TL_greaterThan(num(5))], hasItems(num(5), num(4), nil));
}

- (void)testFilter {
    NSMutableArray *items = array(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], hasItems(@"a", @"ab", nil));
}

- (void)testFind {
    NSMutableArray *items = array(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items find:TL_startsWith(@"b")], equalTo(option(@"b")));
    assertThat([items find:TL_startsWith(@"d")], equalTo([None none]));
}

- (void)testFlatMap {
    NSMutableArray *items = array(
            array(@"one", @"two", nil),
            array(@"three", @"four", nil),
            nil);
    assertThat([items flatMap:[Callables toUpperCase]], hasItems(@"ONE", @"TWO", @"THREE", @"FOUR", nil));
}

-(void)testFlatMapSupportsNDepthSequences {
    NSMutableArray *items = array(
            @"one",
            array(@"two", @"three", nil),
            array(array(@"four", nil), nil),
            nil);
    assertThat([items flatMap:[Callables toUpperCase]], hasItems(@"ONE", @"TWO", @"THREE", @"FOUR", nil));
}

-(void)testFlattenResolvesOptions {
    NSMutableArray *items = array(
            option(@"one"),
            array(option(nil), option(@"two"), nil),
            nil);
    assertThat([items flatten], hasItems(@"one", @"two", nil));
}

- (void)testFold {
    NSMutableArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    NSMutableArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    NSMutableArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([array(nil) headOption], equalTo([None none]));
}

- (void)testJoin {
    NSMutableArray *join = [array(@"one", nil) join:array(@"two", @"three", nil)];
    assertThat(join, hasItems(@"one", @"two", @"three", nil));
}

- (void)testMap {
    NSMutableArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items map:[Callables toUpperCase]], hasItems(@"ONE", @"TWO", @"THREE", nil));
}

-(void)testPartition {
    NSMutableArray *items = array(@"one", @"two", @"three", @"four", nil);
    Pair *partitioned = [items partition:TL_alternate(TRUE)];
    assertThat(partitioned.left, hasItems(@"one", @"three", nil));
    assertThat(partitioned.right, hasItems(@"two", @"four", nil));
}

- (void)testReduce {
    NSMutableArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

-(void)testReverse {
    NSMutableArray *items = array(@"one", @"two", @"three", nil);
    assertThat([items reverse], hasItems(@"three", @"two", @"one", nil));
}

-(void)testSplitOn {
    NSMutableArray *items = array(@"one", @"two", @"three", @"four", nil);

    assertThat([items splitWhen:TL_equalTo(@"three")].left, hasItems(@"one", @"two", nil));
    assertThat([items splitWhen:TL_equalTo(@"three")].right, hasItems(@"four", nil));

    assertThat([items splitWhen:TL_equalTo(@"one")].left, empty());
    assertThat([items splitWhen:TL_equalTo(@"four")].right, empty());
}

- (void)testTail {
    NSMutableArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items tail], hasItems(@"two", @"three", nil));
}

- (void)testTake {
    NSMutableArray *items = [array(@"one", @"two", @"three", nil) asArray];
    assertThat([items take:2], hasItems(@"one", @"two", nil));
    assertThat([items take:0], empty());
}

- (void)testTakeWhile {
    NSMutableArray *items = [array([NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil) asArray];
    assertThat(
        [items takeWhile:^(NSNumber *number) { return (BOOL)(number.intValue < 2); }],
        equalTo([array([NSNumber numberWithInt:1], nil) asArray])
    );
}

- (void)testTakeRight {
    NSMutableArray *items = array(@"one", @"two", @"three", nil);
    assertThat([items takeRight:2], equalTo(array(@"two", @"three", nil)));
    assertThat([items takeRight:0], empty());
    assertThat([items takeRight:10], equalTo(array(@"one", @"two", @"three", nil)));
}

-(void)testToString {
    NSMutableArray *items = array(@"one", @"two", @"three", nil);
    assertThat([items toString], equalTo(@"onetwothree"));
    assertThat([items toString:@","], equalTo(@"one,two,three"));
    assertThat([items toString:@"(" separator:@"," end:@")"], equalTo(@"(one,two,three)"));
    
    NSMutableArray *numbers = array(num(1), num(2), num(3), nil);
    assertThat([numbers toString], equalTo(@"123"));
}

-(void)testZip {
    NSMutableArray *items = array(@"one", @"two", nil);
    NSMutableArray *zip = [items zip:array(num(1), num(2), nil)];
    assertThat(zip, hasItems([Pair left:@"one" right:num(1)], [Pair left:@"two" right:num(2)], nil));
}

-(void)testAsSet {
    NSMutableArray *items = [array(@"one", @"two", @"two", nil) asArray];
    assertThat([items asSet], equalTo([array(@"one", @"two", nil) asSet]));
}

-(void)testAsDictionary {
    NSMutableDictionary *actual = [array(@"key1", @"value1", @"key2", @"value2", @"key3", nil) asDictionary];
    assertThat(actual, equalTo([NSMutableDictionary dictionaryWithObjects:array(@"value1", @"value2", nil)
                                                           forKeys:array(@"key1", @"key2", nil)]));
}

@end