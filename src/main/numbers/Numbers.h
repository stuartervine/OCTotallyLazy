#import "Types.h"

static FUNCTION2 TL_sum() {
    return [^(NSNumber *a, NSNumber *b) {
        return [NSNumber numberWithDouble:a.doubleValue + b.doubleValue];
    } copy];
}

static FUNCTION2 TL_average() {
    __block int count = 1;
    return [^(NSNumber *previousAverage, NSNumber *number) {
        count++;
        return [NSNumber numberWithDouble:previousAverage.doubleValue + ((number.doubleValue - previousAverage.doubleValue)/count)];
    } copy];
}

static FUNCTION1 TL_multiplyBy(NSNumber *multiplier) {
    return [^(NSNumber *number) {
        return [NSNumber numberWithDouble:number.doubleValue * multiplier.doubleValue];
    } copy];
}

static FUNCTION1 TL_divideBy(NSNumber *divisor) {
    return [^(NSNumber *number) {
        return [NSNumber numberWithDouble:number.doubleValue / divisor.doubleValue];
    } copy];
}

static FUNCTION1 TL_add(NSNumber *addition) {
    return [^(NSNumber *number) {
        return [NSNumber numberWithDouble:number.doubleValue + addition.doubleValue];
    } copy];
}

static FUNCTION1 TL_subtract(NSNumber *subtractor) {
    return [^(NSNumber *number) {
        return [NSNumber numberWithDouble:number.doubleValue - subtractor.doubleValue];
    } copy];
}

#ifdef TL_SHORTHAND
    #define sum() TL_sum()
    #define average() TL_average()
    #define multiplyBy(multiplier) TL_multiplyBy(multiplier)
    #define divideBy(divisor) TL_divideBy(divisor)
    #define add(addition) TL_add(addition)
    #define subtract(subtractor) TL_subtract(subtractor)
#endif