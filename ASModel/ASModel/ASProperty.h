//
//  ASProperty.h
//  ASModel <https://github.com/jiaair/ASModel>
//
//  Created by JIA on 2017/8/29.
//  Copyright © 2017年 JIA. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class ASPropertyType;

@interface ASProperty : NSObject

@property (nonatomic, readonly, copy) NSString *name;

@property (nonatomic, readonly, strong) ASPropertyType *type;

+ (instancetype)propertyWithProperty:(objc_property_t)property;

@end

@interface ASPropertyType : NSObject

@property (nonatomic, readonly, getter=isIdType, assign) BOOL idType;

@property (nonatomic, readonly, getter=isNumberType, assign) BOOL numberType;

@property (nonatomic, readonly, getter=isBoolType, assign) BOOL boolType;

@property (nonatomic, readonly, getter=isFromFoundation, assign) BOOL fromFoundation;

@property (nonatomic, readonly, strong) Class classType;

@property (nonatomic, readonly, strong) NSString *code;

+ (instancetype)propertyTypeWithAttributeString:(NSString *)string;

@end
