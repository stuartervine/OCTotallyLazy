#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface OCTotallyLazyTestCase : SenTestCase
@end

static NSNumber *num(long i) {
    return [NSNumber numberWithLong:i];
}