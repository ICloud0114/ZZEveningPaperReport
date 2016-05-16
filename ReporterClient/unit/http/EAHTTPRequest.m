//
//  EAHTTPRequest.m
//  ReporterClient
//
//  Created by easaa on 4/15/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EAHTTPRequest.h"

@implementation EAHTTPRequest
+(NSInteger )checkConnect
{
    
    return 0;
}


+(NSString*)requestForPostWithURLString:(NSString *)URLString bodyImageData:(NSData *)imageData
{
    //    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSString *TWITTERFON_FORM_BOUNDARY = @"AABBCC";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    
    ////添加分界线，换行---文件要先声明
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"imgFile\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:imageData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    //建立连接，设置代理
    //    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //设置接受response的data
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection
                       sendSynchronousRequest:request
                       returningResponse: &response
                       error: &error];
    //    return [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
    //    DLog(@"DATA:%@, error:%@",URLData, error);
    NSString *json = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    //    json = [ZZ3DESEncrypt decrypt:json keyString:METHODKEY];//解密
    //    DLog(@"解密JSON:%@",json);
    //    json = [json URLDecodedString];//将josn转化为普通格式
    //    DLog(@"普通格式JSON:%@",json);
    //
    //    NSDictionary *returnDictionary = [[json objectFromJSONString] retain];
    //    DLog(@"解析的字典：%@",returnDictionary);
    
    return json;
}


#pragma mark GET方法
//网络请求方法get请求
+(NSString*)requestForGetWithURLString:(NSString *)URLString
{
    // 初始化
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"GET"];
    //同步请求
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return returnString;
}

#pragma mark -POST方法
//创建post方式的参数字符串url
+(NSString *)createPostURL:(NSDictionary *)bodyDictionary
{
    NSString *postString = @"";
    for(NSString *key in [bodyDictionary allKeys])
    {
        NSString *value=[bodyDictionary objectForKey:key];
         postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
//        postString=[postString stringByAppendingFormat:@"%@=%@&",@"Method",[bodyDictionary valueForKey:@"Method"]];
//    postString=[postString stringByAppendingFormat:@"%@=%@&",@"Params",[bodyDictionary valueForKey:@"Params"]];
//    postString=[postString stringByAppendingFormat:@"%@=%@&",@"Sign",[bodyDictionary valueForKey:@"Sign"]];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    
    return postString;
}

//网络请求方法post请求
+(NSString*)requestForPostWithURLString:(NSString *)URLString bodyString:(NSString *)bodyString withStore:(BOOL)isStore
{
    NSLog(@"地址：  %@%@",URLString,bodyString);
    
    NSData *postData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    const char *str = [URLString UTF8String];
    URLString = [NSString stringWithUTF8String:str];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *baseURL= [NSURL URLWithString:URLString];
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc] initWithURL:baseURL
                                                                    cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                                timeoutInterval:10.0f];
    [URLRequest setHTTPMethod: @"POST"];
    [URLRequest setValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [URLRequest setHTTPBody: postData];
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSData *URLData = [NSURLConnection
                       sendSynchronousRequest:URLRequest
                       returningResponse: &response
                       error: &error];
    
    NSString *json = nil;
    if (URLData == nil)//返回有问题时（如没网络，网络错误，服务器BUG),才从本地取。并且所有分页的数据对第一页缓存。第二页以后、登录接口不缓存
    {
        URLData = [ZZFileCache dataForKeyString:bodyString];
    }
    else
    {
        json = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
        if (json == nil)
        {
            URLData = [ZZFileCache dataForKeyString:bodyString];
        }
        else
        {
            if (isStore == YES)
            {
                [ZZFileCache storeData:URLData ForKey:bodyString];
            }
        }
    }
    
    json = [[NSString alloc] initWithData:URLData encoding:NSUTF8StringEncoding];
    
    return json;
    
}

//网络请求方法post请求
+(NSString *)requestForPostWithURLString:(NSString *)URLString bodyDictionary:(NSDictionary *)bodyDictionary  withStore:(BOOL)isStore
{
    return [EAHTTPRequest requestForPostWithURLString:URLString bodyString:[EAHTTPRequest createPostURL:bodyDictionary] withStore:isStore];
}

