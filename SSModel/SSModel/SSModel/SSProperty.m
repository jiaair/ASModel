//
//  SSProperty.m
//  wiki
//
//  Created by JIA on 2017/8/29.
//  Copyright © 2017年 JIA. All rights reserved.
//

#import "SSProperty.h"

@implementation SSProperty

+ (instancetype)propertyWithProperty:(objc_property_t)property {
    
    return [[SSProperty alloc] initWithProperty:property];
}

- (instancetype)initWithProperty:(objc_property_t)property {
    if (self = [super init]) {
        _name = @(property_getName(property));
        _type = [SSPropertyType propertyTypeWithAttributeString:@(property_getAttributes(property))];
    }
    
    return self;
}

@end

NSString *const SSPropertyTypeInt = @"i";
NSString *const SSPropertyTypeShort = @"s";
NSString *const SSPropertyTypeFloat = @"f";
NSString *const SSPropertyTypeDouble = @"d";
NSString *const SSPropertyTypeLong = @"q";
NSString *const SSPropertyTypeChar = @"c";
NSString *const SSPropertyTypeBOOL1 = @"c";
NSString *const SSPropertyTypeBOOL2 = @"b";
NSString *const SSPropertyTypePoint = @"*";
NSString *const SSPropertyTypeIvar = @"^{objc_ival=}";
NSString *const SSPropertyTypeMethod = @"^{objc_method=}";
NSString *const SSPropertyTypeBlock = @"@?";
NSString *const SSPropertyTypeClass = @"#";
NSString *const SSPropertyTypeSEL = @":";
NSString *const SSPropertyTypeId = @"@";

static NSMutableDictionary *cachedTypeDict;

@implementation SSPropertyType

+ (void)load {
    cachedTypeDict = [NSMutableDictionary dictionary];
}

+ (instancetype)propertyTypeWithAttributeString:(NSString *)string {
    return [[SSPropertyType alloc] initWithTypeString:string];
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
    if ([code isEqualToString:SSPropertyTypeId]) {
        _idType = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        // 判断类型
        _classType = NSClassFromString(_code);
        _numberType = (_classType == [NSNumber class] || [_classType isSubclassOfClass:[NSNumber class]]);
        _fromFoundation = [NSObject isSubclassOfClass:_classType];
        
        NSString *lowerCode = _code.lowercaseString;
        NSArray *numberTypes = @[SSPropertyTypeInt, SSPropertyTypeShort, SSPropertyTypeBOOL1, SSPropertyTypeBOOL2, SSPropertyTypeFloat, SSPropertyTypeDouble, SSPropertyTypeLong, SSPropertyTypeChar];
        if ([numberTypes containsObject:lowerCode]) {
            _numberType = YES;
            
            if ([lowerCode isEqualToString:SSPropertyTypeBOOL1] || [lowerCode isEqualToString:SSPropertyTypeBOOL2]) {
                _boolType = YES;
            }
        }
    }
}

@end
