#import <Foundation/Foundation.h>
#import "OCTotallyLazy.h"

@interface NSDictionary (Functional)
-(NSMutableDictionary *)filterKeys:(BOOL (^)(id))functorBlock;
-(NSMutableDictionary *)filterValues:(BOOL (^)(id))functorBlock;
- (void)foreach:(void (^)(id, id))funcBlock;
- (id)map:(NSMutableArray * (^)(id, id))funcBlock;
- (id)mapValues:(id (^)(id))funcBlock;
-(Option *)optionForKey:(id)key;
@end

static NSMutableDictionary *dictionary(Sequence * keys, Sequence * values) {
    return [NSMutableDictionary dictionaryWithObjects:[values asArray] forKeys:[keys asArray]];
}
