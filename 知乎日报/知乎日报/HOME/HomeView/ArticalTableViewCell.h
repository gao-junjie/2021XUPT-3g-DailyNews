//
//  ArticalTableViewCell.h
//  知乎日报
//
//  Created by mac on 2021/10/21.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArticalTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel* bigTitleLabel;
@property (nonatomic, strong) UILabel* smallTitleLabel;
@property (nonatomic, strong) UIImageView* articalImageView;

@end

NS_ASSUME_NONNULL_END
