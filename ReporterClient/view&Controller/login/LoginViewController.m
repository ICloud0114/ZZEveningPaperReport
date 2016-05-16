//
//  LoginViewController.m
//  ReporterClient
//
//  Created by easaa on 4/12/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "MLNavigationController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headPicture;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//@property (weak, nonatomic) IBOutlet UIButton *changeAccountButton;


- (IBAction)login:(id)sender;

//- (IBAction)changeAccount:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.userNameTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(id)sender
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender
{
    
    
    if(self.userNameTextField.text == nil || [self.userNameTextField.text isEqualToString:@""] || self.passwordTextField.text == nil  || [self.passwordTextField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入完整的信息后提交" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return;
    }
    [NSThread detachNewThreadSelector:@selector(getLoginReceiveData) toTarget:self withObject:nil];
       
}


- (void)getLoginReceiveData
{
    
    NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           self.userNameTextField.text,USERNAME,
                                           self.passwordTextField.text,PASSWORD,@"1",USERTYPE,
                                           nil];
    NSMutableDictionary *receiveDictionary = [EAHTTPRequest setMemberLogin:sendDictionary];
    NSLog(@"用户登录结果:%@",receiveDictionary);
    
    [self performSelectorOnMainThread:@selector(checkResultData:) withObject:receiveDictionary waitUntilDone:YES];
}

-(void)checkResultData:(NSDictionary *)receiveDictionary
{
    
    NSString *string = nil;
    if ([[receiveDictionary objectForKey:DATA] isKindOfClass:[NSArray class]])
    {
        if ([[receiveDictionary objectForKey:DATA] count] > 0)
        {
            if ([[[[receiveDictionary objectForKey:DATA] objectAtIndex:0] objectForKey:STATE] integerValue] == 1)
            {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.userNameTextField.text forKey:USER_NAME];
                
                [defaults setObject:self.passwordTextField.text forKey:PASSWORD_ZZ];
                
                [defaults setBool:YES forKey:@"isAutoLogin"];
                
                [defaults setObject:[[receiveDictionary objectForKey:DATA] objectAtIndex:0] forKey:USER_INFO_DICTIONARY];
                [defaults synchronize];

                MainViewController *mainView = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:Nil];
                
                MLNavigationController *MLNVC = [[MLNavigationController alloc]initWithRootViewController:mainView];
                MLNVC.navigationBar.translucent = NO;
                MLNVC.navigationBarHidden = YES;
                
                [self presentViewController:MLNVC animated:YES completion:^{
                    [[[UIApplication sharedApplication]keyWindow] setRootViewController:MLNVC];
                }];
                return;
            }
            else
            {
                string = [[[receiveDictionary objectForKey:DATA] objectAtIndex:0] objectForKey:MSG];
            }
        }
        if(string == nil || [string isEqualToString:@""])
        {
            string = @"服务器无响应，请稍后重试";
        }
    }
    else
    {
        string = [receiveDictionary objectForKey:ERROR];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
    

    
}

- (IBAction)changeAccount:(id)sender
{
    
    
}
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if(textField == self.passwordTextField)
    {
        [self.passwordTextField resignFirstResponder];
        [self login:nil];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![string isEqualToString:@""] && textField.text.length > 30)
    {
        return NO;
    }
    
    return YES;
}

@end
