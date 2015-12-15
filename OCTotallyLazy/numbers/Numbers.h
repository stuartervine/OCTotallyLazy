#import "Types.h"

@interface Numbers : NSObject
+ (FUNCTION2)min;

+ (FUNCTION2)max;

+ (FUNCTION2)sum;

+ (FUNCTION2)average;

+ (FUNCTION2)multiplyBy;

+ (FUNCTION1)multiplyBy:(NSNumber *)number;

+ (FUNCTION2)divideBy;

+ (FUNCTION1)divideBy:(NSNumber *)divisor;

+ (FUNCTION2)add;

+ (FUNCTION1)add:(NSNumber *)addition;

+ (FUNCTION2)subtract;

+ (FUNCTION1)substract:(NSNumber *)subtractor;
@end

static FUNCTION2 TL_max() {
    return [Numbers max];
}

static FUNCTION2 TL_min() {
    return [Numbers min];
}

static FUNCTION2 TL_sum() {
    return [Numbers sum];
}

static FUNCTION2 TL_average() {
    return [Numbers average];
}

static FUNCTION1 TL_multiplyBy(NSNumber *multiplier) {
    return [Numbers multiplyBy:multiplier];
}

static FUNCTION1 TL_divideBy(NSNumber *divisor) {
    return [Numbers divideBy:divisor];
}

static FUNCTION1 TL_add(NSNumber *addition) {
    return [Numbers add:addition];
}

static FUNCTION1 TL_subtract(NSNumber *subtractor) {
    return [Numbers substract:subtractor];
}