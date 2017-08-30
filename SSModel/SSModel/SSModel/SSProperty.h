//
//  SSProperty.h
//  wiki
//
//  Created by JIA on 2017/8/29.
//  Copyright © 2017年 JIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class SSPropertyType;

@interface SSProperty : NSObject

@property (nonatomic, readonly, copy) NSString *name;

@property (nonatomic, readonly, strong) SSPropertyType *type;

+ (instancetype)propertyWithProperty:(objc_property_t)property;

@end

@interface SSPropertyType : NSObject

@property (nonatomic, readonly, getter=isIdType, assign) BOOL idType;

@property (nonatomic, readonly, getter=isNumberType, assign) BOOL numberType;

@property (nonatomic, readonly, getter=isBoolType, assign) BOOL boolType;

@property (nonatomic, readonly, getter=isFromFoundation, assign) BOOL fromFoundation;

@property (nonatomic, readonly, strong) Class classType;

@property (nonatomic, readonly, strong) NSString *code;

+ (instancetype)propertyTypeWithAttributeString:(NSString *)string;

@end
