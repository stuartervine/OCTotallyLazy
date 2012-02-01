#import <SenTestingKit/SenTestingKit.h>
#import "NSDictionary+Funcky.h"

#define HC_SHORTHAND

#import <OCHamcrestIOS/OCHamcrestIOS.h>

@interface NSDictionaryTest : SenTestCase
@end

@implementation NSDictionaryTest

- (void)testFilterKeys {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"value1", @"value2", nil]
                                                           forKeys:[NSArray arrayWithObjects:@"key1", @"key2", nil]];
    assertThat([dictionary filterKeys:^(NSString *item) { return [item isEqualToString:@"key1"]; }],
        equalTo([NSDictionary dictionaryWithObject:@"value1" forKey:@"key1"]));
}

- (void)testFilterValues {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"value1", @"value2", nil]
                                                           forKeys:[NSArray arrayWithObjects:@"key1", @"key2", nil]];
    assertThat([dictionary filterValues:^(NSString *item) { return [item isEqualToString:@"value2"]; }],
        equalTo([NSDictionary dictionaryWithObject:@"value2" forKey:@"key2"]));
}

@end