//
//  WebPageViewController.m
//  知乎日报
//
//  Created by mac on 2021/10/31.
//  Copyright © 2021 mac. All rights reserved.
//

#import "WebPageViewController.h"
#import "WebKit/WebKit.h"
#import "Manager.h"
#import "CommentViewController.h"
#import "CommentView.h"
#import "Manager.h"
#import "FMDB.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface WebPageViewController ()

@end

@implementation WebPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createDataBase];
    
    _webPageView = [[WebPageView alloc] initWithFrame:CGRectMake(0, SIZE_HEIGHT * 0.04, SIZE_WIDTH, SIZE_HEIGHT * 0.96)];
    _webPageView.webPageURL = _webPageURL;
    _webPageView.webPageFlag = _webPageFlag;
    _webPageView.topURLArray = _topURLArray;
    _webPageView.URLArray = _URLArray;
    _webPageView.topIDArray = _topIDArray;
    _webPageView.IDArray = _IDArray;
    _webPageView.pageNumber = _pageNumber;
    [self searchCollectionButtonSelected];
    [self getWebPageExtra];
    [_webPageView addView];
    _webPageView.webPageScrollView.delegate = self;
    [_webPageView.backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [_webPageView.collectionButton addTarget:self action:@selector(pressCollectionButton) forControlEvents:UIControlEventTouchUpInside];
    [_webPageView.supportButton addTarget:self action:@selector(pressSupportButton) forControlEvents:UIControlEventTouchUpInside];
    [_webPageView.commentButton addTarget:self action:@selector(pressCommentButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_webPageView];
    
}

- (void)getWebPageExtra {
    [[Manager sharedManger] NetWorkWebPageExtraWithData:_webPageID and:^(WebPageModel * _Nonnull ViewModel) {
        NSLog(@"请求成功");
        self.webPageExtraDictionary = [[NSDictionary alloc] init];
        self.webPageExtraDictionary = [ViewModel toDictionary];
        // 异步执行任务创建方法
        dispatch_async(dispatch_get_main_queue(), ^{
            self.webPageView.commentNumberLabel.text = self.webPageExtraDictionary[@"comments"];
            self.webPageView.supportNumberLabel.text = self.webPageExtraDictionary[@"popularity"];
        });
    } error:^(NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];

}

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 666) {
        CGFloat offsetX = _webPageView.webPageScrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width * 0.5;
        int page = offsetX / [UIScreen mainScreen].bounds.size.width;
        if (page != _pageNumber && _nextPageFlag == NO) {
            _pageNumber = page;
            WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectMake(SIZE_WIDTH * _pageNumber, 0, SIZE_WIDTH, SIZE_HEIGHT * 0.88)];
            [_webPageView.webPageScrollView addSubview:webView];
            _webPageView.supportButton.selected = NO;
            _webPageView.supportNumberLabel.textColor = [UIColor blackColor];
            NSURL *url;
            if ([_webPageFlag isEqualToString:@"topImage"] && _pageNumber < _topIDArray.count) {
                _webPageID = _topIDArray[_pageNumber];
                [self getWebPageExtra];
                //url = [NSURL URLWithString:_webPageView.topURLArray[_pageNumber]];
                url = [NSURL URLWithString:[NSString stringWithFormat:@"https://daily.zhihu.com/story/%@",_webPageView.topIDArray[_pageNumber]]];
            } else {
                _webPageID = _IDArray[_pageNumber];
                [self getWebPageExtra];
                //url = [NSURL URLWithString:_webPageView.URLArray[_pageNumber]];
                url = [NSURL URLWithString:[NSString stringWithFormat:@"https://daily.zhihu.com/story/%@",_webPageView.IDArray[_pageNumber]]];
            }
            [self searchCollectionButtonSelected];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [webView loadRequest:request];
        }
        if (offsetX  + [UIScreen mainScreen].bounds.size.width * 0.3 > _webPageView.webPageScrollView.contentSize.width && ![_webPageFlag isEqualToString:@"topImage"]) {
            _nextPageFlag = YES;
            double offContentSizeX = _webPageView.webPageScrollView.contentSize.width;
            NSString* offContentSizeXString = [NSString stringWithFormat:@"%f",offContentSizeX];
            NSNotification* reloadBeforeNotification = [NSNotification notificationWithName:@"reloadBefore" object:offContentSizeXString userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:reloadBeforeNotification];
        }
    }
}

- (void)pressSupportButton {
    if (_webPageView.supportButton.selected == NO) {
        _webPageView.supportButton.selected = YES;
        _webPageView.supportNumberLabel.textColor = [UIColor colorWithRed:0 green:0.4 blue:0.4 alpha:1];
        int supportNumber = [_webPageView.supportNumberLabel.text intValue] + 1;
        _webPageView.supportNumberLabel.text = [NSString stringWithFormat:@"%d",supportNumber];
    } else {
        _webPageView.supportButton.selected = NO;
        _webPageView.supportNumberLabel.textColor = [UIColor blackColor];
        int supportNumber = [_webPageView.supportNumberLabel.text intValue] - 1;
        _webPageView.supportNumberLabel.text = [NSString stringWithFormat:@"%d",supportNumber];
    }
}

