//
//  HomeView.m
//  知乎日报
//
//  Created by mac on 2021/10/20.
//  Copyright © 2021 mac. All rights reserved.
//
#import "HomeView.h"
#import "Masonry.h"
#import "PersonalViewController.h"
#import "ArticalTableViewCell.h"
#import "TimeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WebKit/WebKit.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation HomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];

    _viewModelBeforeArray = [[NSMutableArray alloc] init];
    _viewModelBeforeTimeArray = [[NSMutableArray alloc] init];
    _beforeCellNumber = 0;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //下面是单独获取每项的值
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSArray* monthArray = [[NSArray alloc] init];
    monthArray = [NSArray arrayWithObjects:@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", nil];
    //月
    NSInteger month = [comps month];
    //日
    NSInteger day = [comps day];
    
    _dayLabel = [[UILabel alloc] init];
    _dayLabel.text = [NSString stringWithFormat:@"%ld",(long)day];
    [_dayLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    _dayLabel.textColor = [UIColor blackColor];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_dayLabel];
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@50);
        make.left.equalTo(@10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    _monthLabel = [[UILabel alloc] init];
    _monthLabel.text = monthArray[month - 1];
    [_monthLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    _monthLabel.textColor = [UIColor blackColor];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    _monthLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_monthLabel];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@75);
        make.left.equalTo(@10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@48);
        make.left.equalTo(@70);
        make.width.equalTo(@0.8);
        make.height.equalTo(@50);
    }];
    
    _reminderLabel = [[UILabel alloc] init];
    _reminderLabel.text = @"知乎日报";
    [_reminderLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:31]];
    _reminderLabel.textColor = [UIColor blackColor];
    _reminderLabel.backgroundColor = [UIColor clearColor];
    _reminderLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_reminderLabel];
    [_reminderLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@55);
        make.left.equalTo(@87);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
    
    _personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_personalButton setImage:[UIImage imageNamed:@"pic5.jpg"] forState:UIControlStateNormal];
    [_personalButton.layer setMasksToBounds:YES];
    [_personalButton.layer setCornerRadius:23.0];
    [self addSubview:_personalButton];
    [_personalButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@50);
        make.left.equalTo(@350);
        make.width.equalTo(@46);
        make.height.equalTo(@46);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:)name:@"tongzhi" object:nil];
    return self;
}

