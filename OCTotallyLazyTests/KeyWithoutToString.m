#import "KeyWithoutToString.h"


@interface KeyWithoutToString ()
@property(nonatomic, strong) id value;
@end

@implementation KeyWithoutToString

- (KeyWithoutToString *)initWithValue:(id)value {
    self = [super init];
    if(self) {
        self.value = value;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[KeyWithoutToString class]] || object == nil) {
        return FALSE;
    }
    KeyWithoutToString *otherObject = object;
    return [otherObject.value isEqual: self.value];
}

- (NSUInteger)hash {
    return [self.value hash];
}


- (id)copyWithZone:(NSZone *)zone {
    return [[KeyWithoutToString allocWithZone:zone] initWithValue:self.value];
}

@end