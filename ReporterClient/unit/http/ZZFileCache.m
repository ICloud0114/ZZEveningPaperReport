//
//  ZZFileCache.m
//  ZZDaheNewspaperIPhone
//
//  Created by wangshaosheng on 13-7-9.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import "ZZFileCache.h"

@implementation ZZFileCache



+(NSString *)jsonForKeyString:(NSString *)keyString;
{
    NSString *nameString = [ZZ3DESEncrypt md5:keyString];
    //从硬盘上读取
    //    NSData *data = [NSData dataWithContentsOfFile:URLString];//取数据
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ZZCaches/ZZFileCache"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSError *error = nil;
    NSString *pathString = [diskCachePath stringByAppendingPathComponent:nameString];
    NSString *jsonString = [[NSString alloc]initWithContentsOfFile:pathString encoding:NSUTF8StringEncoding error:&error];    
    
    if (error)
    {
        NSLog(@"read cache error:%@",error);
        return nil;
    }
    else
    {
        return [jsonString autorelease];
    }

}



+(NSDictionary *)dictionaryForKeyString:(NSString *)dictionaryString
{
    NSString *nameString = [ZZ3DESEncrypt md5:dictionaryString];
    //从硬盘上读取
    //    NSData *data = [NSData dataWithContentsOfFile:URLString];//取数据
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ZZCaches/ZZFileCache"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSString *pathString = [diskCachePath stringByAppendingPathComponent:nameString];    
    NSDictionary *dataDictionary = [[NSDictionary alloc]initWithContentsOfFile:pathString];
    return [dataDictionary autorelease];
    
}

+(NSDictionary *)dictionaryForKey:(NSDictionary *)dictionary
{
    NSString *dictionaryString = [dictionary JSONString];
    return [ZZFileCache dictionaryForKeyString:dictionaryString];   
}

+(NSDictionary *)clearNSNULLObject:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *tempMutableDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    for (id key in tempMutableDictionary.allKeys)
    {
        if ([[tempMutableDictionary objectForKey:key] isKindOfClass:[NSNull class]])
        {
            [tempMutableDictionary removeObjectForKey:key];
        }
        
        if ([[tempMutableDictionary objectForKey:key] isKindOfClass:[NSDictionary class]])
        {
            [tempMutableDictionary setObject:[ZZFileCache clearNSNULLObject:[tempMutableDictionary objectForKey:key]] forKey:key];
        }
    }
    return [tempMutableDictionary autorelease];
}

+(BOOL)storeDataDictionary:(NSDictionary *)storeDictionary ForKey:(NSDictionary *)dictionary;
{
    storeDictionary = [ZZFileCache clearNSNULLObject:storeDictionary];
    NSString *dictionaryString = [dictionary JSONString];
    NSString *nameString = [ZZ3DESEncrypt md5:dictionaryString];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ZZCaches/ZZFileCache"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSString *pathString = [diskCachePath stringByAppendingPathComponent:nameString];
    
    
    BOOL sucess = [storeDictionary writeToFile:pathString atomically:YES];
    NSLog(@"--%i",sucess);
    
//    BOOL sucess =  [[NSFileManager defaultManager] createFileAtPath:nameString contents:[NSData dataw ] attributes:nil];
//    NSLog(@"--%i",sucess);
    return sucess;
}

+(BOOL)storeJsonString:(NSString *)jsonString ForKey:(NSString *)keyString;
{
    NSString *nameString = [ZZ3DESEncrypt md5:keyString];    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ZZCaches/ZZFileCache"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSString *pathString = [diskCachePath stringByAppendingPathComponent:nameString];
    NSError *error = nil;    
    BOOL sucess = [jsonString writeToFile:pathString atomically:YES encoding:NSUTF8StringEncoding error:&error];

    NSLog(@"sucess:%i,error:%@",sucess,error);
    
    //    BOOL sucess =  [[NSFileManager defaultManager] createFileAtPath:nameString contents:[NSData dataw ] attributes:nil];
    //    NSLog(@"--%i",sucess);
    return sucess;
}


+(BOOL)storeData:(NSData *)data  ForKey:(NSString *)keyString
{
    NSString *nameString = [ZZ3DESEncrypt md5:keyString];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ZZCaches/ZZFileCache"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSString *pathString = [diskCachePath stringByAppendingPathComponent:nameString];
    BOOL sucess = [data writeToFile:pathString atomically:YES];    
    NSLog(@"store sucess:%i",sucess);
    
    //    BOOL sucess =  [[NSFileManager defaultManager] createFileAtPath:nameString contents:[NSData dataw ] attributes:nil];
    //    NSLog(@"--%i",sucess);
    return sucess;
}



+(NSData *)dataForKeyString:(NSString *)keyString
{
    NSString *nameString = [ZZ3DESEncrypt md5:keyString];
    //从硬盘上读取
    //    NSData *data = [NSData dataWithContentsOfFile:URLString];//取数据
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ZZCaches/ZZFileCache"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    NSError *error = nil;
    NSString *pathString = [diskCachePath stringByAppendingPathComponent:nameString];
    NSData *data = [[NSData alloc]initWithContentsOfFile:pathString];
    if (error)
    {
        NSLog(@"read cache error:%@",error);
        return nil;
    }
    else
    {
        return [data autorelease];
    }    
}


@end
