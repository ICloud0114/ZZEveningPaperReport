//
//  ModifypwdViewController.m
//  ReporterClient
//
//  Created by easaa on 4/29/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "ModifypwdViewController.h"
#import "LoginViewController.h"
@interface ModifypwdViewController ()<UITextFieldDelegate>
{
     CustomNavigation *myNavigationBar;
     UITextField *oldTextField;
     UITextField *newTextField;
     UITextField *checkTextField;
}
@end

@implementation ModifypwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:BGCOLOR];
//    UIView *mainView = [[UIView alloc]init];
//    mainView.backgroundColor = BGCOLOR;
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
//        mainView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height -20);
//    }
//    else
//    {
//        mainView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
//    }
//    [self.view addSubview:mainView];
    myNavigationBar = [[CustomNavigation alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    myNavigationBar.titleLabel.text = @"修改密码";
    myNavigationBar.leftButton.hidden = NO;
    [myNavigationBar.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myNavigationBar];
    
    UIImageView *backgroundIMG = [[UIImageView alloc]initWithFrame:CGRectMake(29, 90, 262, 122)];
    [self.view addSubview:backgroundIMG];
    [backgroundIMG setImage:[UIImage imageNamed:@"xiugaimima"]];
    
    UIImageView *firstLine = [[UIImageView alloc]initWithFrame:CGRectMake(31, 131, 258, 2)];
    [firstLine setImage:[UIImage imageNamed:@"login_box_line"]];
    UIImageView *secondLine = [[UIImageView alloc]initWithFrame:CGRectMake(31, 171, 258, 2)];
    [secondLine setImage:[UIImage imageNamed:@"login_box_line"]];
    [self.view addSubview:firstLine];
    [self.view addSubview:secondLine];
    
    UILabel *oldPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, 93, 60, 37)];
    UILabel *newPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, 132, 60, 37)];
    UILabel *checkPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, 171, 75, 37)];
    
    [oldPasswordLabel setBackgroundColor:[UIColor clearColor]];
    [newPasswordLabel setBackgroundColor:[UIColor clearColor]];
    [checkPasswordLabel setBackgroundColor:[UIColor clearColor]];
    
//    [self.view addSubview:oldPasswordLabel];
//    [self.view addSubview:newPasswordLabel];
//    [self.view addSubview:checkPasswordLabel];
    
    [oldPasswordLabel setText:@"旧密码："];
    [newPasswordLabel setText:@"新密码："];
    [checkPasswordLabel setText:@"确认密码："];
    
    [oldPasswordLabel setFont:[UIFont systemFontOfSize:14]];
    [newPasswordLabel setFont:[UIFont systemFontOfSize:14]];
    [checkPasswordLabel setFont:[UIFont systemFontOfSize:14]];
    
    oldTextField = [[UITextField alloc]initWithFrame:CGRectMake((SCREENWIDTH - 290)/2, 93, 290, 30)];
    newTextField = [[UITextField alloc]initWithFrame:CGRectMake((SCREENWIDTH - 290)/2, 132, 290, 30)];
    checkTextField = [[UITextField alloc]initWithFrame:CGRectMake((SCREENWIDTH - 290)/2, 171, 290, 30)];
    [self.view addSubview:oldTextField];
    [self.view addSubview:newTextField];
    [self.view addSubview:checkTextField];
    
    
    [oldTextField setBackground:[UIImage imageNamed:@"input_box_290"]];
    [newTextField setBackground:[UIImage imageNamed:@"input_box_290"]];
    [checkTextField setBackground:[UIImage imageNamed:@"input_box_290"]];
    
    oldTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    checkTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    oldTextField.backgroundColor = [UIColor clearColor];
    newTextField.backgroundColor = [UIColor clearColor];
    checkTextField.backgroundColor = [UIColor clearColor];
    
    oldTextField.secureTextEntry = YES;
    newTextField.secureTextEntry = YES;
    checkTextField.secureTextEntry = YES;
    
    oldTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    checkTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    oldTextField.clearsOnBeginEditing = YES;
    newTextField.clearsOnBeginEditing = YES;
    checkTextField.clearsOnBeginEditing = YES;
    
    [oldTextField setFont:[UIFont systemFontOfSize:14]];
    [newTextField setFont:[UIFont systemFontOfSize:14]];
    [checkTextField setFont:[UIFont systemFontOfSize:14]];
    
    oldTextField.placeholder = @"请输入当前密码";
    newTextField.placeholder = @"请输入新密码（6-12位）";
    checkTextField.placeholder = @"请再次输入密码";
    
    
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setFrame:CGRectMake((SCREENWIDTH - 300)/2, 240, 300, 40)];
    [commitButton setBackgroundImage:[UIImage imageNamed:@"login_logo"] forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[UIImage imageNamed:@"login_logo_after"] forState:UIControlStateHighlighted];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitUpdatePassword) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:commitButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    
}

- (void)commitUpdatePassword
{
    
    NSString *str = nil;
    
    
//    if (![oldTextField.text  isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:PASSWORD_ZZ]])
//    {
//        str = @"您输入的旧密码不正确";
//    }
//    else
        if ([oldTextField.text isEqualToString: newTextField.text]) {
        str = @"新密码与旧密码一致，请重新输入";
    }
    else if(![newTextField.text isEqualToString: checkTextField.text])
    {
        str = @"您两次输入的密码不一致，请重新输入";
        
    }
    else
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *sendDictionary=[NSDictionary dictionaryWithObjectsAndKeys:[[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_DICTIONARY]objectForKey:USERID],USERID, newTextField.text,@"newpwd",oldTextField.text,@"oldpwd",nil];
            NSDictionary *receiveDictionary = [EAHTTPRequest updateMemberModifypwd:sendDictionary];
            NSLog(@"%@",receiveDictionary);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[receiveDictionary objectForKey:DATA]isKindOfClass:[NSArray class]])
                {
                    if ([[[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:STATE]intValue])
                    {
                        NSString *messageString = [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:MSG];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:messageString message:@"退出当前账号，重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView show];
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isAutoLogin"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        LoginViewController *loginView = [[LoginViewController alloc]init];
                        [self presentModalViewController:loginView animated:YES];
                    }
                    else
                    {
                        NSString *messageString = [[[receiveDictionary objectForKey:DATA]objectAtIndex:0]objectForKey:MSG];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:messageString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertView show];

                    }
                   
                    
                }
                else
                {
                    NSString *string  = @"服务器无响应，请稍后重试";
                    if([[receiveDictionary objectForKey:ERROR]isKindOfClass:[NSString class]])
                    {
                        
                        string = [receiveDictionary objectForKey:ERROR];
                        
                    }
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];

                }
                
            });
            
        });
        
        
        
    }
    if (str) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)tapGesture:(id)sender
{
    [self.view endEditing:YES];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == checkTextField)
    {
        
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