//网络请求方法post请求
+(NSString *)requestForPostWithbodyDictionary:(NSDictionary *)bodyDictionary withStore:(BOOL)isStore
{
    return [EAHTTPRequest requestForPostWithURLString:[[NSString alloc]initWithFormat:@"%@%@",BASEURL,METHODKEY] bodyDictionary:bodyDictionary withStore:(BOOL)isStore];
}


//网络请求方法post请求
+(id)requestForPostWithbodyDictionary:(NSDictionary *)bodyDictionary DESencypt:(BOOL)IsEncypt sign:(BOOL)IsSign
{
        if ([CheckNetwork isExistenceNetwork] == NO)
        {
            NSMutableDictionary *returnMutabelDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                                             @"-1", VERIFICATION,
                                                             @"当前网络故障，请检查后再试", ERROR, nil
                                                             
                                                            ];
           return returnMutabelDictionary;
//            if (([bodyDictionary objectForKey:PAGESIZE] != nil && [[bodyDictionary objectForKey:PAGEINDEX] integerValue] == 1) || [bodyDictionary objectForKey:NEWSID] != nil || [bodyDictionary objectForKey:CONNECTID] != nil)
//            {
//                return [ZZFileCache dictionaryForKey:bodyDictionary];
//            }
        }
    
    
