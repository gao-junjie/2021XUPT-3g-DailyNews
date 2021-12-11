//
//  HomeViewController.m
//  知乎日报
//
//  Created by mac on 2021/10/20.
//  Copyright © 2021 mac. All rights reserved.
//

#import "HomeViewController.h"
#import "Manager.h"
#import "PersonalViewController.h"
#import "WebPageViewController.h"
#import "FMDB.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCell:) name:@"didSelectCell" object:nil];
    [self createDataBase];
    _currentDate = [NSDate date];
    _formatter = [[NSDateFormatter alloc] init];
    _timeFormatter= [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyyMMdd"];
    _modelBeforeDateString = [self.formatter stringFromDate:_currentDate];
    
    _modelDictionary = [[NSDictionary alloc] init];
    _topURLArray = [[NSMutableArray alloc] init];
    _URLArray = [[NSMutableArray alloc] init];
    _topIDArray = [[NSMutableArray alloc] init];
    _IDArray = [[NSMutableArray alloc] init];
    _pageTitleArray = [[NSMutableArray alloc] init];
    _pageImageURLArray = [[NSMutableArray alloc] init];
    _topPageTitleArray = [[NSMutableArray alloc] init];
    _topPageImageURLArray = [[NSMutableArray alloc] init];
    [self getFirstModel];
}

- (void)initHomeView {
    //通过通知中心发送通知
    NSNotification *notification = [NSNotification notificationWithName:@"tongzhi" object:nil userInfo:_modelDictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBeforeMessage:) name:@"reloadBefore" object:nil];
    _homeView = [[HomeView alloc] init];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    _homeView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_homeView.personalButton addTarget:self action:@selector(pressPersonalButton) forControlEvents:UIControlEventTouchUpInside];
    _homeView.homeScrollView.delegate = self;
    _homeView.scrollViewTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(autoRepeat) userInfo:nil repeats:YES];
    [self.view addSubview:_homeView];
}

- (void)getFirstModel {
    [[Manager sharedManger] NetWorkTestWithData:^(HomeModel * _Nonnull ViewModel) {
        NSLog(@"请求成功");
        self->_modelDictionary = [ViewModel toDictionary];
        for (int i = 0; i < 5; i++) {
            [self->_topURLArray addObject:self.modelDictionary[@"top_stories"][i][@"url"]];
            [self->_topIDArray addObject:self.modelDictionary[@"top_stories"][i][@"id"]];
            [self.topPageTitleArray addObject:self.modelDictionary[@"top_stories"][i][@"title"]];
            [self.topPageImageURLArray addObject:self.modelDictionary[@"top_stories"][i][@"image"]];
        }
        for (int i = 0; i < 6; i++) {
            [self.URLArray addObject:self.modelDictionary[@"stories"][i][@"url"]];
            [self.IDArray addObject:self.modelDictionary[@"stories"][i][@"id"]];
            [self.pageTitleArray addObject:self.modelDictionary[@"stories"][i][@"title"]];
            [self.pageImageURLArray addObject:self.modelDictionary[@"stories"][i][@"images"][0]];
        }
        // 异步执行任务创建方法
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initHomeView];
        });
        } error:^(NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
}

