//
//  AddressViewController.m
//  Addressbook
//
//  Created by 街路口等你 on 17/3/23.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "AddressViewController.h"
#import "ContactsViewController.h"
#import "HttpTool.h"
#import "UserModel.h"
#import "AddressCell.h"


#define kURL @"http://121.196.200.215/api/login/%@?token=%@"

@interface AddressViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    [self.view addSubview:self.tableView];
    [self requestAddressbooks];
    [self addressNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)requestAddressbooks {
    
    NSLog(@"数据列表 : %@", [NSString stringWithFormat:kURL, self.userId, self.token]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HttpTool reqestWithMethod:RequestMethodTypeGET URL:[NSString stringWithFormat:kURL, self.userId, self.token] params:nil success:^(id response) {
            [self unparsedData:response];
        } failure:^(NSError *err) {
            
        }];
    });
}

- (void)unparsedData:(NSArray *)response {
    
    for (NSDictionary *dic in response) {
        UserModel *model = [UserModel userModelWithDic:dic];
        [self.dataArray addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressCell class]) forIndexPath:indexPath];
    UserModel *model = self.dataArray[indexPath.row];
    
    cell.nameL.text = model.name;
    cell.phoneL.text = model.phone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 选中后颜色即刻消失
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (void)addressNavigationBar {
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(addressBcakAction)];
    self.navigationItem.leftBarButtonItem = back;
    
    UIBarButtonItem *contacts = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(contactsAction)];
    self.navigationItem.rightBarButtonItem = contacts;
}

- (void)addressBcakAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)contactsAction {    
    ContactsViewController *contacts = [[ContactsViewController alloc] init];
    contacts.belongId = self.userId;
    contacts.token = self.token;
    [self.navigationController pushViewController:contacts animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[AddressCell class] forCellReuseIdentifier:NSStringFromClass([AddressCell class])];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

@end
