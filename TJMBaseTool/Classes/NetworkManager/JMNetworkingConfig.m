//
//  JMNetworkingConfig.m
//  AFNetworking
//
//  Created by Jiaming Tu on 2019/3/13.
//

#import "JMNetworkingConfig.h"

@interface JMAFQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (instancetype)initWithField:(id)field value:(id)value;

- (NSString *)jm_URLEncodedStringValue;
@end

@implementation JMAFQueryStringPair

- (instancetype)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)jm_URLEncodedStringValue {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return JM_AFPercentEscapedStringFromString([self.field description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", JM_AFPercentEscapedStringFromString([self.field description]), JM_AFPercentEscapedStringFromString([self.value description])];
    }
}

NSString * JM_AFPercentEscapedStringFromString(NSString *string) {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
        NSUInteger length = MIN(string.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    return escaped;
}

@end

@implementation JMNetworkingConfig

static JMNetworkingConfig *config = nil;
+ (JMNetworkingConfig *)shareConfig {
    if (config == nil) {
        config = [[JMNetworkingConfig alloc] init];
    }
    return config;
}

#pragma  mark - get default value
- (NSString *)acceptHeaderFiledValue {
    if (!_acceptHeaderFiledValue) {
        _acceptHeaderFiledValue = @"application/json";
    }
    return _acceptHeaderFiledValue;
}
- (NSString *)contentTypeHeaderFiledValue {
    if (!_contentTypeHeaderFiledValue) {
        _contentTypeHeaderFiledValue = @"application/json";
    }
    return _contentTypeHeaderFiledValue;
}
- (NSTimeInterval)timeoutInterval {
    if (_timeoutInterval <= 0) {
        _timeoutInterval = 10.0;
    }
    return _timeoutInterval;
}
- (NSSet *)httpManagerParamsInUrlSet {
    if (!_httpManagerParamsInUrlSet) {
        _httpManagerParamsInUrlSet = [NSSet setWithArray:@[@"PUT", @"GET", @"DELETE", @"POST"]];
    }
    return _httpManagerParamsInUrlSet;
}

#pragma  mark - url query
static BOOL isNeedBracket = NO;
- (void)setArrayInQueryIsNeedBracket:(BOOL)arrayInQueryIsNeedBracket {
    _arrayInQueryIsNeedBracket = arrayInQueryIsNeedBracket;
    isNeedBracket = arrayInQueryIsNeedBracket;
}

NSString * JM_AFQueryStringFromParameters(NSDictionary *parameters) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (JMAFQueryStringPair *pair in JM_AFQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair jm_URLEncodedStringValue]];
    }
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * JM_AFQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return JM_AFQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * JM_AFQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:JM_AFQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            if (isNeedBracket) {
                [mutableQueryStringComponents addObjectsFromArray:JM_AFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
            } else {
                [mutableQueryStringComponents addObjectsFromArray:JM_AFQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@", key], nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:JM_AFQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[JMAFQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}


@end