- (void)addView {
    _homeTableView = [[UITableView alloc] init];
    _homeTableView.backgroundColor = [UIColor whiteColor];
    _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _homeTableView.tag = 334;
    _homeTableView.bounces = NO;
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
    [_homeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"normalHome"];
    [_homeTableView registerClass:[ArticalTableViewCell class]
           forCellReuseIdentifier:@"articalCell"];
    [_homeTableView registerClass:[TimeTableViewCell class] forCellReuseIdentifier:@"timeCell"];
    [_homeTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"blankCell"];
    [self addSubview:_homeTableView];
    [_homeTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(@110);
        make.left.equalTo(@0);
        make.width.equalTo(@SIZE_WIDTH);
        make.height.equalTo(@(SIZE_HEIGHT - 110));
    }];
    
    _homeScrollView = [[UIScrollView alloc] init];
    _homeScrollView.backgroundColor = [UIColor whiteColor];
    _homeScrollView.contentSize = CGSizeMake(SIZE_WIDTH * 7, 400);
    _homeScrollView.pagingEnabled = YES;
    _homeScrollView.showsHorizontalScrollIndicator = NO;
    _homeScrollView.bounces = NO;
    _homeScrollView.tag = 333;
    _homeScrollView.delegate = self;
    _homeScrollView.contentOffset = CGPointMake(SIZE_WIDTH, 0);
    [self addSubview:_homeScrollView];
    
    for (int j = 0, i = 4, k = 0; j < 2; j++) {
        if (j == 1) {
            i = 0;
            k = 6;
        }
        NSString* homeScrollImageName = _viewModelDictionary[@"top_stories"][i][@"image"];
        NSURL *imageUrl = [NSURL URLWithString:homeScrollImageName];
        UIImage *homeScrollImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        UIImageView* homeScrollImageView = [[UIImageView alloc] initWithImage:homeScrollImage];
        //设置imageView的点击事件
        homeScrollImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [homeScrollImageView addGestureRecognizer:singleTap];
        [_homeScrollView addSubview:homeScrollImageView];
        [homeScrollImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@0);
            make.left.equalTo(@(k * SIZE_WIDTH));
            make.width.equalTo(@SIZE_WIDTH);
            make.height.equalTo(@400);
        }];
        
        UIImageView* imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake(0, 200, SIZE_WIDTH, 200);
        [homeScrollImageView addSubview:imageview];
        [self gradientView:imageview :homeScrollImage];
        
        UILabel* homeScrollBigLabel = [[UILabel alloc] init];
        homeScrollBigLabel.text = _viewModelDictionary[@"top_stories"][i][@"title"];
        [homeScrollBigLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:26]];
        homeScrollBigLabel.textColor = [UIColor whiteColor];
        homeScrollBigLabel.textAlignment = NSTextAlignmentLeft;
        homeScrollBigLabel.lineBreakMode = NSLineBreakByCharWrapping;
        homeScrollBigLabel.numberOfLines = 2;
        homeScrollBigLabel.backgroundColor = [UIColor clearColor];
        CGFloat homeScrollBigLabelWidth = [(NSString *)homeScrollBigLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:homeScrollBigLabel.font.pointSize]} context:nil].size.width;
        int lineNumber = homeScrollBigLabelWidth / (SIZE_WIDTH - 60) + 1;
        [_homeScrollView addSubview:homeScrollBigLabel];
        [homeScrollBigLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@(340 - lineNumber * 30));
            make.left.equalTo(@(k * SIZE_WIDTH + 20));
            make.width.equalTo(@(SIZE_WIDTH - 60));
            make.height.equalTo(@(lineNumber * 30));
        }];
        
        UILabel* homeScrollSmallLabel = [[UILabel alloc] init];
        homeScrollSmallLabel.text = _viewModelDictionary[@"top_stories"][i][@"hint"];
        [homeScrollSmallLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        homeScrollSmallLabel.backgroundColor = [UIColor clearColor];
        homeScrollSmallLabel.textAlignment = NSTextAlignmentLeft;
        homeScrollSmallLabel.lineBreakMode = NSLineBreakByCharWrapping;
        homeScrollSmallLabel.numberOfLines = 0;
        homeScrollSmallLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        [_homeScrollView addSubview:homeScrollSmallLabel];
        [homeScrollSmallLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@355);
            make.left.equalTo(@(k * SIZE_WIDTH + 20));
            make.width.equalTo(@(SIZE_WIDTH - 60));
            make.height.equalTo(@20);
        }];
    }
    
    for (int i = 0; i < 5; i++) {
        NSString* homeScrollImageName = _viewModelDictionary[@"top_stories"][i][@"image"];
        NSURL *imageUrl = [NSURL URLWithString:homeScrollImageName];
        UIImage *homeScrollImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        UIImageView* homeScrollImageView = [[UIImageView alloc] initWithImage:homeScrollImage];
        homeScrollImageView.tag = 1001 + i;
        //设置imageView的点击事件
        homeScrollImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [homeScrollImageView addGestureRecognizer:singleTap];
        [_homeScrollView addSubview:homeScrollImageView];
        [homeScrollImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@0);
            make.left.equalTo(@((i + 1) * SIZE_WIDTH));
            make.width.equalTo(@SIZE_WIDTH);
            make.height.equalTo(@400);
        }];
        
        UIImageView* imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake(0, 200, SIZE_WIDTH, 200);
        [homeScrollImageView addSubview:imageview];
        [self gradientView:imageview :homeScrollImage];
        
        UILabel* homeScrollBigLabel = [[UILabel alloc] init];
        homeScrollBigLabel.text = _viewModelDictionary[@"top_stories"][i][@"title"];
        [homeScrollBigLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:26]];
        homeScrollBigLabel.textColor = [UIColor whiteColor];
        homeScrollBigLabel.textAlignment = NSTextAlignmentLeft;
        homeScrollBigLabel.lineBreakMode = NSLineBreakByCharWrapping;
        homeScrollBigLabel.numberOfLines = 0;
        homeScrollBigLabel.backgroundColor = [UIColor clearColor];
        CGFloat homeScrollBigLabelWidth = [(NSString *)homeScrollBigLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:homeScrollBigLabel.font.pointSize]} context:nil].size.width;
        int lineNumber = homeScrollBigLabelWidth / (SIZE_WIDTH - 60) + 1;
        [_homeScrollView addSubview:homeScrollBigLabel];
        [homeScrollBigLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@(340 - lineNumber * 30));
            make.left.equalTo(@((i + 1) * SIZE_WIDTH + 20));
            make.width.equalTo(@(SIZE_WIDTH - 60));
            make.height.equalTo(@(lineNumber * 30));
        }];
        
        UILabel* homeScrollSmallLabel = [[UILabel alloc] init];
        homeScrollSmallLabel.text = _viewModelDictionary[@"top_stories"][i][@"hint"];
        [homeScrollSmallLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        homeScrollSmallLabel.backgroundColor = [UIColor clearColor];
        homeScrollSmallLabel.textAlignment = NSTextAlignmentLeft;
        homeScrollSmallLabel.lineBreakMode = NSLineBreakByCharWrapping;
        homeScrollSmallLabel.numberOfLines = 0;
        homeScrollSmallLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        [_homeScrollView addSubview:homeScrollSmallLabel];
        [homeScrollSmallLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@355);
            make.left.equalTo(@((i + 1) * SIZE_WIDTH + 20));
            make.width.equalTo(@(SIZE_WIDTH - 60));
            make.height.equalTo(@20);
        }];
    }
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:0];
    _pageControl.numberOfPages = 5;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleLarge)];
    //设置小菊花的frame
    self.activityIndicator.frame = CGRectMake(SIZE_WIDTH / 2, 20, 15, 15);
    //设置小菊花颜色
    self.activityIndicator.color = [UIColor blackColor];
    //设置背景颜色
    self.activityIndicator.backgroundColor = [UIColor clearColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.activityIndicator.hidesWhenStopped = YES;
    
}
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 6;
    } else if (section == 2) {
        return _beforeCellNumber;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 400;
    } else if (indexPath.section == 1) {
        return 135;
    } else if (indexPath.section == 2) {
        if (indexPath.row % 7 == 0) {
            return 44;
        } else {
            return 135;
        }
    } else {
        return 40;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell* normalCell = [_homeTableView dequeueReusableCellWithIdentifier:@"normalHome" forIndexPath:indexPath];
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [normalCell addSubview:_homeScrollView];
        [normalCell addSubview:_pageControl];
        
        [_homeScrollView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(@SIZE_WIDTH);
            make.height.equalTo(@400);
        }];
        
        [_pageControl mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(@375);
            make.left.equalTo(@(SIZE_WIDTH - (SIZE_WIDTH / 5) - 20));
            make.width.equalTo(@(SIZE_WIDTH / 5));
            make.height.equalTo(@20);
        }];
        return normalCell;
    } else if (indexPath.section == 1) {
        ArticalTableViewCell* articalCell = [_homeTableView dequeueReusableCellWithIdentifier:@"articalCell" forIndexPath:indexPath];
        articalCell.bigTitleLabel.text = _viewModelDictionary[@"stories"][indexPath.row][@"title"];
        articalCell.smallTitleLabel.text = _viewModelDictionary[@"stories"][indexPath.row][@"hint"];
        [articalCell.articalImageView sd_setImageWithURL:_viewModelDictionary[@"stories"][indexPath.row][@"images"][0] placeholderImage:[UIImage imageNamed:@"grayPic.jpg"]];

        return articalCell;
    } else if (indexPath.section == 2) {
        if (indexPath.row % 7 == 0) {
            TimeTableViewCell* timeCell = [_homeTableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
            timeCell.timeLabel.text = _viewModelBeforeTimeArray[indexPath.row / 7];
            return timeCell;
        } else {
            ArticalTableViewCell* articalCell = [_homeTableView dequeueReusableCellWithIdentifier:@"articalCell" forIndexPath:indexPath];
            articalCell.bigTitleLabel.text = _viewModelBeforeArray[indexPath.row / 7][@"stories"][indexPath.row % 7 - 1][@"title"];
            articalCell.smallTitleLabel.text = _viewModelBeforeArray[indexPath.row / 7][@"stories"][indexPath.row % 7 - 1][@"hint"];
            [articalCell.articalImageView sd_setImageWithURL:_viewModelBeforeArray[indexPath.row / 7][@"stories"][indexPath.row % 7 - 1][@"images"][0] placeholderImage:[UIImage imageNamed:@"grayPic.jpg"]];
            
            return articalCell;
        }
    } else {
        UITableViewCell* blankCell = [_homeTableView dequeueReusableCellWithIdentifier:@"blankCell" forIndexPath:indexPath];
        blankCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.activityIndicator startAnimating];
        [blankCell.contentView addSubview:_activityIndicator];
        return blankCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSString* cellNumber = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSArray* flagArray = [NSArray arrayWithObjects:@"cell", cellNumber, nil];
        NSNotification* didSelectedNoti = [NSNotification notificationWithName:@"didSelectCell" object:flagArray userInfo:_viewModelDictionary[@"stories"][indexPath.row]];
        [[NSNotificationCenter defaultCenter] postNotification:didSelectedNoti];
    } else if (indexPath.section == 2 && indexPath.row != 0) {
        NSString* cellNumber = [NSString stringWithFormat:@"%ld",(long)(indexPath.row % 7) + (indexPath.row / 7 * 6) + 5];
        NSLog(@"%@",cellNumber);
        NSArray* flagArray = [NSArray arrayWithObjects:@"cell", cellNumber, nil];
        NSNotification* didSelectedNoti = [NSNotification notificationWithName:@"didSelectCell" object:flagArray userInfo:_viewModelBeforeArray[indexPath.row / 7][@"stories"][indexPath.row % 7 - 1]];
        [[NSNotificationCenter defaultCenter] postNotification:didSelectedNoti];
    }
}

