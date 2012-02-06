#import "Option.h"
#import "Some.h"
#import "None.h"

@implementation Option

- (Sequence *)asSequence {
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

+ (id)option:(id)value {
    return (value == nil) ? [None none] : [Some some:value];
}

- (id)get {
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (id)map:(id (^)(id))funcBlock {
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}

- (id)fold:(id)value with:(id (^)(id, id))functorBlock {
    [NSException raise:@"Unsupported" format:@"Unsupported"];
    return nil;
}


@end