//    switch ([CheckNetwork checkCurrentNetWorkStatus])
//    {
//        case NotReachable:
//        {
//            //                    DLog(@"没有网络");
//            //无网络网络时不请求
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"无网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
//            return 0;
//            break;
//        }
//        case ReachableViaWWAN:
//        {
//            //                    DLog(@"正在使用3G网络");
//            //2G/3G网络时不请求
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"2G/3G" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"wifi" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
//            break;
//        }
//        default:
//            break;
//    }
    
    
    BOOL isStore = YES;
    if ([[bodyDictionary objectForKey:PAGEINDEX] integerValue] > 1)//第二页不缓存
    {
        isStore = NO;
    }
    
    NSMutableDictionary *bodyMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:bodyDictionary];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[bodyMutabelDictionary objectForKey:METHOD],METHOD, nil];
    [bodyMutabelDictionary removeObjectForKey:METHOD];
    
    NSData *imageData = [bodyMutabelDictionary objectForKey:IMG];
    [bodyMutabelDictionary removeObjectForKey:IMG];//图片单独处理
    
    NSString *paramsString = nil;
    NSString *signString = nil;
    
    //    if ([[bodyMutabelDictionary objectForKey:NEW_IMG] isKindOfClass:[NSData class]] )
    //    {
    //        NSString *DataString = [[bodyMutabelDictionary objectForKey:NEW_IMG] base64Encoding];
    //        DataString =[DataString stringByReplacingOccurrencesOfString:@"+" withString:@"|JH|"];
    //        [bodyMutabelDictionary setObject:DataString forKey:NEW_IMG];
    //
    //    }
    
    NSString *jsonString = [bodyMutabelDictionary JSONString];//转成json格式
    
    //    if (imageData != nil)
    //    {
    //        jsonString = [@{METHOD:@"set.picture.add",@"picturename":@"123131.png"} JSONString];//转成json格式
    //    }
    
    if (IsEncypt == YES)
    {
        //进行3des加密
        paramsString = [[ZZ3DESEncrypt encrypt:jsonString keyString:METHODKEY] uppercaseString];
        if (paramsString != nil)
        {
            [sendMutabelDictionary setObject:paramsString forKey:PARAMS];
        }
    }
    
    if (IsSign == YES)
    {
        //使用md5对sign进行加密
        signString = [NSString stringWithFormat:@"%@%@%@%@%@%@",METHODKEY, METHOD,[sendMutabelDictionary objectForKey:METHOD],PARAMS,paramsString, METHODKEY];
        signString = [[ZZ3DESEncrypt md5:signString] uppercaseString];
        if (signString != nil)
        {
            NSLog(@" Sign = %@",signString);
            [sendMutabelDictionary setObject:signString forKey:SIGN];
        }
    }
    
    NSString *returnJsonString = nil;
    if (imageData == nil)
    {
        returnJsonString = [EAHTTPRequest requestForPostWithURLString:BASEURL bodyDictionary:sendMutabelDictionary withStore:isStore];
    }
    else//图片单独处理
    {
        returnJsonString = [EAHTTPRequest requestForPostWithURLString:[NSString stringWithFormat:@"%@%@",BASEURL,[EAHTTPRequest createPostURL:sendMutabelDictionary]] bodyImageData:imageData];
    }
    
    //    returnJsonString = @"A4B8A174FFB6A21E3EF0880F10AD4A15F62D2B927B86166E3FCBA1E184502827600160E709BCCB1FE492216C1B94373AAD5F26097C7CEDE056A90238F871F02C4CA7EE3AD3D66C8436F2A4545E01203F0ADE2246D3EB43167C7E6C3BAB03F132A58CDF04D7E88DBC254F9D88F3F7DDA2FCF2D8A05DF6D59395CE27436A39B34699DAB0864FAA748338791F82BA3CCAA936C25E03584C0229BCFD0D0DCACE440B071F3DB204D0DCB59597400020FB9E805BCCA4C2D477210222172AEA87ED41FBDF0B8C13789C6AF438F19A799E7A3BFC6E74BFDE1E596C4B5F033D9BBF8B69A95E3E2A3EFBF9CB28F46133F6B01D23B5600174C053A07C50A8BD973B31054D1D9F39D4F9AF0BA0D55EDFC73135A946AF188A6342B3247D75D02C840EB1384F5C4960C4AF345D9270C58E70D63945E4845AAE3DB82CBAEB8EE5B4BBCC34701ECAE99873CD59B62B89D1560104FD2ADEEDC7087000B1564AAD989D8C6A0B1B8BA2AD25BB606C94CAC5FE7126626D69839D79553D72ED0F27B049A071081356583B3EF4DE1CCC720F1429CEE20A6329D3C005FA87C89C4EB6CE87AC8A9E5F019B69257DAE1FCBE7545F80F44B5A99C9A9995EE20DD44301708431F3ECFE2AAB8E58B10FFB4E76DCF1BEFB7C305EF95C134A5F2E1F0EB27D3A4081CB8203ED48C5D48ADEAA6F77061C228AF1D87AE574C6953121F9200129DD33E7B4EDCAFC14B4181B333534ADB62CB229B6E69BF6969D5B26450C00886820B3D05FD8143106FC67F12E8B5DD630B48926666CB3D6F9A3FD2007CC17A6863AA859675729A5FC05DF6E0DE0DD79E030A8A565C73DC5C9DD852ABD6629DDABEBBA5F7DDA61C2C3E80C6962884DC691F36E51485E5F06B2716E22C59162840F0E937F4C74642DEF96B97925584B2466360A928ABBE83A6FB63E3C95ADF86DF35BA82E02A21EE22471DA965B684564BB78DA898BBBC0DC67A04D728FECCAD2EE52DDC626C6F9C6E8DA7451120AEEF5981B2DC2FDE29EEF232DBE1B794162F631AD771EB2CD7DB1AAD139A74C1891C6D466D833A61B1A120DEBFD29E3388F0F62B7F35330091DD1B4E7B4A97D3FB02E9C96B1B1B96BD2EC7C74433E18903C86361AEC58E5AA817EE7BE8D9EFAC0F03EFE76C593260093D661925B7D7C6B297C237467A375E204880A915F23AA907B1FCB86BA9734A0602C306191643FDF8A737012FC5500A4E741BBDD337F6883321F9F5C42829A3485B62A4FA4AC327C6822A7447931DB5FFF691EA2E0F7D8096811D619BDDF4170F7424E04A727BD2D5331946C1A64FF904279235AB58FF077E55040A26D8928E552DF7CDAA632FCA6E134253F43AC1DD67A0A906E950274466C2F14A275B4738ADB7E4C1D25FA951D955D01B8C7224129E8CB35AC367ECF7FCF3D68C21A73FBB5CCC4A8B13EEE542A67E7355FBEEC1605CD3204F319E80FEBB5BE86788DAC4254A0786EB4676C4400F924396236182916A8C8F0BC0EDEA31C66CC4B73D3C5A4817C9A251EEE5E841DE0A083EC903688DF61844C9F2D3BF8D7AAC9ECDCA938AC77F0EA9C7FE14263D00902898197F373E178B86381B13921A25F3914B9CAA8618AF7D5F16E6A646FB3F63080CF4A8D9BD703AEB3D64E6C58D1E5703539247AC232AF0968FDF3B3A9B3ADB277A5262574E1D9636EA69057DFCDA34BD7D3ACB21944DE238CB9961280A127BDB67DFA11E24414A8BF3E4090BB47E1868D354B09EB56D22DD56B6C";
    //
    //    returnJsonString = @"A4B8A174FFB6A21E3EF0880F10AD4A15F62D2B927B86166E3FCBA1E184502827600160E709BCCB1FE492216C1B94373AAD5F26097C7CEDE056A90238F871F02C4CA7EE3AD3D66C8436F2A4545E01203FCDA778F4BD5788C5";
    
    if (IsEncypt == YES)
    {
        returnJsonString = [ZZ3DESEncrypt decrypt:returnJsonString keyString:METHODKEY];//解密
    }
    
    //    returnJsonString = @"{\"msg\":1,\"msgbox\":\"返回歌手分类！\"}";
    //    returnJsonString = [returnJsonString URLEncodedString];
    //
    //    returnJsonString = @"%7b%22msg%22%3a1%2c%22msgbox%22%3a%22%b7%b5%bb%d8%b8%e8%ca%d6%b7%d6%c0%e0%a3%a1%22%7d";
    
    returnJsonString = [returnJsonString URLDecodedString];//将josn转化为普通格式
    
    NSMutableDictionary *returnMutableDictionary = [[NSMutableDictionary alloc]init];
    
    NSDictionary *returnDictionary = [returnJsonString objectFromJSONString];
    if ([returnDictionary isKindOfClass:[NSDictionary class]])
    {
        [returnMutableDictionary setDictionary:returnDictionary];
        //        if([returnDictionary objectForKey:DATA] !=nil )
        //        {
        //            returnJsonString = [ZZ3DESEncrypt decrypt:[returnDictionary objectForKey:DATA] keyString:METHODKEY];//解密
        //            if ([[returnJsonString URLDecodedString] objectFromJSONString] != nil)
        //            {
        //                [returnMutableDictionary setObject:[[returnJsonString URLDecodedString] objectFromJSONString] forKey:DATA];
        //
        //            }
        //        }
    }

    
    //    if (([bodyDictionary objectForKey:PAGESIZE] != nil && [[bodyDictionary objectForKey:PAGEINDEX] integerValue] == 1) || [bodyDictionary objectForKey:NEWSID] != nil || [bodyDictionary objectForKey:CONNECTID] != nil)
    //    {
    //        [ZZFileCache storeData:returnDictionary ForKey:bodyDictionary];
    //    }
    //在返回的json里面存
    
    return returnMutableDictionary;
}

