//
//  HomeView.h
//  知乎日报
//
//  Created by mac on 2021/10/20.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeView : UIView <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView* homeTableView;
@property (nonatomic, strong) UIScrollView* homeScrollView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) UILabel* dayLabel;
@property (nonatomic, strong) UILabel* monthLabel;
@property (nonatomic, strong) UILabel* tipLabel;
@property (nonatomic, strong) UILabel* reminderLabel;
@property (nonatomic, strong) UIButton* personalButton;
@property (nonatomic, retain) NSTimer* scrollViewTimer;
@property (nonatomic, assign) NSInteger beforeCellNumber;
@property (nonatomic, copy) NSDictionary* viewModelDictionary;
@property (nonatomic, strong) NSMutableArray* viewModelBeforeArray;
@property (nonatomic, strong) NSMutableArray* viewModelBeforeTimeArray;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@property (nonatomic, assign) BOOL addCellFlag;


@end

NS_ASSUME_NONNULL_END
