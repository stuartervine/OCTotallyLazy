#import <SenTestingKit/SenTestingKit.h>
#import "../main/OCTotallyLazy.h"

#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface FiltersTest : SenTestCase 
@end

@implementation FiltersTest

-(void)testIsEqual {
    NSNumber *one = [NSNumber numberWithInt:1];
    NSArray *aSequence = array(@"bob", one, nil);
    assertThat([aSequence filter:TL_equalTo(@"bob")], hasItems(@"bob", nil));
    assertThat([aSequence filter:TL_equalTo(one)], hasItems(one, nil));
}

-(void)testIsGreaterThan {
    NSNumber *one = [NSNumber numberWithInt:1];
    NSNumber *two = [NSNumber numberWithInt:2];
    NSNumber *three = [NSNumber numberWithInt:3];
    NSArray *aSequence = array(one, two, three, nil);
    assertThat([aSequence filter:TL_greaterThan(one)], hasItems(two, three, nil));
    assertThat([aSequence filter:TL_greaterThan(two)], hasItems(three, nil));
}

@end