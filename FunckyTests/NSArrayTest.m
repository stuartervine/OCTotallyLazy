#import <SenTestingKit/SenTestingKit.h>
#import "NSArray+Funcky.h"
#import "Some.h"
#import "None.h"

#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface NSArrayTest : SenTestCase
@end

@implementation NSArrayTest

NSString *(^toUpperCase)(NSString *) = ^(NSString *item) {
    return item.uppercaseString;
};

NSString *(^appendString)(NSString *, NSString *) = ^(NSString *left, NSString *right) {
    return [left stringByAppendingString:right];
};

- (void)testFilter {
    NSArray *const items = [NSArray arrayWithObjects:@"a", @"ab", @"b", @"bc", nil];
    assertThat([items filter:^(NSString *item){return [item hasPrefix:@"a"];}], equalTo([NSArray arrayWithObjects:@"a", @"ab", nil]));
}

- (void)testFlatMap {
    NSArray *items = [NSArray arrayWithObjects:
            [NSArray arrayWithObjects:@"one", @"two", nil],
            [NSArray arrayWithObjects:@"three", @"four", nil],
            nil
    ];
    assertThat([items flatMap:toUpperCase], equalTo([NSArray arrayWithObjects:@"ONE", @"TWO", @"THREE", @"FOUR", nil]));
}

- (void)testFold {
    NSArray *items = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    assertThat([items fold:@"" with:appendString], equalTo(@"onetwothree"));
}

- (void)testHead {
    NSArray *items = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    assertThat([items head], equalTo(@"one"));
}

- (void)testHeadOption {
    NSArray *items = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    assertThat([items headOption], equalTo([Some some:@"one"]));
    assertThat([[NSArray array] headOption], equalTo([None none]));
}

- (void)testMap {
    NSArray *items = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    assertThat([items map:toUpperCase], equalTo([NSArray arrayWithObjects:@"ONE", @"TWO", @"THREE", nil]));
}

- (void)testReduce {
    NSArray *items = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    assertThat([items reduce:appendString], equalTo(@"onetwothree"));
}

- (void)testTail {
    NSArray *items = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    assertThat([items tail], equalTo([NSArray arrayWithObjects:@"two", @"three", nil]));
}

- (void)testTake {
    NSArray *items = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    assertThat([items take:2], equalTo([NSArray arrayWithObjects:@"one", @"two", nil]));
    assertThat([items take:0], equalTo([NSArray array]));
}

- (void)testTakeRight {
    NSArray *items = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    assertThat([items takeRight:2], equalTo([NSArray arrayWithObjects:@"two", @"three", nil]));
    assertThat([items takeRight:0], equalTo([NSArray array]));
}

@end