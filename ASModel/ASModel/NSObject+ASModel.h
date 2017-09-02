//
//  NSObject+ASModel.h
//  ASModel <https://github.com/jiaair/ASModel>
//
//  Created by JIA on 2017/8/29.
//  Copyright © 2017年 JIA. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

@protocol ASKeyValue <NSObject>

+ (NSDictionary *)objectClassInArray;

+ (NSDictionary *)replacedKeyFromPropertyName;

@end

@interface NSObject (ASModel)


/**
 Returns a list of properties from instance.

 @return Array of properties.
 */
+ (NSArray *)properties;


/**
 returns a new instance of the receiver from a key-value dictionary.

 @param dictionary A dictionary mapped to the instance's properties.
 @return A new instance.
 */
+ (instancetype)as_modelWithDictionary:(NSDictionary *)dictionary;


/**
 returns a new instance of the receiver from a json object.

 @param josn A json
 @return A new instance.
 */
+ (instancetype)as_modelWithJSON:(id)josn;


/**
 returns a new instance of array type from a key-value Array.

 @param keyValuesArray Contains any dictionary of the array
 @return Contains any object class of the array
 */
+ (NSMutableArray *)as_modelArrayWithKeyValuesArray:(id)keyValuesArray;

@end