- (void)onClickImage:(UITapGestureRecognizer*) tapRecognizer {
    NSString* imageNumber = [NSString stringWithFormat:@"%ld",[tapRecognizer.view tag] - 1001];
    NSArray* flagArray = [NSArray arrayWithObjects:@"topImage", imageNumber, nil];
    NSNotification* didSelectedNoti = [NSNotification notificationWithName:@"didSelectCell" object:flagArray userInfo:_viewModelDictionary[@"top_stories"][[tapRecognizer.view tag] - 1001]];
   [[NSNotificationCenter defaultCenter] postNotification:didSelectedNoti];
}

- (void)tongzhi:(NSNotification *)text {
    _viewModelDictionary = [text.userInfo copy];
    NSLog(@"－－－－－接收到通知------");
    [self addView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:self];
}


- (void)addCell {
    NSNotification* reloadBeforeNotification = [NSNotification notificationWithName:@"reloadBefore" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:reloadBeforeNotification];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.tag == 334) {
        [_scrollViewTimer invalidate];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _scrollViewTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(autoRepeat) userInfo:nil repeats:YES];
    if (scrollView.tag == 334 && decelerate == NO && _addCellFlag == NO) {
        if (scrollView.contentOffset.y + SIZE_HEIGHT - 110 >= scrollView.contentSize.height) {
            _addCellFlag = YES;
            [self addCell];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 334 && _addCellFlag == NO) {
        if (scrollView.contentOffset.y + SIZE_HEIGHT - 110 >= scrollView.contentSize.height) {
            _addCellFlag = YES;
            [self addCell];
        }
    }
}

