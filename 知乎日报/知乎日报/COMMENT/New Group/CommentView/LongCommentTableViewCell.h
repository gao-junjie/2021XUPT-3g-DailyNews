//
//  LongCommentTableViewCell.h
//  知乎日报
//
//  Created by mac on 2021/11/8.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LongCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView* commentHeadPhotoImageView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UILabel* replyNameLabel;
@property (nonatomic, strong) UILabel* replyLabel;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UILabel* lineLabel;
@property (nonatomic, strong) UIButton* dianzanButton;
@property (nonatomic, strong) UIButton* pinglunButton;

@end

NS_ASSUME_NONNULL_END
