#import "OCTotallyLazyTestCase.h"

@interface FunctionsTest : OCTotallyLazyTestCase
@end

@implementation FunctionsTest

- (void)testCanComposeFunctions {
    assertThat([[Functions compose:f1([Numbers add:num(10)]) and:f1([Numbers multiplyBy:num(3)])] apply:num(2)], is(num(36)));
    
}

- (void)testCanPartiallyApplyFunction2 {
    assertThat([[f2([Numbers add]) apply:num(1)] apply:num(2)], equalTo(num(3)));
}

@end