//
//  WebPageViewController.h
//  知乎日报
//
//  Created by mac on 2021/10/31.
//  Copyright © 2021 mac. All rights reserved.
//

#import "ViewController.h"
#import "WebPageView.h"
#import "CommentViewController.h"
#import "WebPageModel.h"
#import "FMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface WebPageViewController : ViewController <UIScrollViewDelegate>
@property (nonatomic, strong) WebPageView* webPageView;
@property (nonatomic, strong) CommentViewController* commentViewController;
@property (nonatomic, strong) NSString* webPageURL;
@property (nonatomic, strong) NSString* webPageFlag;
@property (nonatomic, strong) NSMutableArray* topURLArray;
@property (nonatomic, strong) NSMutableArray* URLArray;
@property (nonatomic, strong) NSMutableArray* topIDArray;
@property (nonatomic, strong) NSMutableArray* IDArray;
@property (nonatomic, strong) NSMutableArray* webPageTitleArray;
@property (nonatomic, strong) NSMutableArray* webPageImageURLArray;
@property (nonatomic, strong) NSMutableArray* webPageExtraArray;
@property (nonatomic, copy) NSDictionary* webPageExtraDictionary;
@property (nonatomic, strong) NSString* webPageID;
@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) BOOL nextPageFlag;
@property (nonatomic, strong) FMDatabase* dataBase;
@property (nonatomic, strong) UIAlertController* boomAlert;

@end

NS_ASSUME_NONNULL_END
