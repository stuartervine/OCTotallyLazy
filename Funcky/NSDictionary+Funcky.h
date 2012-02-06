#import <Foundation/Foundation.h>
#import "Sequence.h"

@interface NSDictionary (Functional)
-(NSDictionary *)filterKeys:(BOOL (^)(id))functorBlock;
-(NSDictionary *)filterValues:(BOOL (^)(id))functorBlock;
- (id)mapValues:(id (^)(id))funcBlock;

-(Option *)optionForKey:(id)key;
@end

static NSDictionary *dictionary(Sequence* keys, Sequence* values) {
    return [NSDictionary dictionaryWithObjects:[values asArray] forKeys:[keys asArray]];
}
