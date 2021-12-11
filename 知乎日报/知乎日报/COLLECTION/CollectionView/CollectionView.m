//
//  CollectionView.m
//  知乎日报
//
//  Created by mac on 2021/11/11.
//  Copyright © 2021 mac. All rights reserved.
//

#import "CollectionView.h"
#import "Masonry.h"
#import "CollectionTableViewCell.h"
#import "UIImageView+WebCache.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation CollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    _webPageIDArray = [[NSMutableArray alloc] init];
    _webPageTitleArray = [[NSMutableArray alloc] init];
    _webPageImageURLArray = [[NSMutableArray alloc] init];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@50);
        make.left.equalTo(@20);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"收藏";
    [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_backButton.mas_top);
        make.left.equalTo(@(SIZE_WIDTH * 0.1));
        make.right.equalTo(@(-SIZE_WIDTH * 0.1));
        make.bottom.equalTo(_backButton.mas_bottom);
    }];
    
    return self;
}

- (void)addTableView {
    _collectionTableView = [[UITableView alloc] init];
    _collectionTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _collectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _collectionTableView.delegate = self;
    _collectionTableView.dataSource = self;
    _collectionTableView.bounces = NO;
    [_collectionTableView registerClass:[CollectionTableViewCell class]
    forCellReuseIdentifier:@"collectionCell"];
    [_collectionTableView registerClass:[UITableViewCell class]
    forCellReuseIdentifier:@"normalCell"];
    [_collectionTableView registerClass:[UITableViewCell class]
    forCellReuseIdentifier:@"blankCell"];
    [self addSubview:_collectionTableView];
    [_collectionTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@(SIZE_HEIGHT * 0.1));
        make.left.equalTo(@0);
        make.width.equalTo(@SIZE_WIDTH);
        make.height.equalTo(@(SIZE_HEIGHT * 0.9));
    }];
    
    _lastLabel = [[UILabel alloc] init];
    _lastLabel.text = @"没有更多内容";
    _lastLabel.textColor = [UIColor grayColor];
    _lastLabel.font = [UIFont systemFontOfSize:18];
    _lastLabel.textAlignment = NSTextAlignmentCenter;
    
    _blankLabel = [[UILabel alloc] init];
    _blankLabel.text = @"你还没有收藏喔 ～";
    _blankLabel.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    _blankLabel.textColor = [UIColor grayColor];
    _blankLabel.font = [UIFont systemFontOfSize:22];
    _blankLabel.textAlignment = NSTextAlignmentCenter;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_webPageIDArray.count == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_webPageIDArray.count == 0) {
        return 1;
    } else {
        if (section == 0) {
            return _webPageIDArray.count;
        } else {
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_webPageIDArray.count == 0) {
        return SIZE_HEIGHT * 0.9;
    } else {
        if (indexPath.section == 0) {
            return 110;
        } else {
            return 80;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_webPageIDArray.count == 0) {
        UITableViewCell* blankCell = [_collectionTableView dequeueReusableCellWithIdentifier:@"blankCell" forIndexPath:indexPath];
        [blankCell.contentView addSubview:_blankLabel];
        [_blankLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@(0));
            make.left.equalTo(@0);
            make.width.equalTo(@SIZE_WIDTH);
            make.bottom.equalTo(@0);
        }];
        return blankCell;
    } else {
        if (indexPath.section == 0) {
            CollectionTableViewCell* collectionCell = [_collectionTableView dequeueReusableCellWithIdentifier:@"collectionCell" forIndexPath:indexPath];
            collectionCell.articalTitleLabel.text = _webPageTitleArray[indexPath.row];
            [collectionCell.articalImageView sd_setImageWithURL:_webPageImageURLArray[indexPath.row] placeholderImage:[UIImage imageNamed:@"grayPic.jpg"]];
            return collectionCell;
        } else {
            UITableViewCell* normalCell = [_collectionTableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
            normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
            normalCell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];;
            [normalCell addSubview:_lastLabel];
            [_lastLabel mas_makeConstraints:^(MASConstraintMaker* make) {
                make.top.equalTo(@0);
                make.left.equalTo(@0);
                make.width.equalTo(@SIZE_WIDTH);
                make.bottom.equalTo(@0);
            }];
            return normalCell;
        }
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_webPageIDArray.count != 0 && indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_webPageIDArray.count != 0) {
        if (indexPath.section == 0) {
            NSNotification* deleteSelectCellNotification = [NSNotification notificationWithName:@"deleteSelectCell" object:[NSString stringWithFormat:@"%ld",indexPath.row] userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:deleteSelectCellNotification];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_webPageIDArray.count != 0 && indexPath.section == 0) {
        NSNotification* collectionSelectCellNotification = [NSNotification notificationWithName:@"collectionSelectCell" object:[NSString stringWithFormat:@"%ld",indexPath.row] userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:collectionSelectCellNotification];
    }
}

@end
