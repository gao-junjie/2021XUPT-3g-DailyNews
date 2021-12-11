//
//  Manager.m
//  知乎日报
//
//  Created by mac on 2021/10/20.
//  Copyright © 2021 mac. All rights reserved.
//

#import "Manager.h"

static Manager *manager = nil;

@implementation Manager
+ (instancetype)sharedManger {
    if (!manager){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [Manager new];
        });
    }
    return manager;
}

- (void)NetWorkTestWithData:(TestSucceedBlock)succeedBlock error:(ErrorBlock)errorBlock {
    NSString *json = @"http://news-at.zhihu.com/api/4/news/latest";
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *testUrl = [NSURL URLWithString:json];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testUrl];
    NSURLSession *testSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            HomeModel *country = [[HomeModel alloc] initWithData:data error:nil];
            succeedBlock(country);
        } else {
            errorBlock(error);
        }
        }];
    //任务启动
        [testDataTask resume];
}

- (void)NetWorkBeforeWithData:(NSString *)a and:(TestSucceedBlock)succeedBlock error:(ErrorBlock) errorBlock {
    NSString *json = [NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%@",a];
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *testUrl = [NSURL URLWithString:json];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testUrl];
    NSURLSession *testSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            HomeModel *country = [[HomeModel alloc] initWithData:data error:nil];
            succeedBlock(country);
        } else {
            errorBlock(error);
        }
        }];
    //任务启动
        [testDataTask resume];
}

- (void)NetWorkLongCommentWithData:(NSString *)a and:(TestLongCommentSucceedBlock)succeedLongCommentBlock error:(ErrorBlock) errorBlock {
    NSString *json = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/story/%@/long-comments",a];
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *testUrl = [NSURL URLWithString:json];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testUrl];
    NSURLSession *testSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            LongCommentModel *country = [[LongCommentModel alloc] initWithData:data error:nil];
            succeedLongCommentBlock(country);
        } else {
            errorBlock(error);
        }
        }];
    //任务启动
        [testDataTask resume];
}

- (void)NetWorkShortCommentWithData:(NSString *)a and:(TestLongCommentSucceedBlock)succeedBlock error:(ErrorBlock) errorBlock {
    NSString *json = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/short-comments",a];
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *testUrl = [NSURL URLWithString:json];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testUrl];
    NSURLSession *testSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            LongCommentModel *country = [[LongCommentModel alloc] initWithData:data error:nil];
            succeedBlock(country);
        } else {
            errorBlock(error);
        }
        }];
    //任务启动
        [testDataTask resume];
}

- (void)NetWorkWebPageExtraWithData:(NSString *)a and:(TestWebPageExtraSucceedBlock)succeedBlock error:(ErrorBlock) errorBlock {
    NSString *json = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/story-extra/%@",a];
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *testUrl = [NSURL URLWithString:json];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testUrl];
    NSURLSession *testSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            WebPageModel *country = [[WebPageModel alloc] initWithData:data error:nil];
            succeedBlock(country);
        } else {
            errorBlock(error);
        }
        }];
    //任务启动
        [testDataTask resume];
}

@end
