#define TL_SHORTHAND
#define TL_LAMBDA
#define TL_LAMBDA_SHORTHAND
#define TL_COERCIONS

#import "OCTotallyLazyTestCase.h"

@interface PredicatesTest : OCTotallyLazyTestCase
@end

@implementation PredicatesTest

-(void)testAlternate {
    NSArray *items = array(@(1), @(2), @(3), @(4), nil);
    assertThat([items filter:TL_alternate(YES)], contains(@(1), @(3), nil));
    assertThat([items filter:TL_alternate(NO)], contains(@(2), @(4), nil));
}

-(void)testAnd {
    NSArray *items = array(@(1), @(2), @(3), @(4), nil);
    assertThat([items filter:TL_and(TL_greaterThan(@(1)), TL_lessThan(@(4)))], contains(@(2), @(3), nil));
}

-(void)testOr {
    NSArray *items = array(@(1), @(2), @(3), @(4), nil);
    assertThat([items filter:TL_or(TL_equalTo(@(1)), TL_equalTo(@(4)))], contains(@(1), @(4), nil));
}

-(void)testContainedIn {
    NSArray *items = array(@(1), @(2), @(3), nil);
    NSArray *existing = array(@(1), @(2), nil);
    assertThat([items filter:TL_containedIn(existing)], contains(@(1), @(2), nil));
    assertThat([items filter:TL_not(TL_containedIn(existing))], contains(@(3), nil));
}

-(void)testContainsString {
    NSArray *items = array(@"one", @"two", @"three", nil);
    assertThat([items filter:TL_containsString(@"o")], contains(@"one", @"two", nil));
}

-(void)testCountTo {
    NSArray *items = array(@1, @2, @3, nil);
    assertThat([items filter:TL_countTo(2)], contains(@1, @2, nil));
    assertThat([items filter:TL_countTo(1)], contains(@1, nil));
}

-(void)testEqualTo {
    NSNumber *one = [NSNumber numberWithInt:1];
    NSArray *items = array(@"bob", one, nil);
    assertThat([items filter:TL_equalTo(@"bob")], contains(@"bob", nil));
    assertThat([items filter:TL_equalTo(one)], contains(one, nil));
}

-(void)testEveryNth {
    NSArray *items = array(@(1), @(2), @(3), @(4), @(5), @(6), nil);
    assertThat([items filter:TL_everyNth(1)], contains(@(1), @(2), @(3), @(4), @(5), @(6), nil));
    assertThat([items filter:TL_everyNth(2)], contains(@(2), @(4), @(6), nil));
}

-(void)testGreaterThan {
    NSArray *items = array(@(1), @(2), @(3), nil);
    assertThat([items filter:TL_greaterThan(@(1))], contains(@(2), @(3), nil));
    assertThat([items filter:TL_greaterThan(@(2))], contains(@(3), nil));
}

-(void)testLessThan {
    NSArray *items = array(@(1), @(2), @(3), nil);
    assertThat([items filter:TL_lessThan(@(2))], contains(@(1), nil));
    assertThat([items filter:TL_lessThan(@(3))], contains(@(1), @(2), nil));
}

-(void)testWhileTrue {
    PREDICATE whileTrue = TL_whileTrue(TL_greaterThan(@(5)));
    assertThatBool(whileTrue(@(7)), isTrue());
    assertThatBool(whileTrue(@(6)), isTrue());
    assertThatBool(whileTrue(@(5)), isFalse());
    assertThatBool(whileTrue(@(6)), isFalse());
}

-(void)testLambdas {
    Sequence *items = sequence(@"bob", @"fred", nil);
    assertThat([items map:^(id s){return [s uppercaseString];}], contains(@"BOB", @"FRED", nil));
}
@end