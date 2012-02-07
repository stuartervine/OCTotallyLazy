#import <Foundation/Foundation.h>

static id FY_equalTo(id comparable) {
    return [[^(id item) { return (BOOL)[item isEqual:comparable]; } copy] autorelease];
}
static id FY_greaterThan(NSNumber *comparable) {
    return [[^(NSNumber *item) { return item.doubleValue > comparable.doubleValue;} copy] autorelease];
}
