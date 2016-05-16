//
//  EAHTTPRequest.h
//  ReporterClient
//
//  Created by easaa on 4/15/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EADefineHeader.h"
#import "ZZ3DESEncrypt.h"
#import "ZZFileCache.h"
#import "NSData+Base64.h"
#import "JSONKit.h"
#import "NSString+ZZURLEncoding.h"

#import "CheckNetwork.h"
@interface EAHTTPRequest : NSObject

+(NSString*)requestForGetWithURLString:(NSString *)URLString;
//#pragma mark 2获取站点 get.dahe.site
//+(NSMutableDictionary *)getDaheSite:(NSDictionary *)sendDictionary;//sendDictionary的键： siteid ,站点编号
#pragma mark 1用户登录 set.member.login

+(NSMutableDictionary *)setMemberLogin:(NSDictionary *)sendDictionary;//sendDictionary的键： username 	用户名  password 密码
#pragma mark 2 get.member. repwd    找回密码
+(NSMutableDictionary *)getMemberRepwd:(NSDictionary *)sendDictionary;

#pragma mark update.member.modifypwd 修改密码
+(NSMutableDictionary *)updateMemberModifypwd:(NSDictionary *)sendDictionary;

#pragma mark 3 set.Manuscript.add   编写新闻
+(NSMutableDictionary *)setManuscriptAdd:(NSDictionary *)sendDictionary;

#pragma mark 4 set.Manuscript.update   新闻编写上传
+(NSMutableDictionary *)setManuscriptUpdate:(NSDictionary *)sendDictionary;


#pragma mark 5 get. searchsource.list 搜索（关联）线索列表
+(NSMutableDictionary *)getSearchSourceList:(NSDictionary *)sendDictionary;


#pragma mark 6 get.source.detial    报料详情
+(NSMutableDictionary *)getSourceDetail:(NSDictionary *)sendDictionary;


#pragma mark 7 get.source.reply     报料评论列表
+(NSMutableDictionary *)getSourceReply:(NSDictionary *)sendDictionary;


#pragma mark 8 set.source.reply     报料评论
+(NSMutableDictionary *)setSourceReply:(NSDictionary *)sendDictionary;


#pragma mark 9 get.source.fellows   报料追踪报道列表
+(NSMutableDictionary *)getSourceFellows:(NSDictionary *)sendDictionary;


#pragma mark 10 set.source.fellows   报料追踪报道
+(NSMutableDictionary *)setSourceFellows:(NSDictionary *)sendDictionary;


#pragma mark 11 update.source.setstate 抢占采用线索
+(NSMutableDictionary *)updateSourceSetState:(NSDictionary *)sendDictionary;


#pragma mark 12 set. accessorypic.add 上传图片
+(NSMutableDictionary *)setAccessoryPicAdd:(NSDictionary *)sendDictionary;


#pragma mark 13 set. accessoryvideo.add 上传视频
+(NSMutableDictionary *)setAccessoryVideoAdd:(NSDictionary *)sendDictionary;


#pragma mark 14 set. accessoryaudio.add 上传音频
+(NSMutableDictionary *)setAccessoryAudioAdd:(NSDictionary *)sendDictionary;


#pragma mark 15 get.maymanuscript.list  我的稿件

+(NSMutableDictionary *)getMaymanuscriptList:(NSDictionary *)sendDictionary;

#pragma mark 16 get.manuscript.detial 稿件详情

+(NSMutableDictionary *)getManuscriptDetail:(NSDictionary *)sendDictionary;

#pragma mark 17 get.accessory.list 获取稿件附件列表

+(NSMutableDictionary *)getAccessoryList:(NSDictionary *)sendDictionary;


#pragma mark 18修改头像 set.portrait.update  上传图片
+(NSMutableDictionary *)setPortraitUpdate:(NSDictionary *)sendDictionary;


#pragma mark 19我的线索 get.mysource.list.update  我的线索
+(NSMutableDictionary *)getMysourceList:(NSDictionary *)sendDictionary;

#pragma mark 20抢占采用线索 set.source.setstate  抢占采用线索
+(NSMutableDictionary *)setSourceSetState:(NSDictionary *)sendDictionary;

#pragma mark 检测版本  get.mobile.version    检测版本
+(NSMutableDictionary *)getMobileVersion:(NSDictionary *)sendDictionary;

#pragma mark 关于  get.about.detial    关于
+(NSMutableDictionary *)getAboutDetail:(NSDictionary *)sendDictionary;

#pragma mark   @"get.relevancymanuscript.list" 关联稿件列表

+(NSMutableDictionary *)getRelevancymanuscriptList:(NSDictionary *)sendDictionary;


#pragma mark //get.relevancysource.list 关联线索列表
+(NSMutableDictionary *)getRelevancysourceList:(NSDictionary *)sendDictionary;


@end
