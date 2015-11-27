#import <Foundation/Foundation.h>
#import <OCTotallyLazy/OCTotallyLazy.h>

#define TL_SHORTHAND
#define TL_COERCIONS

#import "OCTotallyLazy.h"
#import "OCTotallyLazyTestCase.h"
#import "KeyWithoutToString.h"

@interface SequenceTest : OCTotallyLazyTestCase
@property(nonatomic, strong) NSNumber *checkRetained;
@end

@implementation SequenceTest

- (void)testAdd {
    Sequence *items = sequence(@"one", @"two", nil);
    assertThat([[items add:@"three"] asArray], contains(@"one", @"two", @"three", nil));
}

- (void)testCons {
    Sequence *items = sequence(@"one", @"two", nil);
    assertThat([[items cons:@"three"] asArray], contains(@"three", @"one", @"two", nil));
}

- (void)testCycle {
    Sequence *cycle = [sequence(@1, @2, @3, nil) cycle];
    assertThat([[cycle take:5] asArray], contains(@1, @2, @3, @1, @2, nil));
}

- (void)testDrop {
    Sequence *items = sequence(@1, @5, @7, nil);
    assertThat([[items drop:2] asArray], contains(@7, nil));
}

- (void)testDropWhile {
    Sequence *items = sequence(@7, @5, @4, nil);
    assertThat([[items dropWhile:TL_greaterThan(@4)] asArray], contains(@4, nil));
}

- (void)testFind {
    Sequence *items = sequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items find:TL_startsWith(@"b")], equalTo(option(@"b")));
    assertThat([items find:TL_startsWith(@"d")], equalTo([None none]));
}

- (void)testFilter {
    Sequence *items = sequence(@"a", @"ab", @"b", @"bc", nil);
    assertThat([[items filter:TL_startsWith(@"a")] asArray], contains(@"a", @"ab", nil));
}

- (void)testFlatten {
    Sequence *items = sequence(
            @"one",
            sequence(@"two", option(@"three"), nil),
            option(@"four"),
            nil);
    assertThat([[items flatten] asArray], contains(@"one", @"two", @"three", @"four", nil));
}

- (void)testFlatMap {
    Sequence *items = sequence(
            sequence(@"one", [None none], nil),
            sequence(@"three", @"four", nil),
            nil);
    assertThat([[items flatMap:[Callables identity]] asArray], contains(@"one", [None none], @"three", @"four", nil));

    Sequence *numbers = sequence(@1, @2, @3, @4, nil);
    Sequence *flattenedNumbers = [numbers flatMap:^(NSNumber *number) {
        return (number.intValue % 2) == 0 ? [None none] : option(number);
    }];
    assertThat([flattenedNumbers asArray], contains(@1, @3, nil));
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
        return [NSNumber numberWithInt:item.length];
    }];
    assertThat([[groups first] key], equalTo(@3));
    assertThat([groups first], contains(@"one", @"two", @"six", nil));
    assertThat([[groups second] key], equalTo(@5));
    assertThat([groups second], contains(@"three", @"seven", nil));
}

- (void)testGroupByHandlesNilKeyAsUniqueGroup {
    NSString *nilString = nil;
    Sequence *groups = [sequence(@"one", @"two", @"three", nil) groupBy:^(NSString *item) {
        return nilString;
    }];
    assertThatInt([[groups asArray] count], equalToInt(3));
    assertThat([groups first], contains(@"one", nil));
}

- (void)testGroupByGeneratesMappableGroups {
    Sequence *groups = [sequence(@"one", @"two", @"three", @"four", @"five", @"six", @"seven", nil) groupBy:^(NSString *item) {
        return [NSNumber numberWithInt:item.length];
    }];
    Sequence *counts = [groups map:^id(Group *g) {
        return @([[g asArray] count]);
    }];
    assertThat(counts, contains(@3, @2, @2, nil));
    assertThatInt([[counts asArray] count], equalToInt(3));
}

