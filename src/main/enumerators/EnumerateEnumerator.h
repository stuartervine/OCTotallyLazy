#import <Foundation/Foundation.h>

@interface EnumerateEnumerator : NSEnumerator
@property(nonatomic) NSNumber *seed;

- (EnumerateEnumerator *)initWithCallable:(id (^)(NSNumber *))aCallableFunc seed:(NSNumber *)aSeed;

+ (EnumerateEnumerator *)withCallable:(id (^)(NSNumber *))callableFunc seed:(NSNumber *)aSeed;

@end