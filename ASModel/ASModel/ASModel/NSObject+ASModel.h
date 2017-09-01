//
//  NSObject+ASModel.h
//  wiki
//
//  Created by Jia on 2017/8/29.
//  Copyright © 2017年 Jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASKeyValue <NSObject>

+ (NSDictionary *)objectClassInArray;

+ (NSDictionary *)replacedKeyFromPropertyName;

@end

@interface NSObject (ASModel)

+ (NSArray *)properties;

+ (instancetype)as_modelWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)as_modelWithJSON:(id)josn;

+ (NSMutableArray *)as_modelArrayWithKeyValuesArray:(id)keyValuesArray;

@end
