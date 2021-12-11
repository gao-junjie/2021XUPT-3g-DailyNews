//
//  Manager.h
//  知乎日报
//
//  Created by mac on 2021/10/20.
//  Copyright © 2021 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
#import "LongCommentModel.h"
#import "WebPageModel.h"
NS_ASSUME_NONNULL_BEGIN

//块定义 定义一个block 类型的变量 SuccesBlock  为输入参数 其需要参数类型是id 返回值是第二个括号 的块
//这样就可以利用 SuccesBlock进行参数的传递或者是编辑。
typedef void (^TestSucceedBlock)(HomeModel * _Nonnull homeViewNowModel);
typedef void (^TestLongCommentSucceedBlock)(LongCommentModel * _Nonnull LongCommentModel);
typedef void (^TestWebPageExtraSucceedBlock)(WebPageModel * _Nonnull WebPageExtraModel);
//typedef void (^TestShortCommentSucceedBlock)(ShortCommentModel * _Nonnull LongCommentModel);
//失败返回error
typedef void (^ErrorBlock)(NSError * _Nonnull error);


@interface Manager : NSObject

+ (instancetype)sharedManger;
- (void)NetWorkTestWithData:(TestSucceedBlock) succeedBlock error:(ErrorBlock) errorBlock;
- (void)NetWorkBeforeWithData:(NSString *)a and:(TestSucceedBlock)succeedBlock error:(ErrorBlock) errorBlock;
- (void)NetWorkLongCommentWithData:(NSString *)a and:(TestLongCommentSucceedBlock)succeedBlock error:(ErrorBlock) errorBlock;
- (void)NetWorkShortCommentWithData:(NSString *)a and:(TestLongCommentSucceedBlock)succeedBlock error:(ErrorBlock) errorBlock;
- (void)NetWorkWebPageExtraWithData:(NSString *)a and:(TestWebPageExtraSucceedBlock)succeedBlock error:(ErrorBlock) errorBlock;
@end

NS_ASSUME_NONNULL_END
