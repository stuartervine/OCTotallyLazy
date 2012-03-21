#import <Foundation/Foundation.h>

typedef id(^FUNCTION1)(id);
typedef id(^FUNCTION2)(id, id);

static FUNCTION2 TL_sum() {
    return [[^(NSNumber *a, NSNumber *b) {
        return [NSNumber numberWithDouble:a.doubleValue + b.doubleValue];
    } copy] autorelease];
}

static FUNCTION2 TL_average() {
    __block int count = 1;
    return [[^(NSNumber *previousAverage, NSNumber *number) {
        count++;
        return [NSNumber numberWithDouble:previousAverage.doubleValue + ((number.doubleValue - previousAverage.doubleValue)/count)];
    } copy] autorelease];
}

static FUNCTION1 TL_multiplyBy(NSNumber *multiplier) {
    return [[^(NSNumber *number) {
        return [NSNumber numberWithDouble:number.doubleValue * multiplier.doubleValue];
    } copy] autorelease];
}

#ifdef TL_SHORTHAND
    #define sum() TL_sum()
    #define average() TL_average()
    #define multiplyBy(multiplier) TL_multiplyBy(multiplier)
#endif