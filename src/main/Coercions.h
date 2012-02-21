#import <Foundation/Foundation.h>
#ifdef TL_COERCIONS
static NSNumber *num(int value) {
    return [NSNumber numberWithInt:value];
}
static NSNumber *numl(long value) {
    return [NSNumber numberWithLong:value];
}
static NSNumber *numf(float value) {
    return [NSNumber numberWithFloat:value];
}
static NSNumber *numd(double value) {
    return [NSNumber numberWithDouble:value];
}
#endif