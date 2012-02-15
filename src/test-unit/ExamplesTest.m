#import "OCTotallyLazyTestCase.h"
#import "../main/OCTotallyLazy.h"

@interface ExamplesTest : OCTotallyLazyTestCase
@end

@implementation ExamplesTest

-(void)testSomething {
    NSNumber *oneK = [[[lazySequence(num(2), nil) cycle] take:10] reduce:^(NSNumber *accumulator, NSNumber *item) {
        return num(accumulator.longValue * item.longValue);
    }];
    assertThat(oneK, equalTo(num(1024)));
}

@end