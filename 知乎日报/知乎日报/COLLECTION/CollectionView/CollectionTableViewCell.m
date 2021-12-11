//
//  CollectionTableViewCell.m
//  知乎日报
//
//  Created by mac on 2021/11/14.
//  Copyright © 2021 mac. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation CollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ([self.reuseIdentifier isEqualToString:@"collectionCell"]) {
        _articalTitleLabel = [[UILabel alloc] init];
        _articalTitleLabel.numberOfLines = 2;
        _articalTitleLabel.textAlignment = NSTextAlignmentLeft;
        _articalTitleLabel.textColor = [UIColor blackColor];
        [_articalTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        [self.contentView addSubview:_articalTitleLabel];
        
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_lineLabel];
        
        _articalImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_articalImageView];
        [_articalImageView.layer setMasksToBounds:YES];
        [_articalImageView.layer setCornerRadius:2];
        
        [_articalTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(@20);
            make.width.equalTo(@(SIZE_WIDTH * 0.7));
        }];
        
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(@0);
            make.width.equalTo(@SIZE_WIDTH);
            make.height.equalTo(@0.2);
        }];
        
        [_articalImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@15);
            make.right.equalTo(@(-15));
            make.width.equalTo(@(SIZE_WIDTH * 0.19));
            make.height.equalTo(@(SIZE_WIDTH * 0.19));
        }];
        
//        [_articalImageView mas_makeConstraints:^(MASConstraintMaker* make) {
//            make.top.equalTo(self.contentView.mas_top).offset(20);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(20);
//            make.right.equalTo(self.contentView.mas_right).offset(20);
//            double cont = make.width;
//            make.height.equalTo(@(SIZE_WIDTH * 0.21));
//        }];
    }
    return self;
}

@end
