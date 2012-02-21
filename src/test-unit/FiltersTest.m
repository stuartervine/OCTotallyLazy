#import <SenTestingKit/SenTestingKit.h>
#define TL_COERCIONS
#define TL_SHORTHAND
#define TL_LAMBDA
#define TL_LAMBDA_SHORTHAND
#import "OCTotallyLazy.h"
#import "OCTotallyLazyTestCase.h"

@interface FiltersTest : OCTotallyLazyTestCase
@end

@implementation FiltersTest

-(void)testIsEqual {
    NSNumber *one = [NSNumber numberWithInt:1];
    NSArray *aSequence = array(@"bob", one, nil);
    assertThat([aSequence filter:TL_equalTo(@"bob")], hasItems(@"bob", nil));
    assertThat([aSequence filter:TL_equalTo(one)], hasItems(one, nil));
}

-(void)testIsGreaterThan {
    NSArray *aSequence = array(num(1), num(2), num(3), nil);
    assertThat([aSequence filter:TL_greaterThan(num(1))], hasItems(num(2), num(3), nil));
    assertThat([aSequence filter:gtThan(num(2))], hasItems(num(3), nil));
}

-(void)testLessThan {
    NSArray *aSequence = array(num(1), num(2), num(3), nil);
    assertThat([aSequence filter:TL_lessThan(num(2))], hasItems(num(1), nil));
    assertThat([aSequence filter:ltThan(num(3))], hasItems(num(1), num(2), nil));
}

-(void)testLambdas {
    Sequence *items = sequence(@"bob", @"fred", nil);
    assertThat([items map:^(id s){return [s uppercaseString];}], hasItems(@"BOB", @"FRED", nil));

    assertThat([items map:lambda(s, [s uppercaseString])], hasItems(@"BOB", @"FRED", nil));
    assertThat([items map:_([_ uppercaseString])], hasItems(@"BOB", @"FRED", nil));
}
@end