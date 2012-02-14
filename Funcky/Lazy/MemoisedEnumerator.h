#import <Foundation/Foundation.h>


@interface MemoisedEnumerator : NSEnumerator
-(int)previousIndex;
-(int)nextIndex;

-(id)previousObject;

- (MemoisedEnumerator *)initWith:(NSEnumerator *)anEnumerator;

- (id)firstObject;

+ (MemoisedEnumerator *)with:(NSEnumerator *)enumerator;
@end