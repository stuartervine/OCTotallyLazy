#import <SenTestingKit/SenTestingKit.h>
#define TL_COERCIONS
#define TL_SHORTHAND
#define TL_LAMBDA
#define TL_LAMBDA_SHORTHAND
#import "OCTotallyLazy.h"
#import "OCTotallyLazyTestCase.h"

@interface PredicatesTest : OCTotallyLazyTestCase
@end

@implementation PredicatesTest

-(void)testAlternate {
    NSArray *aSequence = array(num(1), num(2), num(3), num(4), nil);
    assertThat([aSequence filter:TL_alternate(YES)], hasItems(num(1), num(3), nil));
    assertThat([aSequence filter:TL_alternate(NO)], hasItems(num(2), num(4), nil));
    assertThat([aSequence filter:alternate(YES)], hasItems(num(1), num(3), nil));
}

-(void)testContainedIn {
    NSArray *aSequence = array(num(1), num(2), num(3), nil);
    NSArray *existing = array(num(1), num(2), nil);
    assertThat([aSequence filter:TL_containedIn(existing)], hasItems(num(1), num(2), nil));
    assertThat([aSequence filter:not(in(existing))], hasItems(num(3), nil));
}

-(void)testCountTo {
    NSArray *aSequence = array(num(1), num(2), num(3), nil);
    assertThat([aSequence filter:TL_countTo(2)], hasItems(num(1), num(2), nil));
    assertThat([aSequence filter:countTo(1)], hasItems(num(1), nil));
}

-(void)testEqualTo {
    NSNumber *one = [NSNumber numberWithInt:1];
    NSArray *aSequence = array(@"bob", one, nil);
    assertThat([aSequence filter:TL_equalTo(@"bob")], hasItems(@"bob", nil));
    assertThat([aSequence filter:TL_equalTo(one)], hasItems(one, nil));
}

-(void)testEveryNth {
    NSArray *items = array(num(1), num(2), num(3), num(4), num(5), num(6), nil);
    assertThat([items filter:TL_everyNth(1)], hasItems(num(1), num(2), num(3), num(4), num(5), num(6), nil));
    assertThat([items filter:everyNth(2)], hasItems(num(2), num(4), num(6), nil));
}

-(void)testGreaterThan {
    NSArray *aSequence = array(num(1), num(2), num(3), nil);
    assertThat([aSequence filter:TL_greaterThan(num(1))], hasItems(num(2), num(3), nil));
    assertThat([aSequence filter:gtThan(num(2))], hasItems(num(3), nil));
}

-(void)testLessThan {
    NSArray *aSequence = array(num(1), num(2), num(3), nil);
    assertThat([aSequence filter:TL_lessThan(num(2))], hasItems(num(1), nil));
    assertThat([aSequence filter:ltThan(num(3))], hasItems(num(1), num(2), nil));
}

-(void)testWhileTrue {
    PREDICATE whileTrue = TL_whileTrue(TL_greaterThan(num(5)));
    assertThatBool(whileTrue(num(7)), equalToBool(TRUE));
    assertThatBool(whileTrue(num(6)), equalToBool(TRUE));
    assertThatBool(whileTrue(num(5)), equalToBool(FALSE));
    assertThatBool(whileTrue(num(6)), equalToBool(FALSE));
}
-(void)testLambdas {
    Sequence *items = sequence(@"bob", @"fred", nil);
    assertThat([items map:^(id s){return [s uppercaseString];}], hasItems(@"BOB", @"FRED", nil));
    assertThat([items map:lambda(s, [s uppercaseString])], hasItems(@"BOB", @"FRED", nil));
    assertThat([items map:_([_ uppercaseString])], hasItems(@"BOB", @"FRED", nil));
}
@end