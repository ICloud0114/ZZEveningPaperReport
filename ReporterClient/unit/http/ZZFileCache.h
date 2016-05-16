//
//  ZZFileCache.h
//  ZZDaheNewspaperIPhone
//
//  Created by wangshaosheng on 13-7-9.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZFileCache : NSObject
//{
//    NSCache *fileCache;
//
//}
//@property (nonatomic,retain)NSString *diskCachePath;
/*
 通过方法名和参数列表存取数据。
 */
+(NSDictionary *)dictionaryForKey:(NSDictionary *)dictionary;
+(BOOL)storeDataDictionary:(NSDictionary *)storeDictionary ForKey:(NSDictionary *)dictionary;
+(NSDictionary *)dictionaryForKeyString:(NSString *)dictionaryString;

+(BOOL)storeJsonString:(NSString *)jsonString  ForKey:(NSString *)keyString;
+(NSString *)jsonForKeyString:(NSString *)keyString;

+(BOOL)storeData:(NSData *)data ForKey:(NSString *)keyString;
+(NSData *)dataForKeyString:(NSString *)keyString;


@end
