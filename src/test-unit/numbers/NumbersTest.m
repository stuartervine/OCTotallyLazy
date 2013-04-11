#define TL_COERCIONS
#define TL_SHORTHAND
#define TL_LAMBDA
#define TL_LAMBDA_SHORTHAND

#import <SenTestingKit/SenTestingKit.h>
#import "OCTotallyLazy.h"
#import "OCTotallyLazyTestCase.h"

@interface NumbersTest : OCTotallyLazyTestCase
@end

@implementation NumbersTest

- (void)testMax {
    assertThat([sequence(num(1), num(2), num(3), nil) reduce:TL_max()], equalTo(num(3)));
}

- (void)testMin {
    assertThat([sequence(num(1), num(2), num(3), nil) reduce:TL_min()], equalTo(num(1)));
}

- (void)testSum {
    assertThat([sequence(num(1), num(2), num(3), nil) reduce:TL_sum()], equalTo(num(6)));
    assertThat([sequence(num(1), num(2), num(3), nil) reduce:sum()], equalTo(num(6)));

    assertThat([sequence(numd(1.1), numd(2.2), numd(3.3), nil) reduce:sum()], equalTo(numd(6.6)));
}

- (void)testAverage {
    assertThat([sequence(num(1), num(2), num(3), nil) reduce:TL_average()], equalTo(num(2)));
    assertThat([sequence(num(1), num(2), num(3), nil) reduce:average()], equalTo(num(2)));
}

- (void)testMultiplyBy {
    NSNumber *const multiplier = num(10);
    assertThat([[sequence(num(1), nil) map:TL_multiplyBy(multiplier)] asArray], onlyContains(num(10), nil));
    assertThat([[sequence(num(2), nil) map:multiplyBy(multiplier)] asArray], onlyContains(num(20), nil));
    assertThat([[sequence(numd(2.5), nil) map:multiplyBy(multiplier)] asArray], onlyContains(numd(25.0), nil));
}

- (void)testDivideBy {
    NSNumber *divisor = numd(5.0);
    assertThat([[sequence(numd(35.0), nil) map:TL_divideBy(divisor)] asArray], onlyContains(numd(7.0), nil));
    assertThat([[sequence(num(2), nil) map:divideBy(divisor)] asArray], onlyContains(numd(0.4), nil));
}

- (void)testAdd {
    NSNumber *addition = numd(5.0);
    assertThat([[sequence(numd(35.0), nil) map:TL_add(addition)] asArray], onlyContains(numd(40.0), nil));
    assertThat([[sequence(num(2), nil) map:add(addition)] asArray], onlyContains(numd(7.0), nil));
}

- (void)testSubtract {
    NSNumber *subtractor = numd(5.0);
    assertThat([[sequence(numd(35.0), nil) map:TL_subtract(subtractor)] asArray], onlyContains(numd(30.0), nil));
    assertThat([[sequence(num(2), nil) map:subtract(subtractor)] asArray], onlyContains(numd(-3.0), nil));
}

@end