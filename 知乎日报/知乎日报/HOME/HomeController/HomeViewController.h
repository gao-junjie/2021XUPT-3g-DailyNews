//
//  HomeViewController.h
//  知乎日报
//
//  Created by mac on 2021/10/20.
//  Copyright © 2021 mac. All rights reserved.
//

#import "ViewController.h"
#import "HomeView.h"
#import "HomeModel.h"
#import "PersonalViewController.h"
#import "WebPageViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : ViewController <UIScrollViewDelegate,UITableViewDelegate>

@property (nonatomic, strong) HomeView* homeView;
@property (nonatomic, strong) HomeModel* homeModel;
@property (nonatomic, copy) NSDictionary* modelDictionary;
@property (nonatomic, copy) NSDictionary* modelBeforeDictionary;
@property (nonatomic, copy) NSString* modelBeforeDateString;
@property (nonatomic, copy) NSDate* currentDate;
@property (nonatomic, copy) NSDateFormatter* formatter;
@property (nonatomic, copy) NSDateFormatter* timeFormatter;
@property (nonatomic, copy) NSMutableArray* topURLArray;
@property (nonatomic, copy) NSMutableArray* URLArray;
@property (nonatomic, copy) NSMutableArray* topIDArray;
@property (nonatomic, copy) NSMutableArray* IDArray;
@property (nonatomic, strong) NSMutableArray* pageTitleArray;
@property (nonatomic, strong) NSMutableArray* pageImageURLArray;
@property (nonatomic, strong) NSMutableArray* topPageTitleArray;
@property (nonatomic, strong) NSMutableArray* topPageImageURLArray;
@property (nonatomic, assign) BOOL addWebPageFlag;
@property (nonatomic, strong) PersonalViewController* personalController;
@property (nonatomic, strong) WebPageViewController* webPageViewController;
@end

NS_ASSUME_NONNULL_END
