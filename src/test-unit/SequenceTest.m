#import <Foundation/Foundation.h>

#define TL_SHORTHAND
#define TL_COERCIONS

#import "OCTotallyLazy.h"
#import "OCTotallyLazyTestCase.h"

@interface SequenceTest : OCTotallyLazyTestCase

@end

@implementation SequenceTest

- (void)testAdd {
    Sequence *items = sequence(@"one", @"two", nil);
    assertThat([[items add:@"three"] asArray], hasItems(@"one", @"two", @"three", nil));
}

- (void)testCons {
    Sequence *items = sequence(@"one", @"two", nil);
    assertThat([[items cons:@"three"] asArray], hasItems(@"three", @"one", @"two", nil));
}

- (void)testCycle {
    Sequence *cycle = [sequence(num(1), num(2), num(3), nil) cycle];
    assertThat([[cycle take:5] asArray], hasItems(num(1), num(2), num(3), num(1), num(2), nil));
}

- (void)testDrop {
    Sequence *items = sequence(num(1), num(5), num(7), nil);
    assertThat([[items drop:2] asArray], hasItems(num(7), nil));
}

- (void)testDropWhile {
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

- (void)testFlatten {
    Sequence *items = sequence(
            @"one",
            sequence(@"two", option(@"three"), nil),
            option(@"four"),
            nil);
    assertThat([[items flatten] asArray], hasItems(@"one", @"two", @"three", @"four", nil));
}

- (void)testFlatMap {
    Sequence *items = sequence(
            sequence(@"one", [None none], nil),
            sequence(@"three", @"four", nil),
            nil);
    assertThat([[items flatMap:[Callables toUpperCase]] asArray], hasItems(@"ONE", @"THREE", @"FOUR", nil));

    Sequence *numbers = sequence(num(1), num(2), num(3), num(4), nil);
    Sequence *flattenedNumbers = [numbers flatMap:^(NSNumber *number) {
        return (number.intValue % 2) == 0 ? [None none] : option(number);
    }];
    assertThat([flattenedNumbers asArray], hasItems(num(1), num(3), nil));
}

- (void)testFold {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testForEach {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    __block NSString *description = @"";
    [items foreach:^(NSString *item) {
        description = [description stringByAppendingString:item];
    }];
    assertThat(description, equalTo(@"onetwothree"));
}

- (void)testGroupBy {
    Sequence *groups = [sequence(@"one", @"two", @"three", @"four", @"five", @"six", @"seven", nil) groupBy:^(NSString *item) {
        return num(item.length);
    }];
    assertThat([[groups first] key], equalTo(num(3)));
    assertThat([groups first], hasItems(@"one", @"two", @"six", nil));
    assertThat([[groups second] key], equalTo(num(5)));
    assertThat([groups second], hasItems(@"three", @"seven", nil));
}

- (void)testGroupByHandlesNilKeyAsUniqueGroup {
    NSString *nilString = nil;
    Sequence *groups = [sequence(@"one", @"two", @"three", nil) groupBy:^(NSString *item) {
        return nilString;
    }];
    assertThatInt([[groups asArray] count], equalToInt(3));
    assertThat([groups first], hasItems(@"one", nil));

}

- (void)testGrouped {
    Sequence *items = sequence(num(1), num(2), num(3), num(4), num(5), nil);
    NSArray *array1 = [[items grouped:4] asArray];
    assertThat(array1, hasItems(array(num(1), num(2), num(3), num(4), nil), array(num(5), nil), nil));
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

- (void)testMap {
    Sequence *lazy = sequence(num(1), num(2), num(3), nil);
    Sequence *doubled = [lazy map:^(NSNumber *item) {
        return num([item intValue] * 2);
    }];
    assertThat([doubled asArray], hasItems(num(2), num(4), num(6), nil));
}

- (void)testMapLiftsMappables {
    Sequence *lazy = sequence(@[num(1)], option(num(2)), [None none], nil);
    Sequence *doubled = [lazy map:^(NSNumber *item) {
        return num([item intValue] * 2);
    }];
    assertThat([doubled asArray], hasItems(@[num(2)], option(num(4)), [None none], nil));
}

- (void)testMapWithIndex {
    Sequence *lazy = sequence(@"one", @"two", @"three", nil);
    Sequence *indexes = [lazy mapWithIndex:^(id item, NSInteger index) {
        return num(index);
    }];
    assertThat([indexes asArray], hasItems(num(0), num(1), num(2), nil));
}

- (void)testMerge {
    Sequence *result1 = [sequence(@"1", @"2", nil) merge:sequence(@"3", @"4", @"5", nil)];
    assertThat([result1 asArray], hasItems(@"1", @"3", @"2", @"4", @"5", nil));

    Sequence *result2 = [sequence(@"1", @"2", @"3", nil) merge:sequence(@"4", @"5", nil)];
    assertThat([result2 asArray], hasItems(@"1", @"4", @"2", @"5", @"4", nil));
}

- (void)testPartition {
    Sequence *items = sequence(@"one", @"two", @"three", @"four", nil);
    Pair *partitioned = [items partition:TL_alternate(TRUE)];
    assertThat([partitioned.left asArray], hasItems(@"one", @"three", nil));
    assertThat([partitioned.left asArray], hasItems(@"one", @"three", nil)); //Test non-forward only.
    assertThat([partitioned.right asArray], hasItems(@"two", @"four", nil));
}

- (void)testReduce {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));

    assertThat([sequence(nil) reduce:[Callables appendString]], equalTo(nil));
}

- (void)testSplitAt {
    Sequence *items = sequence(@"one", @"two", @"three", @"four", nil);
    Pair *split = [items splitAt:2];
    assertThat([split.left asArray], hasItems(@"one", @"two", nil));
    assertThat([split.right asArray], hasItems(@"four", nil));
}

- (void)testSplitOn {
    Sequence *items = sequence(@"one", @"two", @"three", @"four", nil);

    assertThat([[items splitOn:@"three"].left asArray], hasItems(@"one", @"two", nil));
    assertThat([[items splitOn:@"three"].right asArray], hasItems(@"four", nil));

    assertThat([[items splitOn:@"one"].left asArray], empty());
    assertThat([[items splitOn:@"four"].right asArray], empty());
}

- (void)testSplitWhen {
    Sequence *items = sequence(@"one", @"two", @"three", @"four", nil);

    assertThat([[items splitWhen:TL_equalTo(@"three")].left asArray], hasItems(@"one", @"two", nil));
    assertThat([[items splitWhen:TL_equalTo(@"three")].right asArray], hasItems(@"four", nil));

    assertThat([[items splitWhen:TL_equalTo(@"one")].left asArray], empty());
    assertThat([[items splitWhen:TL_equalTo(@"four")].right asArray], empty());
}

- (void)testTail {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([[items tail] asArray], hasItems(@"two", @"three", nil));
}

- (void)testTailOnEmptySequence {
    [sequence(nil) tail];
}

- (void)testTake {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([[items take:2] asArray], hasItems(@"one", @"two", nil));
}

- (void)testTakeWhile {
    Sequence *items = sequence(num(3), num(2), num(1), num(3), nil);
    assertThat([[items takeWhile:TL_greaterThan(num(1))] asArray], hasItems(num(3), num(2), nil));
}

- (void)testToString {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items toString], equalTo(@"onetwothree"));
    assertThat([items toString:@","], equalTo(@"one,two,three"));
    assertThat([items toString:@"(" separator:@"," end:@")"], equalTo(@"(one,two,three)"));

    Sequence *numbers = sequence(num(1), num(2), num(3), nil);
    assertThat([numbers toString], equalTo(@"123"));
}

