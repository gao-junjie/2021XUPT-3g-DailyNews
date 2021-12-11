//
//  CollectionViewController.h
//  知乎日报
//
//  Created by mac on 2021/11/11.
//  Copyright © 2021 mac. All rights reserved.
//

#import "ViewController.h"
#import "CollectionView.h"
#import "WebPageViewController.h"
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewController : ViewController
@property (nonatomic, strong) CollectionView* collectionView;
@property (nonatomic, strong) FMDatabase* dataBase;
@property (nonatomic, strong) WebPageViewController* webPageViewController;

@end

NS_ASSUME_NONNULL_END
