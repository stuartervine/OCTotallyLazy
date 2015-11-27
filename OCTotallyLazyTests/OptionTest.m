#import "OCTotallyLazy.h"
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface OptionTest : XCTestCase
@end

@implementation OptionTest

-(void)testEquality {
    assertThat([Some some:@"bob"], equalTo([Some some:@"bob"]));
    assertThat([None none], equalTo([None none]));
    assertThat([Some some:@"bob"], isNot(equalTo([None none])));
}

- (void)testEqualityLiftsValue {
    assertThat([Some some:@"bob"], equalTo(@"bob"));
    assertThat([Some some:@"bob"], isNot(equalTo(nil)));
}

-(void)testCannotGetValueOfNone {
    @try {
        [[None none] get];
        XCTFail(@"Should throw.");
    }
    @catch (NoSuchElementException *e) {
        //good
    }
}

-(void)testCanGetValueOfSome {
    assertThat([[Some some:@"fred"] get], equalTo(@"fred"));
}

-(void)testGetOrElse {
    assertThat([[Some some:@"fred"] getOrElse:@"bob"], equalTo(@"fred"));
    assertThat([[None none] getOrElse:@"bob"], equalTo(@"bob"));
}

-(void)testGetOrInvoke {
    assertThat([[None none] getOrInvoke:^{return @"bob";}], equalTo(@"bob"));
}

-(void)testFlatten {
    assertThat([[Option option:[Some some:@"one"]] flatten], equalTo([Some some:@"one"]));
    assertThat([[Option option:[None none]] flatten], equalTo([None none]));
}

-(void)testFlatMap {
    assertThat([[Option option:[Some some:@"one"]] flatMap:[Callables toUpperCase]], equalTo([Some some:@"ONE"]));
    assertThat([[Option option:[None none]] flatMap:[Callables toUpperCase]], equalTo([None none]));
}

-(void)testCanMap {
    assertThat([[Option option:@"bob"] map:[Callables toUpperCase]], equalTo([Some some:@"BOB"]));
    assertThat([[Option option:nil] map:[Callables toUpperCase]], equalTo([None none]));
}

-(void)testCanFold {
    assertThat([[Option option:@"bob"] fold:@"fred" with:[Callables appendString]], equalTo([Some some:@"fredbob"]));
    assertThat([[None none] fold:@"fred" with:[Callables appendString]], equalTo([Some some:@"fred"]));
}

-(void)testConversionToSequence {
    assertThat([[[None none] asSequence] asArray], isEmpty());
    assertThat([[Some some:@"bob"] asSequence], contains(@"bob", nil));
}

- (void)testMaybe {
    __block BOOL someInvokes = NO;
    __block BOOL noneInvokes = NO;
    [[None none] maybe:^(id value){
        noneInvokes = YES;
    }];
    [[Some some:@"bob"] maybe:^(id value){
        someInvokes = YES;
    }];
    assertThatBool(noneInvokes, isFalse());
    assertThatBool(someInvokes, isTrue());
}

@end