#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface FunckyTestCase : SenTestCase
@end

static NSNumber *num(int i) {
    return [NSNumber numberWithInt:i];
}