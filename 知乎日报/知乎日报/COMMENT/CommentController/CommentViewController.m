//
//  CommentViewController.m
//  知乎日报
//
//  Created by mac on 2021/11/4.
//  Copyright © 2021 mac. All rights reserved.
//

#import "CommentViewController.h"
#import "Manager.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _longCommentModelDictionary = [[NSDictionary alloc] init];
    _shortCommentModelDictionary = [[NSDictionary alloc] init];
    _commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, SIZE_HEIGHT * 0.04, SIZE_WIDTH, SIZE_HEIGHT * 0.96)];
    [self.view addSubview:_commentView];
    [_commentView.backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self getLongCommentData];
}

- (void)getLongCommentData {
    [[Manager sharedManger] NetWorkLongCommentWithData:_commentID and:^(LongCommentModel * _Nonnull ViewModel) {
        NSLog(@"请求长评论数据成功%@",self.commentID);
        self.longCommentModelDictionary = [ViewModel toDictionary];
        self.commentView.longCommentDictionary = self.longCommentModelDictionary;
        // 异步执行任务创建方法
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getShortCommentData];
        });
        } error:^(NSError * _Nonnull error) {
            NSLog(@"请求失败");
    }];
}

- (void)getShortCommentData {
    [[Manager sharedManger] NetWorkShortCommentWithData:_commentID and:^(LongCommentModel * _Nonnull ViewModel) {
        self.shortCommentModelDictionary = [ViewModel toDictionary];
        self.commentView.shortCommentDictionary = self.shortCommentModelDictionary;
        // 异步执行任务创建方法
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentView addView];
        });
        } error:^(NSError * _Nonnull error) {
            NSLog(@"请求失败");
    }];
}

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
