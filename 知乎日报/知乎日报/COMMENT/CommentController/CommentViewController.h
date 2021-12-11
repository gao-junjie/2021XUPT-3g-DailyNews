//
//  CommentViewController.h
//  知乎日报
//
//  Created by mac on 2021/11/4.
//  Copyright © 2021 mac. All rights reserved.
//

#import "ViewController.h"
#import "CommentView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CommentViewController : ViewController
@property (nonatomic, strong) CommentView* commentView;
@property (nonatomic, strong) NSString* commentID;
@property (nonatomic, strong) NSDictionary* longCommentModelDictionary;
@property (nonatomic, strong) NSDictionary* shortCommentModelDictionary;
@end

NS_ASSUME_NONNULL_END
