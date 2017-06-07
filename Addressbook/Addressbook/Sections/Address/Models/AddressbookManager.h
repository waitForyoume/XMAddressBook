//
//  AddressbookManager.h
//  Addressbook
//
//  Created by 街路口等你 on 17/3/24.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PersonInfoModel;

typedef void(^AddressbookInfoBlock)(NSMutableArray<PersonInfoModel *> *personInfoArray);

@interface AddressbookManager : NSObject

// 手机授权App用户获取通讯录权限
+ (void)xl_addressbookAuthorization:(AddressbookInfoBlock)block;

@end