- (void)testGrouped {
    Sequence *items = sequence(@1, @2, @3, @4, @5, nil);
    NSArray *array1 = [[items grouped:4] asArray];
    assertThat(array1, contains(array(@1, @2, @3, @4, nil), array(@5, nil), nil));
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
    assertThat([joined asArray], contains(@"one", @"two", @"three", nil));
}

- (void)testMap {
    Sequence *lazy = sequence(@1, @2, @3, nil);
    Sequence *doubled = [lazy map:^(NSNumber *item) {
        return @([item intValue] * 2);
    }];
    assertThat([doubled asArray], contains(@2, @4, @6, nil));
}

- (void)testMapDoesNotRetainBlocks {
    self.checkRetained = @0;
    Sequence *lazy = sequence(@1, @2, @3, nil);
    [[lazy map:^(NSNumber *item) {
        self.checkRetained = @(self.checkRetained.intValue + 1);
        return item;
    }] asArray];
    assertThat(self.checkRetained, equalTo(@3));
}

- (void)testMapWithIndex {
    Sequence *lazy = sequence(@"one", @"two", @"three", nil);
    Sequence *indexes = [lazy mapWithIndex:^(id item, NSInteger index) {
        return @(index);
    }];
    assertThat([indexes asArray], contains(@0, @1, @2, nil));
}

- (void)testMapWithIndexNested {
    Sequence *lazy = sequence(@"one", @"two", @"three", sequence(@"nestedOne", @"nestedTwo", nil), nil);
    Sequence *indexes = [lazy mapWithIndex:^(id item, NSInteger index) {
        return @(index);
    }];
    assertThat([indexes asArray], contains(@0, @1, @2, @3, nil));
}

- (void)testMerge {
    Sequence *result1 = [sequence(@"1", @"2", nil) merge:sequence(@"3", @"4", @"5", nil)];
    assertThat([result1 asArray], contains(@"1", @"3", @"2", @"4", @"5", nil));

    Sequence *result2 = [sequence(@"1", @"2", @"3", nil) merge:sequence(@"4", @"5", nil)];
    assertThat([result2 asArray], contains(@"1", @"4", @"2", @"5", @"4", nil));
}

- (void)testPartition {
    Sequence *items = sequence(@"one", @"two", @"three", @"four", nil);
    Pair *partitioned = [items partition:TL_alternate(TRUE)];
    assertThat([partitioned.left asArray], contains(@"one", @"three", nil));
    assertThat([partitioned.left asArray], contains(@"one", @"three", nil)); //Test non-forward only.
    assertThat([partitioned.right asArray], contains(@"two", @"four", nil));
}

- (void)testReduce {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));

    assertThat([sequence(nil) reduce:[Callables appendString]], equalTo(nil));
}

- (void)testSplitAt {
    Sequence *items = sequence(@"one", @"two", @"three", @"four", nil);
    Pair *split = [items splitAt:2];
    assertThat([split.left asArray], contains(@"one", @"two", nil));
    assertThat([split.right asArray], contains(@"four", nil));
}

- (void)testSplitOn {
    Sequence *items = sequence(@"one", @"two", @"three", @"four", nil);

    assertThat([[items splitOn:@"three"].left asArray], contains(@"one", @"two", nil));
    assertThat([[items splitOn:@"three"].right asArray], contains(@"four", nil));

    assertThat([[items splitOn:@"one"].left asArray], isEmpty());
    assertThat([[items splitOn:@"four"].right asArray], isEmpty());
}

- (void)testSplitWhen {
    Sequence *items = sequence(@"one", @"two", @"three", @"four", nil);

    assertThat([[items splitWhen:TL_equalTo(@"three")].left asArray], contains(@"one", @"two", nil));
    assertThat([[items splitWhen:TL_equalTo(@"three")].right asArray], contains(@"four", nil));

    assertThat([[items splitWhen:TL_equalTo(@"one")].left asArray], isEmpty());
    assertThat([[items splitWhen:TL_equalTo(@"four")].right asArray], isEmpty());
}

- (void)testTail {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([[items tail] asArray], contains(@"two", @"three", nil));
}

- (void)testTailOnEmptySequence {
    [sequence(nil) tail];
}

- (void)testTake {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([[items take:2] asArray], contains(@"one", @"two", nil));
}

