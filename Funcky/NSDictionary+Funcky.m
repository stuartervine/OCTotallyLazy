#import "NSArray+Funcky.h"
#import "NSDictionary+Funcky.h"

@implementation NSDictionary (Functional)

- (NSMutableDictionary * (^)(NSMutableDictionary *, id))addObjectForKey {
    return [[^(NSMutableDictionary *dict, id key) {
                [dict setObject:[self objectForKey:key] forKey:key];
                return dict;
            } copy] autorelease];
}

- (NSDictionary *)filterKeys:(BOOL (^)(id))filterBlock {
    return [[[self allKeys] filter:filterBlock] fold:[NSMutableDictionary dictionary] with:[self addObjectForKey]];
}

- (NSDictionary *)filterValues:(BOOL (^)(id))filterBlock {
    return [[[self allValues] filter:filterBlock] fold:[NSMutableDictionary dictionary] with:^(NSMutableDictionary *dict, id value) {
        [[self allKeysForObject:value] fold:dict with:[self addObjectForKey]];
        return dict;
    }];
}

- (Option *)optionForKey:(id)key {
    return option([self objectForKey:key]);
}

@end