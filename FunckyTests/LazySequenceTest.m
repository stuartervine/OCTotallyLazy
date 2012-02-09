#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import "LazySequence.h"

@interface LazySequenceTest : SenTestCase
@end

@implementation LazySequenceTest

static NSNumber *number(int i) {
    return [NSNumber numberWithInt:i];
}

-(void)testMap {
    LazySequence *lazy = lazySequence(number(1), number(2), number(3), nil);
    LazySequence *doubled = [lazy map:^(NSNumber *item){return number([item intValue]*2);}];
    assertThat([doubled asSequence], hasItems(number(2), number(4), number(6), nil));
}

@end