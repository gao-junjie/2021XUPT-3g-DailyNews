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
    return m
}

-(void)NetWorkTestWithData:(TestSucceedBlock)succeedBlock error:(ErrorBlock)errorBlock{
    NSString *json = @"http://news-at.zhihu.com/api/4/news/latest";
    json = [json stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *testUrl = [NSURL URLWithString:json];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testUrl];
    NSURLSession *testSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *testDataTask = [testSession dataTaskWithRequest:testRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            TestModel *country = [[TestModel alloc] initWithData:data error:nil];
//                    NSLog(@"%@",country.stories[0]);
            succeedBlock(country);
        } else {
            errorBlock(error);
        }
//        self->_stories = country.stories[0];
//        NSLog(@"%@",self->_stories.title);
        }];
    //任务启动
        [testDataTask resume];
}

@end