- (void)testTakeWhile {
    Sequence *items = sequence(@3, @2, @1, @3, nil);
    assertThat([[items takeWhile:TL_greaterThan(@1)] asArray], contains(@3, @2, nil));
}

- (void)testToString {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items toString], equalTo(@"onetwothree"));
    assertThat([items toString:@","], equalTo(@"one,two,three"));
    assertThat([items toString:@"(" separator:@"," end:@")"], equalTo(@"(one,two,three)"));

    Sequence *numbers = sequence(@1, @2, @3, nil);
    assertThat([numbers toString], equalTo(@"123"));
}

- (void)testZip {
    Sequence *items = sequence(@"one", @"two", nil);
    Sequence *zip = [items zip:sequence(@1, @2, nil)];
    assertThat([zip asArray], contains([Pair left:@"one" right:@1], [Pair left:@"two" right:@2], nil));
}

- (void)testZipWithIndex {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    Sequence *zippedWithIndex = [items zipWithIndex];
    assertThat([zippedWithIndex asArray], contains(
            [Pair left:@"one" right:@0],
            [Pair left:@"two" right:@1],
            [Pair left:@"three" right:@2],
            nil));

}

- (void)testToDictionary {
    Sequence *items = sequence(@"one", @"one", @"two", @"three", nil);
    __block int count = 0;
    NSDictionary *lengths = [items toDictionary:^(NSString *item) {
        return @(count++);
    }];
    assertThat(lengths, hasEntries(@"one", @0, @"two", @1, @"three", @2, nil));
}

- (void)testToDictionaryWithKeysThatAreNotToStringable {
    KeyWithoutToString *key1 = [[KeyWithoutToString alloc] initWithValue:@"one"];
    KeyWithoutToString *key2 = [[KeyWithoutToString alloc] initWithValue:@"two"];
    NSArray *items = @[
            key1,
            key1,
            key2
            ];
    __block int count = 0;
    NSDictionary *lengths = [[items asSequence] toDictionary:^(NSString *item) {
        return @(count++);
    }];
    assertThat(lengths, hasEntries(key1, @0, key2, @1, nil));
}

/*
    <K> Sequence<Group<K, T>> groupBy(final Callable1<? super T, ? extends K> callable);

    Sequence<Sequence<T>> recursive(final Callable1<Sequence<T>, Pair<Sequence<T>, Sequence<T>>> callable);

    Pair<Sequence<T>,Sequence<T>> span(final Predicate<? super T> predicate);

    Pair<Sequence<T>,Sequence<T>> breakOn(final Predicate<? super T> predicate);

 */

- (void)testNonForwardBehaviour {
    Sequence *items = sequence(@"one", @"two", @"three", nil);
    assertThat([items drop:2], contains(@"three", nil));
    assertThat([items drop:2], contains(@"three", nil));
    assertThat([items dropWhile:TL_equalTo(@"one")], contains(@"two", @"three", nil));
    assertThat([items dropWhile:TL_equalTo(@"one")], contains(@"two", @"three", nil));

    assertThat([items filter:TL_equalTo(@"one")], contains(@"one", nil));
    assertThat([items filter:TL_equalTo(@"one")], contains(@"one", nil));
    assertThat([items find:TL_equalTo(@"one")], equalTo([Some some:@"one"]));
    assertThat([items find:TL_equalTo(@"one")], equalTo([Some some:@"one"]));

    assertThat([items head], equalTo(@"one"));
    assertThat([items head], equalTo(@"one"));
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([items tail], contains(@"two", @"three", nil));
    assertThat([items tail], contains(@"two", @"three", nil));
    assertThat([items take:1], contains(@"one", nil));
    assertThat([items take:1], contains(@"one", nil));

    Sequence *flattenable = sequence(@"one", @"two", nil);
    assertThat([flattenable flatMap:^(NSString *item) {
        return option([item substringFromIndex:1]);
    }], contains(@"ne", @"wo", nil));
    assertThat([flattenable flatMap:^(NSString *item) {
        return option([item substringFromIndex:1]);
    }], contains(@"ne", @"wo", nil));
}

@end