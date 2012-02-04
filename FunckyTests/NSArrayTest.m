#import <SenTestingKit/SenTestingKit.h>
#import "NSArray+Funcky.h"
#import "NSSet+Funcky.h"
#import "Some.h"
#import "None.h"
#import "Callables.h"

#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface NSArrayTest : SenTestCase
@end

@implementation NSArrayTest

- (void)testFilter {
    NSArray *const items = arrayWith(@"a", @"ab", @"b", @"bc", nil);
    assertThat([items filter:^(NSString *item) { return [item hasPrefix:@"a"]; }], equalTo(arrayWith(@"a", @"ab", nil)));
}

- (void)testFlatMap {
    NSArray *items = arrayWith(
            arrayWith(@"one", @"two", nil),
            arrayWith(@"three", @"four", nil),
            nil);
    assertThat([items flatMap:[Callables toUpperCase]], equalTo(arrayWith(@"ONE", @"TWO", @"THREE", @"FOUR", nil)));
}

- (void)testFold {
    NSArray *items = arrayWith(@"one", @"two", @"three", nil);
    assertThat([items fold:@"" with:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testHead {
    NSArray *items = arrayWith(@"one", @"two", @"three", nil);
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    NSArray *items = arrayWith(@"one", @"two", @"three", nil);
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([array() headOption], equalTo([None none]));
}

- (void)testJoin {
    NSArray *join = [arrayWith(@"one", nil) join:arrayWith(@"two", @"three", nil)];
    assertThat(join, equalTo(arrayWith(@"one", @"two", @"three", nil)));
}

- (void)testMap {
    NSArray *items = arrayWith(@"one", @"two", @"three", nil);
    assertThat([items map:[Callables toUpperCase]], equalTo(arrayWith(@"ONE", @"TWO", @"THREE", nil)));
}

- (void)testReduce {
    NSArray *items = arrayWith(@"one", @"two", @"three", nil);
    assertThat([items reduce:[Callables appendString]], equalTo(@"onetwothree"));
}

- (void)testTail {
    NSArray *items = arrayWith(@"one", @"two", @"three", nil);
    assertThat([items tail], equalTo(arrayWith(@"two", @"three", nil)));
}

- (void)testTake {
    NSArray *items = arrayWith(@"one", @"two", @"three", nil);
    assertThat([items take:2], equalTo(arrayWith(@"one", @"two", nil)));
    assertThat([items take:0], equalTo(array()));
}

- (void)testTakeWhile {
    NSArray *items = arrayWith([NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil);
    assertThat(
        [items takeWhile:^(NSNumber *number) { return (BOOL)(number.intValue < 2); }],
        equalTo(arrayWith([NSNumber numberWithInt:1], nil))
    );
}

- (void)testTakeRight {
    NSArray *items = arrayWith(@"one", @"two", @"three", nil);
    assertThat([items takeRight:2], equalTo(arrayWith(@"two", @"three", nil)));
    assertThat([items takeRight:0], equalTo(array()));
}

-(void)testAsSet {
    assertThat([arrayWith(@"one", @"two", @"two", nil) asSet], equalTo(setWith(@"one", @"two", nil)));
}

@end