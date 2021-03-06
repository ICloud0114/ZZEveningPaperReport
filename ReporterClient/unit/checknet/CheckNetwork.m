//
//  CheckNetwork.m
//  iphone.network1
//
//  Created by wangjun on 10-12-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CheckNetwork.h"
@implementation CheckNetwork
+(BOOL)isExistenceNetwork
{
	BOOL isExistenceNetwork=FALSE;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
			isExistenceNetwork=TRUE;
            NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
			isExistenceNetwork=TRUE;
            NSLog(@"正在使用wifi网络");        
            break;
    }
	return isExistenceNetwork;
}


+(NetworkStatus)checkCurrentNetWorkStatus
{
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    return [r currentReachabilityStatus];
}



@end
