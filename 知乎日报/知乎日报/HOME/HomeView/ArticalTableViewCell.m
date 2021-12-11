//
//  ArticalTableViewCell.m
//  知乎日报
//
//  Created by mac on 2021/10/21.
//  Copyright © 2021 mac. All rights reserved.
//

#import "ArticalTableViewCell.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation ArticalTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ([self.reuseIdentifier isEqualToString:@"articalCell"]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _bigTitleLabel = [[UILabel alloc] init];
        _bigTitleLabel.textAlignment = NSTextAlignmentLeft;
        _bigTitleLabel.textColor = [UIColor blackColor];
        _bigTitleLabel.numberOfLines = 2;
        [_bigTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        [self.contentView addSubview:_bigTitleLabel];
        
        _smallTitleLabel = [[UILabel alloc] init];
        _smallTitleLabel.textAlignment = NSTextAlignmentLeft;
        _smallTitleLabel.textColor = [UIColor grayColor];
        _smallTitleLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_smallTitleLabel];
  
        _articalImageView = [[UIImageView alloc] init];
        [_articalImageView.layer setMasksToBounds:YES];
        [_articalImageView.layer setCornerRadius:4];
        [self.contentView addSubview:_articalImageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [_bigTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@15);
        make.left.equalTo(@20);
        make.width.equalTo(@(SIZE_WIDTH * 0.65));
        make.height.equalTo(@70);
    }];
    
    [_smallTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_bigTitleLabel.mas_bottom).offset(6);
        make.left.equalTo(@20);
        make.width.equalTo(@(SIZE_WIDTH * 0.7));
        make.height.equalTo(@20);
    }];
    
    [_articalImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@20);
        make.left.equalTo(@(SIZE_WIDTH * 0.75));
        make.width.equalTo(@(SIZE_WIDTH * 0.21));
        make.height.equalTo(@(SIZE_WIDTH * 0.21));
    }];
    
}

@end
