#import <Foundation/Foundation.h>

@interface EnumerateEnumerator : NSEnumerator
@property(nonatomic, retain) NSNumber *seed;

- (EnumerateEnumerator *)initWithCallable:(id (^)(NSNumber *))aCallableFunc seed:(NSNumber *)aSeed;

+ (EnumerateEnumerator *)withCallable:(id (^)(NSNumber *))callableFunc seed:(NSNumber *)aSeed;

@end