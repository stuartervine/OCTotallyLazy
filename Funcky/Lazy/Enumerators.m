#import "Enumerators.h"
#import "MapEnumerator.h"


@implementation Enumerators {

}
+ (NSEnumerator *)map:(NSEnumerator *)enumerator with:(id (^)(id))func {
    return [MapEnumerator withEnumerator:enumerator andFunction:func];

}


@end