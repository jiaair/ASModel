//
//  NSObject+SSModel.h
//  wiki
//
//  Created by JIA on 2017/8/29.
//  Copyright © 2017年 JIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSKeyValue <NSObject>

+ (NSDictionary *)objectClassInArray;

+ (NSDictionary *)replacedKeyFromPropertyName;

@end

@interface NSObject (SSModel)

+ (NSArray *)properties;

+ (instancetype)ss_modelWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)ss_modelWithJSON:(id)josn;

+ (NSMutableArray *)ss_modelArrayWithKeyValuesArray:(id)keyValuesArray;

@end
