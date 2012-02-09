#import <SenTestingKit/SenTestingKit.h>
#import "Funcky.h"
#import "Callables.h"

#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface NSDictionaryTest : SenTestCase
@end

@implementation NSDictionaryTest

- (void)testFilterKeys {
    NSDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    assertThat([dict filterKeys:FY_equalTo(@"key1")], equalTo([NSDictionary dictionaryWithObject:@"value1" forKey:@"key1"]));
}

- (void)testFilterValues {
    NSDictionary *dict = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    assertThat([dict filterValues:FY_equalTo(@"value2")], equalTo([NSDictionary dictionaryWithObject:@"value2" forKey:@"key2"]));
}

-(void)testMap {
    NSDictionary *actual = dictionary(sequence(@"key1", @"key2", nil), sequence(@"value1", @"value2", nil));
    NSDictionary *expected = dictionary(sequence(@"KEY1", @"KEY2", nil), sequence(@"VALUE1", @"VALUE2", nil));
    assertThat([actual map:^(id key, id value) {
        return sequence([key uppercaseString], [value uppercaseString], nil);
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