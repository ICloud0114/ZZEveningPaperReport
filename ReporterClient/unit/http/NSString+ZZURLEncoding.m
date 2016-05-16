//
//  NSString+ZZURLEncoding.m
//  ZZMostTalented
//
//  Created by wangshaosheng on 13-4-9.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import "NSString+ZZURLEncoding.h"

@implementation NSString (ZZURLEncoding)

- (NSString *)URLEncodedString
{
    
    NSString *result = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&amp;=+$,/?%#[] "),
//                                            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                            kCFStringEncodingUTF8
                                            );
    
    return [result autorelease];
}

- (NSString*)URLDecodedString
{
    self = [self stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    self = (NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
//                                                            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                                                            kCFStringEncodingUTF8
                                                            );
    
    return [self autorelease];
}

- (NSDictionary *)PareseDic
{
    NSArray *contentArr = [self componentsSeparatedByString:@","];
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    for (NSString * content in contentArr) {
        NSArray *childArr = [content componentsSeparatedByString:@"="];
        NSString *key =[childArr objectAtIndex:0];
        NSString *value = [childArr objectAtIndex:1];
        [returnDic setObject:value forKey:key];
    }
    return [returnDic autorelease];
}

@end
