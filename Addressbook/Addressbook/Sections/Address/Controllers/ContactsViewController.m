//
//  ContactsViewController.m
//  Addressbook
//
//  Created by 街路口等你 on 17/3/23.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "ContactsViewController.h"
#import "AddressbookManager.h"
#import "PersonInfoModel.h"
#import "AddressCell.h"
#import "HttpTool.h"

#define kURL @"http://121.196.200.215/api/login/%@?token=%@"

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource; // 数据源

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本地列表";
    [self.view addSubview:self.tableView];
    [self xl_loadDataSource];
    
//    [self contactsNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)xl_loadDataSource {
    [AddressbookManager xl_addressbookAuthorization:^(NSMutableArray<PersonInfoModel *> *personInfoArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSource = personInfoArray;
            [self.tableView reloadData];
        });
    }];
}

- (void)contactsNavigationBar {
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(contactsBcakAction)];
    self.navigationItem.leftBarButtonItem = back;
    
    UIBarButtonItem *contacts = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(uploadAction)];
    self.navigationItem.rightBarButtonItem = contacts;
}

// MARK: - 返回
- (void)contactsBcakAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: - 上传事件
- (void)uploadAction {
    NSString *uploadURL = [NSString stringWithFormat:kURL, self.belongId, self.token];
    NSMutableArray *params = [NSMutableArray array];
    for (PersonInfoModel *model in self.dataSource) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:model.personPhone forKey:@"Tel"];
        [dic setValue:model.personName forKey:@"Name"];
        [dic setValue:self.belongId forKey:@"BelongID"];
        [dic setValue:self.belongId forKey:@"ID"];
        [dic setValue:@"" forKey:@"Address"];
        [params addObject:dic];
    }
    
//        NSDictionary *dic = @{@"ID":@2, @"Name":@"回复", @"BelongID":self.userId, @"Tel":@"1861172981", @"Address":@"bj"};
//        NSLog(@"string %@", string);
    [HttpTool putWithURL:uploadURL params:params code:^(NSInteger stateCode) {
        
        NSLog(@" stateCode --- %ld", stateCode);
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressCell class]) forIndexPath:indexPath];
    PersonInfoModel *model = self.dataSource[indexPath.row];
    cell.nameL.text = model.personName;
    cell.phoneL.text = model.personPhone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[AddressCell class] forCellReuseIdentifier:NSStringFromClass([AddressCell class])];
    }
    return _tableView;
}

@end
