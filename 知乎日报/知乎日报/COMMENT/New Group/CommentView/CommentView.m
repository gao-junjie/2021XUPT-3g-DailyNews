//
//  CommentView.m
//  知乎日报
//
//  Created by mac on 2021/11/4.
//  Copyright © 2021 mac. All rights reserved.
//

#import "CommentView.h"
#import "Masonry.h"
#import "LongCommentTableViewCell.h"
#import "ReplyCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation CommentView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    _longCommentDictionary = [[NSDictionary alloc] init];
    _shortCommentDictionary = [[NSDictionary alloc] init];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@15);
        make.left.equalTo(@20);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];

    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor grayColor];
    [self addSubview:_lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_backButton.mas_bottom).offset(15);
        make.left.equalTo(@0);
        make.width.equalTo(@SIZE_WIDTH);
        make.height.equalTo(@0.2);
    }];

    _commentTableView = [[UITableView alloc] init];
    _commentTableView.backgroundColor = [UIColor whiteColor];
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    // 步骤1：
    _commentTableView.rowHeight = UITableViewAutomaticDimension;
    // 步骤2：
    _commentTableView.estimatedRowHeight = 100.0;
    [_commentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"longNumberCell"];
    [_commentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"shortNumberCell"];
    [_commentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"blankCell"];
    [_commentTableView registerClass:[LongCommentTableViewCell class] forCellReuseIdentifier:@"longCommentCell"];
    [_commentTableView registerClass:[ReplyCommentTableViewCell class] forCellReuseIdentifier:@"replyCommentCell"];
    [_commentTableView registerClass:[ReplyCommentTableViewCell class] forCellReuseIdentifier:@"shortReplyCommentCell"];
    [self addSubview:_commentTableView];
    [_commentTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_lineLabel);
        make.left.equalTo(@0);
        make.width.equalTo(@SIZE_WIDTH);
        make.height.equalTo(@(SIZE_HEIGHT * 0.82));
    }];
    
    _myCommentView = [[UIView alloc] init];
    _myCommentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressMyCommentView)];
    [_myCommentView addGestureRecognizer:tapGesture];
    [self addSubview:_myCommentView];
    [_myCommentView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_commentTableView.mas_bottom);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@SIZE_WIDTH);
    }];

    _myCommentHeadPhoto = [[UIImageView alloc] init];
    [_myCommentHeadPhoto setImage:[UIImage imageNamed:@"pic5.jpg"]];
    _myCommentHeadPhoto.layer.masksToBounds = YES;
    [_myCommentHeadPhoto.layer setCornerRadius:20];
    [_myCommentView addSubview:_myCommentHeadPhoto];
    [_myCommentHeadPhoto mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@13);
        make.left.equalTo(@20);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];

    _hiddenLabel = [[UILabel alloc] init];
    _hiddenLabel.textColor = [UIColor grayColor];
    _hiddenLabel.text = @"说说你的看法...";
    _hiddenLabel.font = [UIFont systemFontOfSize:18];
    [_myCommentView addSubview:_hiddenLabel];
    [_hiddenLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@20);
        make.left.equalTo(_myCommentHeadPhoto.mas_right).offset(10);
        make.height.equalTo(@30);
        make.width.equalTo(@200);
    }];

    return self;
}

