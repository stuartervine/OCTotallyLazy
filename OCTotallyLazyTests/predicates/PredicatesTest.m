#import "OCTotallyLazyTestCase.h"

@interface PredicatesTest : OCTotallyLazyTestCase
@end

@implementation PredicatesTest

-(void)testAlternate {
    NSArray *items = array(num(1), num(2), num(3), num(4), nil);
    assertThat([items filter:TL_alternate(YES)], contains(num(1), num(3), nil));
    assertThat([items filter:TL_alternate(NO)], contains(num(2), num(4), nil));
    assertThat([items filter:alternate(YES)], contains(num(1), num(3), nil));
}

-(void)testAnd {
    NSArray *items = array(num(1), num(2), num(3), num(4), nil);
    assertThat([items filter:and(gtThan(num(1)), ltThan(num(4)))], contains(num(2), num(3), nil));
}

-(void)testOr {
    NSArray *items = array(num(1), num(2), num(3), num(4), nil);
    assertThat([items filter:or(eqTo(num(1)), eqTo(num(4)))], contains(num(1), num(4), nil));
}

-(void)testContainedIn {
    NSArray *items = array(num(1), num(2), num(3), nil);
    NSArray *existing = array(num(1), num(2), nil);
    assertThat([items filter:TL_containedIn(existing)], contains(num(1), num(2), nil));
    assertThat([items filter:not(in(existing))], contains(num(3), nil));
}

-(void)testContainsString {
    NSArray *items = array(@"one", @"two", @"three", nil);
    assertThat([items filter:TL_containsString(@"o")], contains(@"one", @"two", nil));
    assertThat([items filter:containsStr(@"o")], contains(@"one", @"two", nil));
}

-(void)testCountTo {
    NSArray *items = array(num(1), num(2), num(3), nil);
    assertThat([items filter:TL_countTo(2)], contains(num(1), num(2), nil));
    assertThat([items filter:countTo(1)], contains(num(1), nil));
}

-(void)testEqualTo {
    NSNumber *one = [NSNumber numberWithInt:1];
    NSArray *items = array(@"bob", one, nil);
    assertThat([items filter:TL_equalTo(@"bob")], contains(@"bob", nil));
    assertThat([items filter:TL_equalTo(one)], contains(one, nil));
}

-(void)testEveryNth {
    NSArray *items = array(num(1), num(2), num(3), num(4), num(5), num(6), nil);
    assertThat([items filter:TL_everyNth(1)], contains(num(1), num(2), num(3), num(4), num(5), num(6), nil));
    assertThat([items filter:evryNth(2)], contains(num(2), num(4), num(6), nil));
}

-(void)testGreaterThan {
    NSArray *items = array(num(1), num(2), num(3), nil);
    assertThat([items filter:TL_greaterThan(num(1))], contains(num(2), num(3), nil));
    assertThat([items filter:gtThan(num(2))], contains(num(3), nil));
}

-(void)testLessThan {
    NSArray *items = array(num(1), num(2), num(3), nil);
    assertThat([items filter:TL_lessThan(num(2))], contains(num(1), nil));
    assertThat([items filter:ltThan(num(3))], contains(num(1), num(2), nil));
}

-(void)testWhileTrue {
    PREDICATE whileTrue = TL_whileTrue(TL_greaterThan(num(5)));
    assertThatBool(whileTrue(num(7)), isTrue());
    assertThatBool(whileTrue(num(6)), isTrue());
    assertThatBool(whileTrue(num(5)), isFalse());
    assertThatBool(whileTrue(num(6)), isFalse());
}

-(void)testLambdas {
    Sequence *items = sequence(@"bob", @"fred", nil);
    assertThat([items map:^(id s){return [s uppercaseString];}], contains(@"BOB", @"FRED", nil));
    assertThat([items map:lambda(s, [s uppercaseString])], contains(@"BOB", @"FRED", nil));
    assertThat([items map:_([_ uppercaseString])], contains(@"BOB", @"FRED", nil));
}
@end