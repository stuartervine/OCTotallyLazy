#define TL_SHORTHAND
#import "OCTotallyLazyTestCase.h"

@interface NumbersTest : OCTotallyLazyTestCase
@end

@implementation NumbersTest

- (void)testMax {
    assertThat([sequence(@(1), @(2), @(3), nil) reduce:TL_max()], equalTo(@(3)));
}

- (void)testMin {
    assertThat([sequence(@(1), @(2), @(3), nil) reduce:TL_min()], equalTo(@(1)));
}

- (void)testSum {
    assertThat([sequence(@(1), @(2), @(3), nil) reduce:TL_sum()], equalTo(@(6)));
    assertThat([sequence(@(1.1), @(2.2), @(3.3), nil) reduce:TL_sum()], equalTo(@(6.6)));
}

- (void)testAverage {
    assertThat([sequence(@(1), @(2), @(3), nil) reduce:TL_average()], equalTo(@(2)));
}

- (void)testMultiplyBy {
    NSNumber *const multiplier = @(10);
    assertThat([[sequence(@(1), nil) map:TL_multiplyBy(multiplier)] asArray], onlyContains(@(10), nil));
    assertThat([[sequence(@(2.5), nil) map:TL_multiplyBy(multiplier)] asArray], onlyContains(@(25.0), nil));
}

- (void)testDivideBy {
    NSNumber *divisor = @(5.0);
    assertThat([[sequence(@(35.0), nil) map:TL_divideBy(divisor)] asArray], onlyContains(@(7.0), nil));
    assertThat([[sequence(@(2), nil) map:TL_divideBy(divisor)] asArray], onlyContains(@(0.4), nil));
}

- (void)testAdd {
    NSNumber *addition = @(5.0);
    assertThat([[sequence(@(35.0), nil) map:TL_add(addition)] asArray], onlyContains(@(40.0), nil));
    assertThat([[sequence(@(2), nil) map:TL_add(addition)] asArray], onlyContains(@(7.0), nil));
}

- (void)testSubtract {
    NSNumber *subtractor = @(5.0);
    assertThat([[sequence(@(35.0), nil) map:TL_subtract(subtractor)] asArray], onlyContains(@(30.0), nil));
    assertThat([[sequence(@(2), nil) map:TL_subtract(subtractor)] asArray], onlyContains(@(-3.0), nil));
}

@end