//
//  HttpTool.h
//  Addressbook
//
//  Created by 街路口等你 on 17/3/23.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethodType) {
    RequestMethodTypePOST,
    RequestMethodTypeGET
};

@interface HttpTool : NSObject

+ (void)reqestWithMethod:(RequestMethodType)methodType URL:(NSString *)URL params:(NSDictionary *)params success:(void(^)(id response))success failure:(void(^)(NSError *err))failure;

+ (void)putWithURL:(NSString *)url params:(id)params code:(void(^)(NSInteger stateCode))code;

@end
