//
//  PersonalViewController.m
//  知乎日报
//
//  Created by mac on 2021/10/27.
//  Copyright © 2021 mac. All rights reserved.
//

#import "PersonalViewController.h"
#import "CollectionViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _personalView = [[PersonalView alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectCollectionCell:) name:@"didSelectCollectionCell" object:nil];
    _personalView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [_personalView.backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_personalView];
}

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectCollectionCell: (NSNotification *)noti {
    CollectionViewController* collectionViewController = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:collectionViewController animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectCollectionCell" object:self];
}
@end
