//
//  CommentView.h
//  知乎日报
//
//  Created by mac on 2021/11/4.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UILabel* lineLabel;
@property (nonatomic, strong) UILabel* commentNumberLabel;
@property (nonatomic, strong) UITableView* commentTableView;
@property (nonatomic, strong) UIView* myCommentView;
@property (nonatomic, strong) UIImageView* myCommentHeadPhoto;
@property (nonatomic, strong) UILabel* hiddenLabel;
@property (nonatomic, strong) NSDictionary* longCommentDictionary;
@property (nonatomic, strong) NSDictionary* shortCommentDictionary;
@property (nonatomic, strong) UILabel* cellLongNumberLabel;
@property (nonatomic, strong) UILabel* cellShortNumberLabel;
@property (nonatomic, strong) UILabel* blankLabel;
@property (nonatomic, strong) UIButton* foldButton;
@property (nonatomic, strong) NSMutableArray* longCommentButtonIsOnArray;
@property (nonatomic, strong) NSMutableArray* shortCommentButtonIsOnArray;


- (void)addView;

@end

NS_ASSUME_NONNULL_END
