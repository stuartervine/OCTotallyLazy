#import <Foundation/Foundation.h>


@interface Enumerators : NSObject

+(NSEnumerator *) map:(NSEnumerator *)enumerator with:(id (^)(id))func;

@end