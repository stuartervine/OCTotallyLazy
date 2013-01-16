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
    NSMutableArray *items = array(num(1), num(2), num(3), num(4), nil);
    assertThat([items filter:TL_alternate(YES)], hasItems(num(1), num(3), nil));
    assertThat([items filter:TL_alternate(NO)], hasItems(num(2), num(4), nil));
    assertThat([items filter:alternate(YES)], hasItems(num(1), num(3), nil));
}

-(void)testAnd {
    NSMutableArray *items = array(num(1), num(2), num(3), num(4), nil);
    assertThat([items filter:and(gtThan(num(1)), ltThan(num(4)))], hasItems(num(2), num(3), nil));
}

-(void)testOr {
    NSMutableArray *items = array(num(1), num(2), num(3), num(4), nil);
    assertThat([items filter:or(eqTo(num(1)), eqTo(num(4)))], hasItems(num(1), num(4), nil));
}

-(void)testContainedIn {
    NSMutableArray *items = array(num(1), num(2), num(3), nil);
    NSMutableArray *existing = array(num(1), num(2), nil);
    assertThat([items filter:TL_containedIn(existing)], hasItems(num(1), num(2), nil));
    assertThat([items filter:not(in(existing))], hasItems(num(3), nil));
}

-(void)testContainsString {
    NSMutableArray *items = array(@"one", @"two", @"three", nil);
    assertThat([items filter:TL_containsString(@"o")], hasItems(@"one", @"two", nil));
    assertThat([items filter:containsStr(@"o")], hasItems(@"one", @"two", nil));
}

-(void)testCountTo {
    NSMutableArray *items = array(num(1), num(2), num(3), nil);
    assertThat([items filter:TL_countTo(2)], hasItems(num(1), num(2), nil));
    assertThat([items filter:countTo(1)], hasItems(num(1), nil));
}

-(void)testEqualTo {
    NSNumber *one = [NSNumber numberWithInt:1];
    NSMutableArray *items = array(@"bob", one, nil);
    assertThat([items filter:TL_equalTo(@"bob")], hasItems(@"bob", nil));
    assertThat([items filter:TL_equalTo(one)], hasItems(one, nil));
}

-(void)testEveryNth {
    NSMutableArray *items = array(num(1), num(2), num(3), num(4), num(5), num(6), nil);
    assertThat([items filter:TL_everyNth(1)], hasItems(num(1), num(2), num(3), num(4), num(5), num(6), nil));
    assertThat([items filter:everyNth(2)], hasItems(num(2), num(4), num(6), nil));
}

-(void)testGreaterThan {
    NSMutableArray *items = array(num(1), num(2), num(3), nil);
    assertThat([items filter:TL_greaterThan(num(1))], hasItems(num(2), num(3), nil));
    assertThat([items filter:gtThan(num(2))], hasItems(num(3), nil));
}

-(void)testLessThan {
    NSMutableArray *items = array(num(1), num(2), num(3), nil);
    assertThat([items filter:TL_lessThan(num(2))], hasItems(num(1), nil));
    assertThat([items filter:ltThan(num(3))], hasItems(num(1), num(2), nil));
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