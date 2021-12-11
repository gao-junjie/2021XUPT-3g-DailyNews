//
//  CollectionViewController.m
//  知乎日报
//
//  Created by mac on 2021/11/11.
//  Copyright © 2021 mac. All rights reserved.
//

#import "CollectionViewController.h"
#import "WebPageViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataBase];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSelectCell:) name:@"deleteSelectCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionSelectCell:) name:@"collectionSelectCell" object:nil];
    _collectionView = [[CollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [_collectionView.backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self searchNumberInFMDB];
    [self.view addSubview:_collectionView];
}

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createDataBase {
    // 获取数据库文件的路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"ZhiHuRiBao.sqlite"];
    _dataBase = [FMDatabase databaseWithPath:path];
}

- (void)searchNumberInFMDB {
    [_dataBase open];
    //遍历查询
    FMResultSet* resultSet = [_dataBase executeQuery:@"select * from t_ZhiHuRiBao"];
    while ([resultSet next]) {
        NSString* tempWebPageID = [resultSet objectForColumn:@"webPageID"];
        NSString* tempWebPageTitle = [resultSet objectForColumn:@"webPageTitle"];
        NSString* tempWebPageImageURL = [resultSet objectForColumn:@"webPageImageURL"];
        [_collectionView.webPageIDArray addObject:tempWebPageID];
        [_collectionView.webPageTitleArray addObject:tempWebPageTitle];
        [_collectionView.webPageImageURLArray addObject:tempWebPageImageURL];
    }
    [_collectionView addTableView];
    [_dataBase close];
}

- (void)deleteSelectCell: (NSNotification *)noti {
    if ([_dataBase open]) {
       //  删除数据
        NSString *sql = @"delete from t_ZhiHuRiBao where (webPageID) = (?) and (webPageTitle) = (?) and (webPageImageURL) = (?)";
        BOOL result = [_dataBase executeUpdate:sql, _collectionView.webPageIDArray[[noti.object intValue]], _collectionView.webPageTitleArray[[noti.object intValue]],_collectionView.webPageImageURLArray[[noti.object intValue]]];
        if (!result) {
            NSLog(@"数据删除失败");
        } else {
            [_collectionView.webPageIDArray removeObjectAtIndex:[noti.object intValue]];
            [_collectionView.webPageTitleArray removeObjectAtIndex:[noti.object intValue]];
            [_collectionView.webPageImageURLArray removeObjectAtIndex:[noti.object intValue]];
        }
    } else {
        NSLog(@"fail to open database");
    }
    [_dataBase close];
    [_collectionView.collectionTableView reloadData];
}

- (void)collectionSelectCell: (NSNotification *)noti {
    _webPageViewController = [[WebPageViewController alloc] init];
    _webPageViewController.webPageURL = [NSString stringWithFormat:@"https://daily.zhihu.com/story/%@",_collectionView.webPageIDArray[[noti.object intValue]]];
    _webPageViewController.webPageTitleArray = _collectionView.webPageTitleArray;
    _webPageViewController.webPageImageURLArray = _collectionView.webPageImageURLArray;
    _webPageViewController.topIDArray = _collectionView.webPageIDArray;
    _webPageViewController.webPageID = _collectionView.webPageIDArray[[noti.object intValue]];
    _webPageViewController.webPageFlag = @"topImage";
    _webPageViewController.pageNumber = [noti.object intValue];
    [self.navigationController pushViewController:_webPageViewController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [_dataBase open];
    _collectionView.webPageIDArray = [[NSMutableArray alloc] init];
    _collectionView.webPageTitleArray = [[NSMutableArray alloc] init];
    _collectionView.webPageImageURLArray = [[NSMutableArray alloc] init];
    //遍历查询
    FMResultSet* resultSet = [_dataBase executeQuery:@"select * from t_ZhiHuRiBao"];
    while ([resultSet next]) {
        NSString* tempWebPageID = [resultSet objectForColumn:@"webPageID"];
        NSString* tempWebPageTitle = [resultSet objectForColumn:@"webPageTitle"];
        NSString* tempWebPageImageURL = [resultSet objectForColumn:@"webPageImageURL"];
        [_collectionView.webPageIDArray addObject:tempWebPageID];
        [_collectionView.webPageTitleArray addObject:tempWebPageTitle];
        [_collectionView.webPageImageURLArray addObject:tempWebPageImageURL];
    }
    [_dataBase close];
    [_collectionView.collectionTableView reloadData];
}

@end