//#pragma mark 1获取站点 get.dahe.site
//+(NSMutableDictionary *)getDaheSite:(NSDictionary *)sendDictionary//sendDictionary的键： siteid ,站点编号
//{
//    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
//    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
//    [sendMutabelDictionary setObject:GET_DAHE_SITE forKey:METHOD];
//    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
//    [returnDictionary setDictionary:receiveDictionary];
//    [sendMutabelDictionary release];
//    return [returnDictionary autorelease];
//}

//用户登陆
#pragma mark 1用户登录 set.member.login
+(NSMutableDictionary *)setMemberLogin:(NSDictionary *)sendDictionary;//sendDictionary的键： username 	用户名  password 密码
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_MEMBER_LOGIN forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}
//修改密码
#pragma mark update.member.modifypwd 修改密码
+(NSMutableDictionary *)updateMemberModifypwd:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:UPDATE_MEMBER_MODIFYPWD forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}
//找回密码
#pragma mark 2 get.member.repwd 找回密码
+(NSMutableDictionary *)getMemberRepwd:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_MEMBER_REPWD forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

//新闻编写
#pragma mark 3编写新闻 set.Manuscript.add
+(NSMutableDictionary *)setManuscriptAdd:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_MANUSCRIPT_ADD forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}
#pragma mark 4 编写新闻 set.Manuscript.update
//编辑上传新闻
+(NSMutableDictionary *)setManuscriptUpdate:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_MANUSCRIPT_UPDATE forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 5 get.searchsource.list 搜索（关联）线索列表
+(NSMutableDictionary *)getSearchSourceList:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_SEARCHSOURCE_LIST forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
    
}

