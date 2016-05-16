//
//  NSString+ZZURLEncoding.h
//  ZZMostTalented
//
//  Created by wangshaosheng on 13-4-9.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZZURLEncoding)
- (NSString *)URLEncodedString;//将字符串进行URL编码
- (NSString *)URLDecodedString;//将字符串进行URL解码
- (NSDictionary *)PareseDic;
@end
