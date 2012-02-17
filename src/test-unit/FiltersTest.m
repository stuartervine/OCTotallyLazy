#import <SenTestingKit/SenTestingKit.h>
#import "../main/OCTotallyLazy.h"

#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface FiltersTest : SenTestCase 
@end

@implementation FiltersTest

-(void)testIsEqual {
    NSNumber *one = [NSNumber numberWithInt:1];
    Sequence *aSequence = sequence(@"bob", one, nil);
    assertThat([aSequence filter:TL_equalTo(@"bob")], equalTo(sequence(@"bob", nil)));
    assertThat([aSequence filter:TL_equalTo(one)], equalTo(sequence(one, nil)));
}

-(void)testIsGreaterThan {
    NSNumber *one = [NSNumber numberWithInt:1];
    NSNumber *two = [NSNumber numberWithInt:2];
    NSNumber *three = [NSNumber numberWithInt:3];
    Sequence *aSequence = sequence(one, two, three, nil);
    assertThat([aSequence filter:TL_greaterThan(one)], equalTo(sequence(two, three, nil)));
    assertThat([aSequence filter:TL_greaterThan(two)], equalTo(sequence(three, nil)));
}

@end