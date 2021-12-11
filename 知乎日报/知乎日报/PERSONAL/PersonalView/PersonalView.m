//
//  PersonalView.m
//  知乎日报
//
//  Created by mac on 2021/10/27.
//  Copyright © 2021 mac. All rights reserved.
//

#import "PersonalView.h"
#import "Masonry.h"
#import "CollectionViewController.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation PersonalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@50);
        make.left.equalTo(@20);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.image = [UIImage imageNamed:@"pic5.jpg"];
    [_headImageView.layer setMasksToBounds:YES];
    [_headImageView.layer setCornerRadius:50];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"kochunk1t";
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    
    _personalTableView = [[UITableView alloc] init];
    _personalTableView.backgroundColor = [UIColor grayColor];
    _personalTableView.scrollEnabled = NO;
    _personalTableView.delegate = self;
    _personalTableView.dataSource = self;
    [_personalTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalPersonalHead"];
    [_personalTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalPersonal"];
    [self addSubview:_personalTableView];
    [_personalTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@110);
        make.left.equalTo(@0);
        make.width.equalTo(@SIZE_WIDTH);
        make.height.equalTo(@350);
    }];
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 210;
    } else return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell* personalNormalHeadCell = [_personalTableView dequeueReusableCellWithIdentifier:@"normalPersonalHead" forIndexPath:indexPath];
        personalNormalHeadCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [personalNormalHeadCell addSubview:_headImageView];
        [personalNormalHeadCell addSubview:_nameLabel];
        
        [_headImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@0);
            make.left.equalTo(@((SIZE_WIDTH - 100) / 2));
            make.width.equalTo(@100);
            make.height.equalTo(@100);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@120);
            make.left.equalTo(@0);
            make.width.equalTo(@SIZE_WIDTH);
            make.height.equalTo(@40);
        }];
        
        return personalNormalHeadCell;
    }
    UITableViewCell* personalNormalCell = [_personalTableView dequeueReusableCellWithIdentifier:@"normalPersonal" forIndexPath:indexPath];
    personalNormalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    personalNormalCell.textLabel.font = [UIFont systemFontOfSize:18];
    if (indexPath.row == 0) {
        personalNormalCell.textLabel.text = @"我的收藏";
    } else {
        personalNormalCell.textLabel.text = @"消息中心";
    }
    personalNormalCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return personalNormalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSNotification* didSelectedCollectionNoti = [NSNotification notificationWithName:@"didSelectCollectionCell" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:didSelectedCollectionNoti];
    }
}

@end
