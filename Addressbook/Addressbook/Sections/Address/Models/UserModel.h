//
//  UserModel.h
//  Addressbook
//
//  Created by 街路口等你 on 17/3/23.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;

- (id)initWithDic:(NSDictionary *)dic;
+ (id)userModelWithDic:(NSDictionary *)dic;


@end