- (void)addView {
    [_commentTableView reloadData];
    
    _commentNumberLabel = [[UILabel alloc] init];
    _commentNumberLabel.text = [NSString stringWithFormat:@"%lu 条评论",[_shortCommentDictionary[@"comments"] count] + [_longCommentDictionary[@"comments"] count]];
    _commentNumberLabel.textColor = [UIColor blackColor];
    _commentNumberLabel.textAlignment = NSTextAlignmentCenter;
    [_commentNumberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:22]];
    [self addSubview:_commentNumberLabel];
    [_commentNumberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_backButton).offset(-9);
        make.left.equalTo(@0);
        make.width.equalTo(@SIZE_WIDTH);
        make.height.equalTo(@40);
    }];
    
    _cellLongNumberLabel = [[UILabel alloc] init];
    _cellLongNumberLabel.textColor = [UIColor blackColor];
    _cellLongNumberLabel.textAlignment = NSTextAlignmentLeft;
    _cellLongNumberLabel.text = [NSString stringWithFormat:@"%lu 条长评",(unsigned long)[_longCommentDictionary[@"comments"] count]];
    [_cellLongNumberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    
    _cellShortNumberLabel = [[UILabel alloc] init];
    _cellShortNumberLabel.textColor = [UIColor blackColor];
    _cellShortNumberLabel.textAlignment = NSTextAlignmentLeft;
    _cellShortNumberLabel.text = [NSString stringWithFormat:@"%lu 条短评",(unsigned long)[_shortCommentDictionary[@"comments"] count]];
    [_cellShortNumberLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    
    _blankLabel = [[UILabel alloc] init];
    _blankLabel.textColor = [UIColor grayColor];
    _blankLabel.textAlignment = NSTextAlignmentCenter;
    _blankLabel.text = @"已显示全部评论";
    _blankLabel.font = [UIFont systemFontOfSize:19];
    
    _foldButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_foldButton setTitle:@"展开全文" forState:UIControlStateNormal];
    [_foldButton setTitle:@"收起" forState:UIControlStateSelected];
    [_foldButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    _longCommentButtonIsOnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_longCommentDictionary[@"comments"] count]; i++) {
        [_longCommentButtonIsOnArray addObject:@"0"];
    }
    _shortCommentButtonIsOnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [_shortCommentDictionary[@"comments"] count]; i++) {
        [_shortCommentButtonIsOnArray addObject:@"0"];
    }
}

