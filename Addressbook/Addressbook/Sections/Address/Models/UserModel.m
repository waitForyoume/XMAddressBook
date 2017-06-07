//
//  UserModel.m
//  Addressbook
//
//  Created by 街路口等你 on 17/3/23.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (id)userModelWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"ID"]) {
        self.userID = value;
    } else if ([key isEqualToString:@"Address"]) {
        self.address = value;
    } else if ([key isEqualToString:@"Name"]) {
        self.name = value;
    } else if ([key isEqualToString:@"Tel"]) {
        self.phone = value;
    }
}

@end