- (void)pressCollectionButton {
    if (_webPageView.collectionButton.selected == NO) {
        // 打开数据库
        if ([_dataBase open]) {
            // 写入数据 - 不确定的参数用？来占位
            BOOL result = [_dataBase executeUpdate:@"INSERT INTO t_ZhiHuRiBao (webPageID,webPageTitle,webPageImageURL) VALUES (?, ?, ?);", _webPageID, _webPageTitleArray[_pageNumber], _webPageImageURLArray[_pageNumber]];
            if (!result) {
                NSLog(@"增加数据失败");
            } else {
                NSLog(@"增加数据成功");
                _webPageView.collectionButton.selected = YES;
                _webPageView.cancelCollectionLabel.hidden = YES;
                _webPageView.alreadyCollectionLabel.hidden = NO;
                _webPageView.cancelCollectionLabel.hidden = YES;
                [_webPageView bringSubviewToFront:_webPageView.alreadyCollectionLabel];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(PressCollectionTimer) userInfo:nil repeats:NO];
            }
        } else {
            NSLog(@"fail to open database");
        }
    } else {
        if ([_dataBase open]) {
            _webPageView.collectionButton.selected = NO;
            // 删除数据
            NSString *sql = @"delete from t_ZhiHuRiBao where (webPageID) = (?) and (webPageTitle) = (?) and (webPageImageURL) = (?)";
            BOOL result = [_dataBase executeUpdate:sql, [NSString stringWithFormat:@"%@",_webPageID], [NSString stringWithFormat:@"%@",_webPageTitleArray[_pageNumber]],[NSString stringWithFormat:@"%@",_webPageImageURLArray[_pageNumber]]];

            if (!result) {
                NSLog(@"数据删除失败");
            } else {
                NSLog(@"数据删除成功");
                _webPageView.collectionButton.selected = NO;
                _webPageView.alreadyCollectionLabel.hidden = YES;
                _webPageView.cancelCollectionLabel.hidden = NO;
                [_webPageView bringSubviewToFront:_webPageView.cancelCollectionLabel];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(PressCancelCollectionTimer) userInfo:nil repeats:NO];
            }
        } else {
            NSLog(@"fail to open database");
        }
    }
    FMResultSet * resultSet = [_dataBase executeQuery:@"select * from t_ZhiHuRiBao"];
    //遍历查询
    while ([resultSet next]) {
        NSString *name1 = [resultSet objectForColumn:@"webPageID"];
        NSString *name2 = [resultSet objectForColumn:@"webPageTitle"];
        NSString *name3 = [resultSet objectForColumn:@"webPageImageURL"];
        NSLog(@"webPageID：%@ %@ %@", name1,name2,name3);
    }
    [_dataBase close];
}

- (void)pressCommentButton {
    _commentViewController = [[CommentViewController alloc] init];
    if ([_webPageFlag isEqualToString:@"topImage"]) {
        _commentViewController.commentID = _topIDArray[_pageNumber];
    } else {
        _commentViewController.commentID = _IDArray[_pageNumber];
    }
    [self.navigationController pushViewController:_commentViewController animated:YES];
}

- (void)createDataBase {
    // 获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"ZhiHuRiBao.sqlite"];
    _dataBase = [FMDatabase databaseWithPath:path];
}

//获取该文章是否被收藏并改变收藏button的状态
- (void)searchCollectionButtonSelected {
    bool CollectionButtonSelectedFlag = NO;
    [_dataBase open];
    FMResultSet * resultSet = [_dataBase executeQuery:@"select * from t_ZhiHuRiBao"];
    //遍历查询
    while ([resultSet next]) {
        NSString* webPageIDInSQL = [NSString stringWithFormat:@"%@",[resultSet objectForColumn:@"webPageID"]];
        NSLog(@"webPageID：%@", webPageIDInSQL);
        if ([webPageIDInSQL isEqualToString:_webPageID]) {
            CollectionButtonSelectedFlag = YES;
            break;
        }
    }
    if (CollectionButtonSelectedFlag == YES) {
        _webPageView.collectionButton.selected = YES;
    } else {
        _webPageView.collectionButton.selected = NO;
    }
    [_dataBase close];
}

- (void)PressCollectionTimer {
    _webPageView.alreadyCollectionLabel.hidden = YES;
}

- (void)PressCancelCollectionTimer {
    _webPageView.cancelCollectionLabel.hidden = YES;
}

@end