#pragma mark 6 get.source.detial  报料详情
+(NSMutableDictionary *)getSourceDetail:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_SOURCE_DETAIL forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 7 get.source.reply 报料评论列表
+(NSMutableDictionary *)getSourceReply:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_SOURCE_REPLY forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 8 set.source.reply  报料评论
+(NSMutableDictionary *)setSourceReply:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_SOURCE_REPLY forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 9 get.source.fellows  报料追踪报道列表
+(NSMutableDictionary *)getSourceFellows:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_SOURCE_FELLOWS forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 10 set.source.fellows  报料追踪报道
+(NSMutableDictionary *)setSourceFellows:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_SOURCE_FELLOWS forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 11 update.source.setstate 抢占采用线索
+(NSMutableDictionary *)updateSourceSetState:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:UPDATE_SOURCE_SETSTATE forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

//上传图片
#pragma mark 12 set.accessorypic.add 上传图片
+(NSMutableDictionary *)setAccessoryPicAdd:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_ACCESSORYPIC_ADD forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}
//上传视频
#pragma mark 13 set.accessoryvideo.add 上传视频
+(NSMutableDictionary *)setAccessoryVideoAdd:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_ACCESSORYVIDEO_ADD forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 14 set.accessoryaudio.add 上传音频
+(NSMutableDictionary *)setAccessoryAudioAdd:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_ACCESSORYAUDIO_ADD forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 15 get.maymanuscript.list  我的稿件

+(NSMutableDictionary *)getMaymanuscriptList:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_MAYMANUSCRIPT_LIST forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}


#pragma mark 16 get.manuscript.detial 稿件详情

+(NSMutableDictionary *)getManuscriptDetail:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_MANUSCRIPT_DETAIL forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 17 get.accessory.list 获取稿件附件列表

+(NSMutableDictionary *)getAccessoryList:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_ACCESSORY_LIST forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 18修改头像 set.portrait.update
+(NSMutableDictionary *)setPortraitUpdate:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_PORTRAIT_UPDATE forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}


#pragma mark 19我的线索 get.mysource.list.update
+(NSMutableDictionary *)getMysourceList:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_MYSOURCE_LIST forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 19我的线索 set.source.setstate  抢占采用线索
+(NSMutableDictionary *)setSourceSetState:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:SET_SOURCE_SETSTATE forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;

}

#pragma mark 检测版本  get.mobile.version    检测版本
+(NSMutableDictionary *)getMobileVersion:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_MOBILE_VERSION forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}

#pragma mark 关于  get.about.detial    关于
+(NSMutableDictionary *)getAboutDetail:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_ABOUT_DETAIL forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}


#pragma mark   @"get.relevancymanuscript.list" 关联稿件列表

+(NSMutableDictionary *)getRelevancymanuscriptList:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_RELEVANCYMANUSCRIPT_LIST forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];

    return returnDictionary;
}
#pragma mark //get.relevancysource.list 关联线索列表
+(NSMutableDictionary *)getRelevancysourceList:(NSDictionary *)sendDictionary
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *sendMutabelDictionary = [[NSMutableDictionary alloc]initWithDictionary:sendDictionary];
    [sendMutabelDictionary setObject:GET_RELEVANCYSOURCE_LIST forKey:METHOD];
    NSDictionary *receiveDictionary = [EAHTTPRequest requestForPostWithbodyDictionary:sendMutabelDictionary DESencypt:YES sign:YES];
    [returnDictionary setDictionary:receiveDictionary];
    
    return returnDictionary;
}

@end
