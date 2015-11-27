#import "OCTotallyLazy.h"
#import "OCTotallyLazyTestCase.h"

@interface NSDictionaryTest : OCTotallyLazyTestCase
@end

@implementation NSDictionaryTest

- (void)testFilterKeys {
    NSDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    assertThat([dict filterKeys:TL_equalTo(@"key1")], equalTo([NSDictionary dictionaryWithObject:@"value1" forKey:@"key1"]));
}

- (void)testFilterValues {
    NSDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    assertThat([dict filterValues:TL_equalTo(@"value2")], equalTo([NSDictionary dictionaryWithObject:@"value2" forKey:@"key2"]));
}

- (void)testForEach {
    __block NSString *description = @"";
    NSDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    [dict foreach:^(id key, id value) { description = [[description stringByAppendingString:key] stringByAppendingString:value]; }];
    assertThat(description, equalTo(@"key1value1key2value2"));
}

-(void)testMap {
    NSDictionary *actual = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    NSDictionary *expected = dictionary(sequence(@"KEY1", @"KEY2", nil), sequence(@"VALUE1", @"VALUE2", nil));
    assertThat([actual map:^(id key, id value) {
        return array([key uppercaseString], [value uppercaseString], nil);
    }], equalTo(expected));
}

-(void)testMapValues {
    NSDictionary *actual = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    NSDictionary *expected = dictionary(sequence(@"key1", @"key2", nil), sequence(@"VALUE1", @"VALUE2", nil));
    assertThat([actual mapValues:[Callables toUpperCase]], equalTo(expected));
}

-(void)testOptionForKey {
    NSDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    assertThat([dict optionForKey:@"key1"], equalTo([Some some:@"value1"]));
    assertThat([dict optionForKey:@"no-key"], equalTo([None none]));
}

@end