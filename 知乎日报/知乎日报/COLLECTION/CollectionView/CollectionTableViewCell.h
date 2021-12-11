//
//  CollectionTableViewCell.h
//  知乎日报
//
//  Created by mac on 2021/11/14.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel* articalTitleLabel;
@property (nonatomic, strong) UILabel* lineLabel;
@property (nonatomic, strong) UIImageView* articalImageView;


@end

NS_ASSUME_NONNULL_END
