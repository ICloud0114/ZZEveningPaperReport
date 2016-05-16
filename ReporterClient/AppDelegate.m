//
//  AppDelegate.m
//  ReporterClient
//
//  Created by easaa on 4/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "MainViewController.h"
#import "MLNavigationController.h"

@implementation AppDelegate
{
    NSString *versionURLString;
}


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    [NSThread detachNewThreadSelector:@selector(checkVersionUpdate) toTarget:self withObject:nil];//检查版本更新
    return  YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSLog(@"begin================");
    NSLog(@"%d", [[NSUserDefaults standardUserDefaults]boolForKey:@"isAutoLogin"]);
    NSLog(@"end==================");
    
    
    
//    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isAutoLogin"])
    {
        
        MainViewController *mainView = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:Nil];

        MLNavigationController *MLNVC = [[MLNavigationController alloc]initWithRootViewController:mainView];
        MLNVC.navigationBar.translucent = NO;
        MLNVC.navigationBarHidden = YES;
        self.window.rootViewController = MLNVC;
        
    }
    else
    {
        LoginViewController *loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        self.window.rootViewController = loginViewController;
    }
    NSLog(@"begin================");
    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"end==================");
    //    [application setStatusBarStyle:UIStatusBarStyleDefault];
    //    [self.window setClipsToBounds:YES];
    
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
//    {
//        [self showGuideView];
//    }
    return YES;
}


-(void)checkVersionUpdate
{
    NSDictionary *sendDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"mobiletype",@"1",@"versionsType",nil];
    NSMutableDictionary *versionMutableDictionary = [EAHTTPRequest getMobileVersion:sendDictionary];
    NSLog(@"-->%@",versionMutableDictionary);
    
    [self performSelectorOnMainThread:@selector(showUpdate:) withObject:versionMutableDictionary waitUntilDone:YES];
    
}
-(void)showUpdate:(NSDictionary *)receiveDictionary
{
    if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
    {
        if ([[[receiveDictionary objectForKey:DATA][0] objectForKey:@"name"] isKindOfClass:[NSString class]])
        {
            if (![[[receiveDictionary objectForKey:DATA][0] objectForKey:@"name"] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]])
            {
            
                versionURLString = [[receiveDictionary objectForKey:DATA][0] objectForKey:@"url"];
                if ([[[receiveDictionary objectForKey:DATA][0] objectForKey:@"bewrite"] isKindOfClass:[NSString class]])
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"版本更新 %@",[[receiveDictionary objectForKey:DATA][0] objectForKey:@"name"] ]message:[[receiveDictionary objectForKey:DATA][0] objectForKey:@"bewrite"] delegate:self cancelButtonTitle:@"稍后更新" otherButtonTitles:@"确定",nil];
                    [alertView setTag:814];
                    [alertView show];
                }
                
            }
        }
    }
    
//    else
//    {
//        
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[receiveDictionary objectForKey:ERROR] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }
}


- (void)showGuideView  //引导页
{
    //    NSFileManager *file = [NSFileManager defaultManager];
    //    NSBundle *bundle =[NSBundle mainBundle];
    //    NSString *str = [bundle pathForResource:@"guide" ofType:@"bundle"];
    //    NSArray *list = nil;
    //
    //    NSLog(@"%@",NSHomeDirectory());
    //    if ([file fileExistsAtPath:str])
    //    {
    //        list = [file contentsOfDirectoryAtPath:str error:nil];
    //    }
    //    if (list.count > 0)
    //    {
    //用户向导
    //        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        guideViewController = [[GuideViewController alloc] init];
        [self.window addSubview:guideViewController.view];
    }
    //        }
    //    }

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag)
    {
        case 814:
        {
            if (buttonIndex == 0)
            {
            }
            else
            {
                NSLog(@"%@",versionURLString);
               
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionURLString]];
            }
            
        }
            break;
            
            
            
        default:
            break;
    }
    
}
@end
