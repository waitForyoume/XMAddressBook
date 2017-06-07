//
//  HttpTool.m
//  Addressbook
//
//  Created by 街路口等你 on 17/3/23.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool

+ (void)reqestWithMethod:(RequestMethodType)methodType URL:(NSString *)URL params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSURL *url = [NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    switch (methodType) {
        case RequestMethodTypePOST: {
            NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
            request.HTTPMethod = @"POST";
            request.HTTPBody = data;
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    success(dic);
                }
                else {
                    failure(error);
                }
            }];
            [dataTask resume];
        }
            break;
        case RequestMethodTypeGET: {
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    success(dic);
                }
                else {
                    failure(error);
                }
            }];
            [dataTask resume];
        }
            break;
        default:
            break;
    }
}

+ (void)putWithURL:(NSString *)url params:(id)params code:(void (^)(NSInteger))code {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPMethod = @"PUT";
    request.HTTPBody = data;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        code((long)[(NSHTTPURLResponse *)response statusCode]);
    }];
    [dataTask resume];
}

@end
