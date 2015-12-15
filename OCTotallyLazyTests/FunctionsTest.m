#define TL_COERCIONS

#import "OCTotallyLazyTestCase.h"

@interface FunctionsTest : OCTotallyLazyTestCase
@end

@implementation FunctionsTest

- (void)testCanComposeFunctions {
    assertThat([[Functions compose:f1([Numbers add:@(10)]) and:f1([Numbers multiplyBy:@(3)])] apply:@(2)], is(@(36)));
}

- (void)testCanPartiallyApplyFunction2 {
    assertThat([[f2([Numbers add]) apply:@(1)] apply:@(2)], equalTo(@(3)));
}

@end