- (void)getBeforeModel {
    [[Manager sharedManger] NetWorkBeforeWithData:_modelBeforeDateString and:^(HomeModel * _Nonnull ViewModel) {
        NSLog(@"请求成功");
        self->_modelBeforeDictionary = [[NSDictionary alloc] init];
        self->_modelBeforeDictionary = [ViewModel toDictionary];
        for (int i = 0; i < [self.modelBeforeDictionary[@"stories"] count]; i++) {
            [self.URLArray addObject:self.modelBeforeDictionary[@"stories"][i][@"url"]];
            [self.IDArray addObject:self.modelBeforeDictionary[@"stories"][i][@"id"]];
            [self.pageTitleArray addObject:self.modelBeforeDictionary[@"stories"][i][@"title"]];
            [self.pageImageURLArray addObject:self.modelBeforeDictionary[@"stories"][i][@"images"][0]];
            
        }
        [self.homeView.viewModelBeforeArray addObject:self.modelBeforeDictionary];
        if (self.addWebPageFlag == YES) {
            self.webPageViewController.URLArray = self.URLArray;
            self.webPageViewController.IDArray = self.IDArray;
            self.webPageViewController.nextPageFlag = NO;
            self.addWebPageFlag = NO;
        }
        self.currentDate = [NSDate dateWithTimeInterval:- 24 * 60 * 60 sinceDate:self.currentDate];
        self.modelBeforeDateString = [self.formatter stringFromDate:self.currentDate];
        [self.formatter setDateFormat:@"yyyyMMdd"];
        [self.timeFormatter setDateFormat:@"MM月dd日"];
        [self.homeView.viewModelBeforeTimeArray addObject:[NSString stringWithString:[self.timeFormatter stringFromDate:self.currentDate]]];
        NSLog(@"－－－－－接收到更新过往记录通知------");
        // 异步执行任务创建方法
        dispatch_async(dispatch_get_main_queue(), ^{
            self.homeView.addCellFlag = NO;
            self.homeView.beforeCellNumber += 7;
            [self.homeView.homeTableView reloadData];
        });
        } error:^(NSError * _Nonnull error) {
            NSLog(@"请求失败");
        }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 333) {
        if (scrollView.contentOffset.x == [UIScreen mainScreen].bounds.size.width * 6){
            _homeView.homeScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
        }
        if (scrollView.contentOffset.x == 0){
            _homeView.homeScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * 5, 0);
        }
        CGFloat offsetX = _homeView.homeScrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width * 0.5;
        int page = offsetX / [UIScreen mainScreen].bounds.size.width;
        if (page == 6) {
            _homeView.pageControl.currentPage = 0;
        } else if (page == 0) {
            _homeView.pageControl.currentPage = 4;
        } else {
            _homeView.pageControl.currentPage = page - 1;
        }
    }
}

- (void)autoRepeat {
    if (_homeView.homeScrollView.contentOffset.x == [UIScreen mainScreen].bounds.size.width * 6.5) {
        _homeView.homeScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    } else {
        CGFloat offsetX = _homeView.homeScrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width;
        [_homeView.homeScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.tag == 333) {
        [_homeView.scrollViewTimer invalidate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 333) {
        _homeView.scrollViewTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(autoRepeat) userInfo:nil repeats:YES];
    }
}

- (void)reloadBeforeMessage:(NSNotification *)text {
    if (text.object) {
        _addWebPageFlag = YES;
        double offContentSizeX = [text.object doubleValue];
        [self.webPageViewController.webPageView.webPageScrollView setContentSize:CGSizeMake(offContentSizeX + SIZE_WIDTH * 6, 0)];
    }
    [self getBeforeModel];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadBefore" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCell" object:self];
}


- (void)pressPersonalButton {
    _personalController = [[PersonalViewController alloc] init];
    [self.navigationController pushViewController:_personalController animated:YES];
}

- (void)didSelectCell: (NSNotification *)noti {
    _webPageViewController = [[WebPageViewController alloc] init];
    if ([noti.object[0] isEqualToString:@"cell"]) {
        _webPageViewController.webPageURL = noti.userInfo[@"url"];
        _webPageViewController.URLArray = _URLArray;
        _webPageViewController.IDArray = _IDArray;
        _webPageViewController.webPageID = _IDArray[[noti.object[1] intValue]];
        _webPageViewController.webPageTitleArray = _pageTitleArray;
        _webPageViewController.webPageImageURLArray = _pageImageURLArray;
        NSLog(@"webPageViewController.webPageURL = %@",_webPageViewController.webPageURL);
    } else {
        _webPageViewController.webPageURL = noti.userInfo[@"url"];
        _webPageViewController.topURLArray = _topURLArray;
        _webPageViewController.topIDArray = _topIDArray;
        _webPageViewController.webPageTitleArray = _topPageTitleArray;
        _webPageViewController.webPageImageURLArray = _topPageImageURLArray;
        _webPageViewController.webPageID = _topIDArray[[noti.object[1] intValue]];
    }
    _webPageViewController.webPageFlag = noti.object[0];
    _webPageViewController.pageNumber = [noti.object[1] intValue];
    [self.navigationController pushViewController:_webPageViewController animated:YES];
}

- (void)createDataBase {
    // 获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"ZhiHuRiBao.sqlite"];
    NSLog(@"path = %@",path);
    // 1..创建数据库对象
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    // 2.打开数据库
    if ([db open]) {
        BOOL result = [db executeUpdate:@"CREATE TABLE 't_ZhiHuRiBao' ('title' VARCHAR (255), 'webPageTitle' VARCHAR (255), 'webPageImageURL' VARCHAR (255))"];
        if (result) {
            NSLog(@"创表成功");
        } else {
            NSLog(@"创表失败");
        }
        NSLog(@"Open database Success");
    } else {
        NSLog(@"fail to open database");
    }
}

@end
