#import <Foundation/Foundation.h>
#import "Sequence.h"

@interface Group : Sequence
@property(nonatomic, retain) id <NSObject> key;

- (Group *)initWithKey:(id)aKey enumerable:(id <Enumerable>)anEnumerable;

+ (Group *)group:(id)key enumerable:(id <Enumerable>)enumerable;

@end