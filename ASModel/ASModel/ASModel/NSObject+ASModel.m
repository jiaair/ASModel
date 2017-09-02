//
//  NSObject+ASModel.m
//  ASModel <https://github.com/jiaair/ASModel>
//
//  Created by JIA on 2017/8/29.
//  Copyright © 2017年 JIA. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "NSObject+ASModel.h"
#import <objc/message.h>
#import "ASProperty.h"

typedef struct property_t {
    const char *name;
    const char *attributes;
} *propertyStruct;

// Foudation类
static NSSet *foundationClasses;
// 类属性缓存
static NSMutableDictionary *cachedPropertyDict;

@implementation NSObject (SSModel)

+ (void)load {
    cachedPropertyDict = [NSMutableDictionary dictionary];
}

+ (NSArray *)properties {
    NSMutableArray *cachedProperties = cachedPropertyDict[NSStringFromClass(self)];
    
    if (!cachedProperties) {
        
        cachedProperties = [[NSMutableArray alloc] init];
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList(self, &outCount);
        
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            ASProperty *propertyObj = [ASProperty propertyWithProperty:property];
            [cachedProperties addObject:propertyObj];
        }
        
        free(properties);
        cachedPropertyDict[NSStringFromClass(self)] = cachedProperties;
    }

    return cachedProperties;
}

+ (instancetype)ss_objectWithKeyValues:(id)keyValues {
    if (!keyValues) return nil;
    return [[self alloc] setKeyValues:keyValues];
}

+ (instancetype)ss_modelWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary) return nil;
    return [[self alloc] setKeyValues:dictionary];
}

+ (instancetype)ss_modelWithJSON:(id)josn {
    if (!josn) return nil;
    josn = [josn JSONObject];
    return [[self alloc] setKeyValues:josn];
}

- (instancetype)setKeyValues:(id)keyValues {
    NSArray *propertyArr = [self.class properties];
    for (ASProperty *property in propertyArr) {
        ASPropertyType *type = property.type;
        Class classType = type.classType;
        if (type.isBoolType) {
            NSLog(@"bool");
        } else if (type.isNumberType) {
            NSLog(@"Number");
        } else {
            NSLog(@"%@", classType);
        }
        // 如果是嵌套模型则递归
        id value = nil;
        if (!type.isFromFoundation && classType) {
            value = [classType ss_objectWithKeyValues:value];
        } else if ([self.class respondsToSelector:@selector(objectClassInArray)]) {
            id objectClass;
            objectClass = [self.class objectClassInArray][property.name];
            if ([objectClass isKindOfClass:[NSString class]]) {
                objectClass = NSClassFromString(objectClass);
            }
            
            if (objectClass) {
                value = [objectClass ss_modelArrayWithKeyValuesArray:value];
            }
        }
        // 赋值
        value = [keyValues valueForKey:[self.class propertyKey:property.name]];
        if (!value) continue;
    
        if (type.isNumberType) {
            NSString *oldValue = value;
            if ([value isKindOfClass:[NSString class]]) {
                value = [[[NSNumberFormatter alloc] init] numberFromString:value];
                if (type.isBoolType) {
                    NSString *lower = [oldValue lowercaseString];
                    if ([lower isEqualToString:@"yes"] || [lower isEqualToString:@"ture"]) {
                        value = @YES;
                    } else if ([lower isEqualToString:@"no"] || [lower isEqualToString:@"false"]) {
                        value = @NO;
                    }
                }
            } else {
                if (classType == [NSString class]) {
                    if ([value isKindOfClass:[NSNumber class]]) {
                        value = [value description];
                    } else if ([value isKindOfClass:[NSURL class]]) {
                        value = [value absoluteString];
                    }
                }
            }
        }
        [self setValue:value forKey:property.name];
    }
    
    return self;
}

// 转换JSON
- (id)JSONObject {
    id foundationObj;
    if ([self isKindOfClass:[NSString class]]) {
        foundationObj = [NSJSONSerialization JSONObjectWithData:[(NSString *)self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([self isKindOfClass:[NSData class]]) {
        foundationObj = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    
    return foundationObj ?: self;
}

+ (BOOL)isClassFromFoundation:(Class)class {
    if (class == [NSObject class]) return YES;
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundtionClass, BOOL * _Nonnull stop) {
        if ([class isSubclassOfClass:foundtionClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

+ (NSSet *)foundationClasses {
    if (foundationClasses == nil) {
        foundationClasses = [NSSet setWithObjects:[NSURL class], [NSDate class], [NSValue class], [NSData class], [NSArray class], [NSDictionary class], [NSString class], [NSAttributedString class], nil];
    }
    
    return foundationClasses;
}

+ (NSMutableArray *)ss_modelArrayWithKeyValuesArray:(id)keyValuesArray {
    if ([self isClassFromFoundation:self]) {
        return keyValuesArray;
    }
    
    keyValuesArray = [keyValuesArray JSONObject];
    
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *keyValues in keyValuesArray) {
        id model;
        model = [self ss_objectWithKeyValues:keyValues];
        if (model) {
            [modelArr addObject:model];
        }
    }
    
    return modelArr;
}

// 替换Key
- (NSString *)propertyKey:(NSString *)propertyName {
    NSString *key;
    if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)]) {
        key = [self.class replacedKeyFromPropertyName][propertyName];
    }
    
    return key ?: propertyName;
}
@end
