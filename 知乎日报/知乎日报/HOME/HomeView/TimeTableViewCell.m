//
//  TimeTableViewCell.m
//  知乎日报
//
//  Created by mac on 2021/10/29.
//  Copyright © 2021 mac. All rights reserved.
//

#import "TimeTableViewCell.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation TimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ([self.reuseIdentifier isEqualToString:@"timeCell"]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [_timeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [self.contentView addSubview:_timeLabel];
        
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_lineLabel];
    
    }
    return self;
}

- (void)layoutSubviews {
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@0);
        make.left.equalTo(@20);
        make.width.equalTo(@(SIZE_WIDTH * 0.3));
        make.height.equalTo(@44);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@22);
        make.left.equalTo(@(SIZE_WIDTH * 0.25 + 10));
        make.width.equalTo(@(SIZE_WIDTH - (SIZE_WIDTH * 0.25 + 10)));
        make.height.equalTo(@0.2);
    }];
    
}

@end
