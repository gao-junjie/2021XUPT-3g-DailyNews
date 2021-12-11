//
//  ReplyCommentTableViewCell.m
//  知乎日报
//
//  Created by mac on 2021/11/10.
//  Copyright © 2021 mac. All rights reserved.
//

#import "ReplyCommentTableViewCell.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation ReplyCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ([self.reuseIdentifier isEqualToString:@"replyCommentCell"]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _commentHeadPhotoImageView = [[UIImageView alloc] init];
        [_commentHeadPhotoImageView.layer setMasksToBounds:YES];
        [_commentHeadPhotoImageView.layer setCornerRadius:SIZE_WIDTH * 0.055];
        [self.contentView addSubview:_commentHeadPhotoImageView];
        
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_contentLabel];
        
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.font = [UIFont systemFontOfSize:17];
        _replyLabel.textColor = [UIColor grayColor];
        _replyLabel.textAlignment = NSTextAlignmentLeft;
        _replyLabel.numberOfLines = 2;
        _replyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_replyLabel];
        
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:16];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timeLabel];
        
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_lineLabel];
        
        _dianzanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dianzanButton setImage:[UIImage imageNamed:@"dianzan-3.png"] forState:UIControlStateNormal];
        [_dianzanButton setImage:[UIImage imageNamed:@"dianzan-3.png"] forState:UIControlStateSelected];
        [_dianzanButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_dianzanButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [self.contentView addSubview:_dianzanButton];
        
        _pinglunButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pinglunButton setImage:[UIImage imageNamed:@"pinglun.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_pinglunButton];
        
        
        [_commentHeadPhotoImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@20);
            make.left.equalTo(@20);
            make.width.equalTo(@(SIZE_WIDTH * 0.11));
            make.height.equalTo(@(SIZE_WIDTH * 0.11));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_commentHeadPhotoImageView.mas_top).offset(-5);
            make.left.equalTo(_commentHeadPhotoImageView.mas_right).offset(14);
            make.width.equalTo(@(SIZE_WIDTH * 0.7));
            make.height.equalTo(@(SIZE_WIDTH * 0.1));
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_lineLabel.mas_top).offset(-10);
            make.left.equalTo(_nameLabel.mas_left);
            make.height.equalTo(@(SIZE_WIDTH * 0.1));
        }];
        
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(@0);
            make.width.equalTo(@SIZE_WIDTH);
            make.height.equalTo(@0.2);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_replyLabel.mas_top).offset(-20);
            make.top.equalTo(_nameLabel.mas_bottom).offset(10);
            make.left.equalTo(_nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
        }];
        
        [_replyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_timeLabel.mas_top).offset(-20);
            make.top.equalTo(_contentLabel.mas_bottom).offset(10).priority(500);
            make.left.equalTo(_nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
        }];

        _foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_foldButton setTitle:@"展开全文" forState:UIControlStateNormal];
        [_foldButton setTitle:@"收起" forState:UIControlStateSelected];
        _foldButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_foldButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_foldButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];

        [self.contentView addSubview:_foldButton];
        [_foldButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_timeLabel.mas_top);
            make.left.equalTo(_timeLabel.mas_right).offset(20);
            make.bottom.equalTo(_timeLabel.mas_bottom);
        }];
        
        [_dianzanButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_timeLabel.mas_bottom).offset(-8);
            make.height.equalTo(@(SIZE_WIDTH * 0.05));
            make.right.equalTo(self.contentView.mas_right).offset(-80);
            make.width.equalTo(@(SIZE_WIDTH * 0.12));
        }];
        
        [_pinglunButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_timeLabel.mas_bottom).offset(-8);
            make.height.equalTo(@(SIZE_WIDTH * 0.05));
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.width.equalTo(@(SIZE_WIDTH * 0.06));
        }];

    }
    
    if ([self.reuseIdentifier isEqualToString:@"shortReplyCommentCell"]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _commentHeadPhotoImageView = [[UIImageView alloc] init];
        [_commentHeadPhotoImageView.layer setMasksToBounds:YES];
        [_commentHeadPhotoImageView.layer setCornerRadius:SIZE_WIDTH * 0.055];
        [self.contentView addSubview:_commentHeadPhotoImageView];
        
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_contentLabel];
        
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.font = [UIFont systemFontOfSize:17];
        _replyLabel.textColor = [UIColor grayColor];
        _replyLabel.textAlignment = NSTextAlignmentLeft;
        _replyLabel.numberOfLines = 2;
        _replyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_replyLabel];
        
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:16];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timeLabel];
        
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_lineLabel];
        
        _dianzanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dianzanButton setImage:[UIImage imageNamed:@"dianzan-3.png"] forState:UIControlStateNormal];
        [_dianzanButton setImage:[UIImage imageNamed:@"dianzan-3.png"] forState:UIControlStateSelected];
        [_dianzanButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_dianzanButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [self.contentView addSubview:_dianzanButton];
        
        _pinglunButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pinglunButton setImage:[UIImage imageNamed:@"pinglun.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_pinglunButton];
        
        
        [_commentHeadPhotoImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@20);
            make.left.equalTo(@20);
            make.width.equalTo(@(SIZE_WIDTH * 0.11));
            make.height.equalTo(@(SIZE_WIDTH * 0.11));
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_commentHeadPhotoImageView.mas_top).offset(-5);
            make.left.equalTo(_commentHeadPhotoImageView.mas_right).offset(14);
            make.width.equalTo(@(SIZE_WIDTH * 0.7));
            make.height.equalTo(@(SIZE_WIDTH * 0.1));
        }];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_lineLabel.mas_top).offset(-10);
            make.left.equalTo(_nameLabel.mas_left);
            make.height.equalTo(@(SIZE_WIDTH * 0.1));
        }];
        
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.left.equalTo(@0);
            make.width.equalTo(@SIZE_WIDTH);
            make.height.equalTo(@0.2);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_replyLabel.mas_top).offset(-20);
            make.top.equalTo(_nameLabel.mas_bottom).offset(10);
            make.left.equalTo(_nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
        }];
        
        [_replyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_timeLabel.mas_top).offset(-20);
            make.top.equalTo(_contentLabel.mas_bottom).offset(10).priority(500);
            make.left.equalTo(_nameLabel.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
        }];
        
        [_dianzanButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_timeLabel.mas_bottom).offset(-8);
            make.height.equalTo(@(SIZE_WIDTH * 0.05));
            make.right.equalTo(self.contentView.mas_right).offset(-80);
            make.width.equalTo(@(SIZE_WIDTH * 0.12));
        }];
        
        [_pinglunButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(_timeLabel.mas_bottom).offset(-8);
            make.height.equalTo(@(SIZE_WIDTH * 0.05));
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.width.equalTo(@(SIZE_WIDTH * 0.06));
        }];

        _foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_foldButton setTitle:@"展开全文" forState:UIControlStateNormal];
        [_foldButton setTitle:@"收起" forState:UIControlStateSelected];
        _foldButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_foldButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_foldButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        

        [self.contentView addSubview:_foldButton];
        [_foldButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(_timeLabel.mas_top);
            make.left.equalTo(_timeLabel.mas_right).offset(20);
            make.bottom.equalTo(_timeLabel.mas_bottom);
        }];
        

    }
    return self;
}


@end