- (void)testZip {
    Sequence *items = sequence(@"one", @"two", nil);
    Sequence *zip = [items zip:sequence(num(1), num(2), nil)];
    assertThat([zip asArray], hasItems([Pair left:@"one" right:num(1)], [Pair left:@"two" right:num(2)], nil));
}

- (void)testZipWithIndex {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    Sequence *zippedWithIndex = [items zipWithIndex];
    assertThat([zippedWithIndex asArray], hasItems(
            [Pair left:@"one" right:num(0)],
            [Pair left:@"two" right:num(1)],
            [Pair left:@"three" right:num(2)],
            nil));

}

- (void)testToDictionary {
    Sequence *items = sequence(@"one", @"one", @"two", @"three", nil);
    __block int count = 0;
    NSDictionary *lengths = [items toDictionary:^(NSString *item) {
        return num(count++);
    }];
    assertThat(lengths, hasEntries(@"one", num(0), @"two", num(1), @"three", num(2), nil));
}

/*
    <K> Sequence<Group<K, T>> groupBy(final Callable1<? super T, ? extends K> callable);

    Sequence<Sequence<T>> recursive(final Callable1<Sequence<T>, Pair<Sequence<T>, Sequence<T>>> callable);

    Pair<Sequence<T>,Sequence<T>> span(final Predicate<? super T> predicate);

    Pair<Sequence<T>,Sequence<T>> breakOn(final Predicate<? super T> predicate);

 */

- (void)testNonForwardBehaviour {
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
    assertThat([flattenable flatMap:^(NSString *item) {
        return [item substringFromIndex:1];
    }], hasItems(@"ne", @"wo", nil));
    assertThat([flattenable flatMap:^(NSString *item) {
        return [item substringFromIndex:1];
    }], hasItems(@"ne", @"wo", nil));
}

@end