- (void)autoRepeat {
    if (_homeScrollView.contentOffset.x == [UIScreen mainScreen].bounds.size.width * 6.5) {
        _homeScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    } else {
        CGFloat offsetX = _homeScrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width;
        [_homeScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}


- (UIColor*)mostColor:(UIImage*) Image{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(Image.size.width / 10, Image.size.height / 10);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                        thumbSize.width,
                                        thumbSize.height,
                                        8,//bits per component
                                        thumbSize.width * 4,
                                        colorSpace,
                                        bitmapInfo);
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, Image.CGImage);
    CGColorSpaceRelease(colorSpace);
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL) {
        return nil;
    }
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width * thumbSize.height];
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height * 0.5; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha =  data[offset + 3];
            if (red > 240 || green > 240 || blue > 240) {
                
            } else if (alpha <= 0) {
                
            } else {
                NSArray *clr = @[@(red), @(green), @(blue), @(alpha)];
                [cls addObject:clr];
            }
            
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ( (curColor = [enumerator nextObject]) != nil ) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount=tmpCount;
        MaxColor=curColor;
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];

}

- (void)gradientView:(UIView *)theView :(UIImage*) Image {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = theView.bounds;
    gradient.colors = [NSMutableArray arrayWithObjects:
                       (id)[UIColor clearColor].CGColor,
                       (id)[self mostColor:Image].CGColor,
                       (id)[self mostColor:Image].CGColor,
                       nil];
    //（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    gradient.startPoint = CGPointMake(0.5, 0.0);
    //（1，1）表示到右下角变化结束。默认值是(0.5,1.0)表示从x轴为中间，y为低端的结束变化
    gradient.endPoint = CGPointMake(0.5, 1.0);
    [theView.layer insertSublayer:gradient atIndex:0];
}


@end
