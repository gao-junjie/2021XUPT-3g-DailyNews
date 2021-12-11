//
//  PersonalView.h
//  知乎日报
//
//  Created by mac on 2021/10/27.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIImageView* headImageView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UITableView* personalTableView;
@end

NS_ASSUME_NONNULL_END
