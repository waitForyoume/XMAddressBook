//
//  LoginViewController.m
//  Addressbook
//
//  Created by 街路口等你 on 17/3/23.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpTool.h"
#import "AddressViewController.h"
#import "NSString+MD5.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kLoginURL @"http://121.196.200.215/api/login"

@interface LoginViewController ()

@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *passwordL;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *loginB;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutLoginView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)layoutLoginView {
    [self.view addSubview:self.nameL];
    [self.view addSubview:self.nameTF];
    [self.view addSubview:self.passwordL];
    [self.view addSubview:self.passwordTF];
    [self.view addSubview:self.loginB];
}

- (void)loginAction {
    NSString *password = [self.passwordTF.text md5];
    NSDictionary *dic = @{@"UserName":self.nameTF.text, @"UserPwd":password};
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpTool reqestWithMethod:RequestMethodTypePOST URL:kLoginURL params:dic success:^(id response) {
           
            NSLog(@"登录成功: %@", response);
            
            self.userId = response[@"ID"];
            self.token = response[@"Token"];
            dispatch_async(dispatch_get_main_queue(), ^{
                AddressViewController *address = [[AddressViewController alloc] init];
                address.userId = self.userId;
                address.token = self.token;
                [self.navigationController pushViewController:address animated:YES];
            });
        } failure:^(NSError *err) {
            
        }];
    });
}

- (UILabel *)nameL {
    if (!_nameL) {
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, 60, 40)];
        _nameL.text = @"用户名";
        _nameL.textColor = [UIColor lightGrayColor]; // 设置字体颜色
        _nameL.textAlignment = 1;
        _nameL.layer.cornerRadius = 4;
        _nameL.layer.masksToBounds = YES;
    }
    return _nameL;
}

- (UILabel *)passwordL {
    if (!_passwordL) {
        self.passwordL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameL.frame), CGRectGetMaxY(self.nameL.frame) + 10, CGRectGetWidth(self.nameL.frame), CGRectGetHeight(self.nameL.frame))];
        _passwordL.text = @"密码";
        _passwordL.textColor = [UIColor lightGrayColor];
        _passwordL.textAlignment = 1;
        _passwordL.layer.cornerRadius = 4;
        _passwordL.layer.masksToBounds = YES;
    }
    return _passwordL;
}

- (UITextField *)nameTF {
    if (!_nameTF) {
        self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameL.frame) + 15, CGRectGetMinY(self.nameL.frame), kWidth - CGRectGetMinX(self.nameL.frame) * 2 - CGRectGetWidth(self.nameL.frame), CGRectGetHeight(self.nameL.frame))];
        _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        // 提示文本
        _nameTF.placeholder = @"请输入用户名";
        // 边框
        _nameTF.borderStyle = UITextBorderStyleRoundedRect;
        _nameTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _nameTF;
}

- (UITextField *)passwordTF {
    if (!_passwordTF) {
        self.passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameTF.frame), CGRectGetMinY(self.passwordL.frame), CGRectGetWidth(self.nameTF.frame), CGRectGetHeight(self.nameTF.frame))];
        _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTF.secureTextEntry = YES;
        // 提示文本
        _passwordTF.placeholder = @"请输入密码";
        // 边框
        _passwordTF.borderStyle = UITextBorderStyleRoundedRect;
        _passwordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;

    }
    return _passwordTF;
}

- (UIButton *)loginB {
    if (!_loginB) {
        self.loginB = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginB.backgroundColor = [UIColor lightGrayColor];
        _loginB.frame = CGRectMake(150, CGRectGetMaxY(self.passwordTF.frame) + 35, kWidth - 300, 35);
        _loginB.layer.cornerRadius = 3;
        _loginB.layer.masksToBounds = YES;
        [_loginB setTitle:@"登录" forState:UIControlStateNormal];
        [_loginB setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_loginB addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginB;
}

@end
