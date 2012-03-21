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
}

@end