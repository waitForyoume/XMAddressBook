//
//  PersonInfoModel.h
//  Addressbook
//
//  Created by 街路口等你 on 17/3/24.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonInfoModel : NSObject

// 联系人姓名
@property (nonatomic, copy) NSString *personName;
// 联系人电话
@property (nonatomic, copy) NSString *personPhone;

@end
