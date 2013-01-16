#import <SenTestingKit/SenTestingKit.h>
#import "OCTotallyLazy.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface NSMutableDictionaryTest : SenTestCase
@end

@implementation NSMutableDictionaryTest

- (void)testFilterKeys {
    NSMutableDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    assertThat([dict filterKeys:TL_equalTo(@"key1")], equalTo([NSMutableDictionary dictionaryWithObject:@"value1" forKey:@"key1"]));
}

- (void)testFilterValues {
    NSMutableDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    assertThat([dict filterValues:TL_equalTo(@"value2")], equalTo([NSMutableDictionary dictionaryWithObject:@"value2" forKey:@"key2"]));
}

- (void)testForEach {
    __block NSString *description = @"";
    NSMutableDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    [dict foreach:^(id key, id value) { description = [[description stringByAppendingString:key] stringByAppendingString:value]; }];
    assertThat(description, equalTo(@"key2value2key1value1"));
}

-(void)testMap {
    NSMutableDictionary *actual = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    NSMutableDictionary *expected = dictionary(sequence(@"KEY1", @"KEY2", nil), sequence(@"VALUE1", @"VALUE2", nil));
    assertThat([actual map:^(id key, id value) {
        return array([key uppercaseString], [value uppercaseString], nil);
    }], equalTo(expected));
}

-(void)testMapValues {
    NSMutableDictionary *actual = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    NSMutableDictionary *expected = dictionary(sequence(@"key1", @"key2", nil), sequence(@"VALUE1", @"VALUE2", nil));
    assertThat([actual mapValues:[Callables toUpperCase]], equalTo(expected));
}

-(void)testOptionForKey {
    NSMutableDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    assertThat([dict optionForKey:@"key1"], equalTo([Some some:@"value1"]));
    assertThat([dict optionForKey:@"no-key"], equalTo([None none]));
}

@end