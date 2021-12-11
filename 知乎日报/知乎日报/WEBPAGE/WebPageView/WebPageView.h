//
//  WebPageView.h
//  知乎日报
//
//  Created by mac on 2021/10/31.
//  Copyright © 2021 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebPageView : UIView
@property (nonatomic, strong) NSString *webPageURL;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *supportButton;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, strong) UILabel *supportNumberLabel;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UIScrollView* webPageScrollView;
@property (nonatomic, strong) NSString* webPageFlag;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, strong) NSMutableArray* topURLArray;
@property (nonatomic, strong) NSMutableArray* URLArray;
@property (nonatomic, strong) NSMutableArray* topIDArray;
@property (nonatomic, strong) NSMutableArray* IDArray;
@property (nonatomic, strong) UILabel* alreadyCollectionLabel;
@property (nonatomic, strong) UILabel* cancelCollectionLabel;

- (void)addView;
@end

NS_ASSUME_NONNULL_END
