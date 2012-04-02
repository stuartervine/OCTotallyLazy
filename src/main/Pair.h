#import <Foundation/Foundation.h>
#import "Sequence.h"

@interface Pair : NSObject

@property(nonatomic, retain, readonly) id left;
@property(nonatomic, retain, readonly) id right;

- (Pair *)initWithLeft:(id)aKey right:(id)aValue;
- (Sequence *)toSequence;
+ (Pair *)left:(id)aLeft right:(id)aRight;

@end