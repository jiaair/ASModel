//
//  ASProperty.m
//  wiki
//
//  Created by JIA on 2017/8/29.
//  Copyright © 2017年 JIA. All rights reserved.
//

#import "ASProperty.h"

@implementation ASProperty

+ (instancetype)propertyWithProperty:(objc_property_t)property {
    
    return [[ASProperty alloc] initWithProperty:property];
}

- (instancetype)initWithProperty:(objc_property_t)property {
    if (self = [super init]) {
        _name = @(property_getName(property));
        _type = [ASPropertyType propertyTypeWithAttributeString:@(property_getAttributes(property))];
    }
    
    return self;
}

@end

NSString *const ASPropertyTypeInt = @"i";
NSString *const ASPropertyTypeShort = @"s";
NSString *const ASPropertyTypeFloat = @"f";
NSString *const ASPropertyTypeDouble = @"d";
NSString *const ASPropertyTypeLong = @"q";
NSString *const ASPropertyTypeChar = @"c";
NSString *const ASPropertyTypeBOOL1 = @"c";
NSString *const ASPropertyTypeBOOL2 = @"b";
NSString *const ASPropertyTypePoint = @"*";
NSString *const ASPropertyTypeIvar = @"^{objc_ival=}";
NSString *const ASPropertyTypeMethod = @"^{objc_method=}";
NSString *const ASPropertyTypeBlock = @"@?";
NSString *const ASPropertyTypeClass = @"#";
NSString *const ASPropertyTypeSEL = @":";
NSString *const ASPropertyTypeId = @"@";

static NSMutableDictionary *cachedTypeDict;

@implementation ASPropertyType

+ (void)load {
    cachedTypeDict = [NSMutableDictionary dictionary];
}

+ (instancetype)propertyTypeWithAttributeString:(NSString *)string {
    return [[ASPropertyType alloc] initWithTypeString:string];
}

- (instancetype)initWithTypeString:(NSString *)string {
    NSUInteger loc = 1;
    NSUInteger len = [string rangeOfString:@","].location - loc;
    NSString *typeCode = [string substringWithRange:NSMakeRange(loc, len)];
    
    if (!cachedTypeDict[typeCode]) {
        self = [super init];
        [self getTypeCode:typeCode];
        cachedTypeDict[typeCode] = self;
    }
    
    return self;
}

- (void)getTypeCode:(NSString *)code {
    if ([code isEqualToString:ASPropertyTypeId]) {
        _idType = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        // 判断类型
        _classType = NSClassFromString(_code);
        _numberType = (_classType == [NSNumber class] || [_classType isSubclassOfClass:[NSNumber class]]);
        _fromFoundation = [NSObject isSubclassOfClass:_classType];
        
        NSString *lowerCode = _code.lowercaseString;
        NSArray *numberTypes = @[ASPropertyTypeInt, ASPropertyTypeShort, ASPropertyTypeBOOL1, ASPropertyTypeBOOL2, ASPropertyTypeFloat, ASPropertyTypeDouble, ASPropertyTypeLong, ASPropertyTypeChar];
        if ([numberTypes containsObject:lowerCode]) {
            _numberType = YES;
            
            if ([lowerCode isEqualToString:ASPropertyTypeBOOL1] || [lowerCode isEqualToString:ASPropertyTypeBOOL2]) {
                _boolType = YES;
            }
        }
    }
}

@end
