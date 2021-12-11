//
//  CollectionView.h
//  知乎日报
//
//  Created by mac on 2021/11/11.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* tipLabel;
@property (nonatomic, strong) UILabel* lastLabel;
@property (nonatomic, strong) UILabel* blankLabel;
@property (nonatomic, strong) UITableView* collectionTableView;
@property (nonatomic, strong) NSMutableArray* webPageIDArray;
@property (nonatomic, strong) NSMutableArray* webPageTitleArray;
@property (nonatomic, strong) NSMutableArray* webPageImageURLArray;

- (void)addTableView;

@end

NS_ASSUME_NONNULL_END