- (void)pressMyCommentView {
    NSLog(@"发表我的评论");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([_longCommentDictionary[@"comments"] count] > 0) {
            return 1;
        } else {
            return 0;
        }
    } else if (section == 1) {
        return [_longCommentDictionary[@"comments"] count];
    } else if (section == 2) {
        if ([_shortCommentDictionary[@"comments"] count] > 0) {
            return 1;
        } else {
            return 0;
        }
    } else if (section == 3) {
        return [_shortCommentDictionary[@"comments"] count];
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0) {
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 70;
    } else if (indexPath.section == 4) {
        return 110;
    } else {
        return 150;
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        if (indexPath.section == 0) {
            UITableViewCell* numberCell = [_commentTableView dequeueReusableCellWithIdentifier:@"longNumberCell" forIndexPath:indexPath];
            numberCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [numberCell.contentView addSubview:_cellLongNumberLabel];
            [_cellLongNumberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
                make.top.equalTo(@10);
                make.left.equalTo(@20);
                make.width.equalTo(@SIZE_WIDTH);
                make.height.equalTo(@40);
            }];
            return numberCell;
        } else {
            UITableViewCell* numberCell = [_commentTableView dequeueReusableCellWithIdentifier:@"shortNumberCell" forIndexPath:indexPath];
            numberCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [numberCell.contentView addSubview:_cellShortNumberLabel];
            [_cellShortNumberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
                make.top.equalTo(@10);
                make.left.equalTo(@20);
                make.width.equalTo(@SIZE_WIDTH);
                make.height.equalTo(@40);
            }];
            return numberCell;
        }
    } else if (indexPath.section == 1) {
        if (_longCommentDictionary[@"comments"][indexPath.row][@"reply_to"] != nil) {
            ReplyCommentTableViewCell* longReplyCommentCell = [_commentTableView dequeueReusableCellWithIdentifier:@"replyCommentCell" forIndexPath:indexPath];
            [longReplyCommentCell.commentHeadPhotoImageView sd_setImageWithURL:_longCommentDictionary[@"comments"][indexPath.row][@"avatar"] placeholderImage:[UIImage imageNamed:@"grayPic.jpg"]];
            longReplyCommentCell.timeLabel.text = [self getNewDate:_longCommentDictionary[@"comments"][indexPath.row][@"time"]];
            longReplyCommentCell.nameLabel.text = _longCommentDictionary[@"comments"][indexPath.row][@"author"];
            longReplyCommentCell.contentLabel.text = _longCommentDictionary[@"comments"][indexPath.row][@"content"];
            longReplyCommentCell.replyLabel.text = [NSString stringWithFormat:@"// %@：%@", _longCommentDictionary[@"comments"][indexPath.row][@"reply_to"][@"author"], _longCommentDictionary[@"comments"][indexPath.row][@"reply_to"][@"content"]];
            [longReplyCommentCell.dianzanButton setTitle:_longCommentDictionary[@"comments"][indexPath.row][@"likes"] forState:UIControlStateNormal];
            longReplyCommentCell.foldButton.selected = [_longCommentButtonIsOnArray[indexPath.row] intValue];
            NSInteger count = [self textHeightFromTextString:longReplyCommentCell.replyLabel.text width:(SIZE_WIDTH - 20) - (SIZE_WIDTH * 0.11 + 20 + 14) fontSize:17].height / longReplyCommentCell.replyLabel.font.lineHeight;
            if (count <= 2) {
                longReplyCommentCell.foldButton.hidden = YES;
            } else {
                longReplyCommentCell.foldButton.hidden = NO;
                longReplyCommentCell.foldButton.tag = 1000 * indexPath.section + indexPath.row;
                longReplyCommentCell.replyLabel.tag = (1000 * indexPath.section + indexPath.row) * 10;
                [longReplyCommentCell.foldButton addTarget:self action:@selector(pressLongFoldButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            return longReplyCommentCell;
        } else {
            LongCommentTableViewCell* longCommentCell = [_commentTableView dequeueReusableCellWithIdentifier:@"longCommentCell" forIndexPath:indexPath];
            [longCommentCell.commentHeadPhotoImageView sd_setImageWithURL:_longCommentDictionary[@"comments"][indexPath.row][@"avatar"] placeholderImage:[UIImage imageNamed:@"grayPic.jpg"]];
            longCommentCell.nameLabel.text = _longCommentDictionary[@"comments"][indexPath.row][@"author"];
            longCommentCell.timeLabel.text = [self getNewDate:_longCommentDictionary[@"comments"][indexPath.row][@"time"]];
            longCommentCell.contentLabel.text = _longCommentDictionary[@"comments"][indexPath.row][@"content"];
            [longCommentCell.dianzanButton setTitle:_longCommentDictionary[@"comments"][indexPath.row][@"likes"] forState:UIControlStateNormal];
            return longCommentCell;
        }
    } else if (indexPath.section == 3) {
        if (_shortCommentDictionary[@"comments"][indexPath.row][@"reply_to"] != nil) {
            ReplyCommentTableViewCell* shortReplyCommentCell = [_commentTableView dequeueReusableCellWithIdentifier:@"shortReplyCommentCell" forIndexPath:indexPath];
            [shortReplyCommentCell.commentHeadPhotoImageView sd_setImageWithURL:_shortCommentDictionary[@"comments"][indexPath.row][@"avatar"] placeholderImage:[UIImage imageNamed:@"grayPic.jpg"]];
            shortReplyCommentCell.timeLabel.text = [self getNewDate:_shortCommentDictionary[@"comments"][indexPath.row][@"time"]];
            shortReplyCommentCell.nameLabel.text = _shortCommentDictionary[@"comments"][indexPath.row][@"author"];
            shortReplyCommentCell.contentLabel.text = _shortCommentDictionary[@"comments"][indexPath.row][@"content"];
            shortReplyCommentCell.replyLabel.text = [NSString stringWithFormat:@"// %@：%@", _shortCommentDictionary[@"comments"][indexPath.row][@"reply_to"][@"author"], _shortCommentDictionary[@"comments"][indexPath.row][@"reply_to"][@"content"]];
            [shortReplyCommentCell.dianzanButton setTitle:_shortCommentDictionary[@"comments"][indexPath.row][@"likes"] forState:UIControlStateNormal];
            shortReplyCommentCell.foldButton.selected = [_shortCommentButtonIsOnArray[indexPath.row] intValue];
            NSInteger count = [self textHeightFromTextString:shortReplyCommentCell.replyLabel.text width:(SIZE_WIDTH - 20) - (SIZE_WIDTH * 0.11 + 20 + 14) fontSize:17].height / shortReplyCommentCell.replyLabel.font.lineHeight;
            if (count <= 2) {
                shortReplyCommentCell.foldButton.hidden = YES;
            } else {
                shortReplyCommentCell.foldButton.hidden = NO;
                shortReplyCommentCell.foldButton.tag = 1000 * indexPath.section + indexPath.row;
                shortReplyCommentCell.replyLabel.tag = (1000 * indexPath.section + indexPath.row) * 10;
                [shortReplyCommentCell.foldButton addTarget:self action:@selector(pressShortFoldButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            return shortReplyCommentCell;
        } else {
            LongCommentTableViewCell* shortCommentCell = [_commentTableView dequeueReusableCellWithIdentifier:@"longCommentCell" forIndexPath:indexPath];
            [shortCommentCell.commentHeadPhotoImageView sd_setImageWithURL:_shortCommentDictionary[@"comments"][indexPath.row][@"avatar"] placeholderImage:[UIImage imageNamed:@"grayPic.jpg"]];
            shortCommentCell.timeLabel.text = [self getNewDate:_shortCommentDictionary[@"comments"][indexPath.row][@"time"]];
            shortCommentCell.nameLabel.text = _shortCommentDictionary[@"comments"][indexPath.row][@"author"];
            shortCommentCell.contentLabel.text = _shortCommentDictionary[@"comments"][indexPath.row][@"content"];
            [shortCommentCell.dianzanButton setTitle:_shortCommentDictionary[@"comments"][indexPath.row][@"likes"] forState:UIControlStateNormal];
            return shortCommentCell;
        }
    } else {
        UITableViewCell* blankCell = [_commentTableView dequeueReusableCellWithIdentifier:@"blankCell" forIndexPath:indexPath];
        blankCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [blankCell.contentView addSubview:_blankLabel];
        [_blankLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@40);
            make.left.equalTo(@0);
            make.width.equalTo(@SIZE_WIDTH);
            make.bottom.equalTo(@-40);
        }];
        return blankCell;
    }
    
}

//更改时间戳
- (NSString *)getNewDate:(NSString *)dateStr{
    NSTimeInterval time = [dateStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
       
    NSString* timeString = [dateFormatter stringFromDate: detaildate];

    return timeString;
}

//返回行数
- (NSInteger)needLinesWithWidth:(UILabel*)label {
    NSString * text = label.text;
    NSInteger sum = 0;
    CGFloat width = (SIZE_WIDTH - 20) - (SIZE_WIDTH * 0.11 + 20 + 14);
    //总行数受换行符影响，所以这里计算总行数，需要用换行符分隔这段文字，然后计算每段文字的行数，相加即是总行数。
    NSArray * splitText = [text componentsSeparatedByString:@"\n"];
    for (NSString * sText in splitText) {
        text = sText;
        //获取这段文字一行需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        //size.width/所需要的width 向上取整就是这段文字占的行数
        NSInteger lines = ceilf(textSize.width / width);
        //当是0的时候，说明这是换行，需要按一行算。
        lines = lines == 0?1:lines;
        sum += lines;
    }
    return sum;
}

-(CGSize)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size {
    //计算 label需要的宽度和高度
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    CGSize size1 = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]}];
    return CGSizeMake(size1.width, rect.size.height);
    
}

- (void)pressLongFoldButton:(UIButton*) button {
    UILabel* sendLabel = [self viewWithTag:button.tag * 10];
    if (button.selected == NO) {
        button.selected = YES;
        [_longCommentButtonIsOnArray replaceObjectAtIndex:button.tag - 1000 withObject:@"1"];
        sendLabel.numberOfLines = 0;
    } else {
        button.selected = NO;
        [_longCommentButtonIsOnArray replaceObjectAtIndex:button.tag - 1000 withObject:@"0"];
        sendLabel.numberOfLines = 2;
    }
    [_commentTableView reloadData];
}

- (void)pressShortFoldButton:(UIButton*) button {
    UILabel* sendLabel = [self viewWithTag:button.tag * 10];
    if (button.selected == NO) {
        button.selected = YES;
        [_shortCommentButtonIsOnArray replaceObjectAtIndex:button.tag - 3000 withObject:@"1"];
        sendLabel.numberOfLines = 0;
    } else {
        button.selected = NO;
        [_shortCommentButtonIsOnArray replaceObjectAtIndex:button.tag - 3000 withObject:@"0"];
        sendLabel.numberOfLines = 2;
    }
    [_commentTableView reloadData];
}

@end
