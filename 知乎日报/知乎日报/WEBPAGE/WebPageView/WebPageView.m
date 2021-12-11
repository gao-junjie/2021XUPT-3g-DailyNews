//
//  WebPageView.m
//  知乎日报
//
//  Created by mac on 2021/10/31.
//  Copyright © 2021 mac. All rights reserved.
//

#import "WebPageView.h"
#import "WebKit/WebKit.h"
#import "Masonry.h"
#define SIZE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation WebPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    _URLArray = [[NSMutableArray alloc] init];
    _topURLArray = [[NSMutableArray alloc] init];
    _IDArray = [[NSMutableArray alloc] init];
    _topIDArray = [[NSMutableArray alloc] init];
    
    _webPageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT * 0.88)];
    _webPageScrollView.backgroundColor = [UIColor whiteColor];
    _webPageScrollView.pagingEnabled = YES;
    _webPageScrollView.tag = 666;
    _webPageScrollView.showsHorizontalScrollIndicator = NO;
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setImage:[UIImage imageNamed:@"daipingjia.png"] forState:UIControlStateNormal];
    [self addSubview:_commentButton];
    [_commentButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(@(- SIZE_HEIGHT * 0.03));
        make.left.equalTo(@(100));
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    
    _supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_supportButton setImage:[UIImage imageNamed:@"dianzan.png"] forState:UIControlStateNormal];
    [_supportButton setImage:[UIImage imageNamed:@"dianzan-2.png"] forState:UIControlStateSelected];
    [self addSubview:_supportButton];
    [_supportButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(@(- SIZE_HEIGHT * 0.03));
        make.left.equalTo(@((SIZE_WIDTH - 60) / 4 + 100));
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectionButton setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
    [_collectionButton setImage:[UIImage imageNamed:@"shoucang-2.png"] forState:UIControlStateSelected];
    [self addSubview:_collectionButton];
    [_collectionButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(@(- SIZE_HEIGHT * 0.03));
        make.left.equalTo(@((SIZE_WIDTH - 60) / 4 * 2 + 100));
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton setImage:[UIImage imageNamed:@"fenxiang.png"] forState:UIControlStateNormal];
    [self addSubview:_shareButton];
    [_shareButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(@(- SIZE_HEIGHT * 0.03));
        make.left.equalTo(@((SIZE_WIDTH - 60) / 4 * 3 + 100));
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    _commentNumberLabel = [[UILabel alloc] init];
    _commentNumberLabel.textColor = [UIColor blackColor];
    _commentNumberLabel.textAlignment = NSTextAlignmentLeft;
    _commentNumberLabel.font = [UIFont systemFontOfSize:15];
    _commentNumberLabel.text = @"0";
    [self addSubview:_commentNumberLabel];
    [_commentNumberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_commentButton.imageView.mas_top);
        make.left.equalTo(_commentButton.mas_right).offset(4);
        make.width.equalTo(@80);
        make.height.equalTo(@10);
    }];
    
    _supportNumberLabel = [[UILabel alloc] init];
    _supportNumberLabel.textColor = [UIColor blackColor];
    _supportNumberLabel.textAlignment = NSTextAlignmentLeft;
    _supportNumberLabel.font = [UIFont systemFontOfSize:15];
    _supportNumberLabel.text = @"0";
    [self addSubview:_supportNumberLabel];
    [_supportNumberLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_supportButton.imageView.mas_top);
        make.left.equalTo(_supportButton.mas_right).offset(4);
        make.width.equalTo(@80);
        make.height.equalTo(@10);
    }];
    
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor grayColor];
    [self addSubview:_lineLabel];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(@(- SIZE_HEIGHT * 0.026));
        make.left.equalTo(@70);
        make.width.equalTo(@0.5);
        make.height.equalTo(@36);
    }];
    
    _alreadyCollectionLabel = [[UILabel alloc] init];
    _alreadyCollectionLabel.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.8];
    _alreadyCollectionLabel.font = [UIFont systemFontOfSize:18];
    _alreadyCollectionLabel.text = @"已收藏";
    _alreadyCollectionLabel.textColor = [UIColor blackColor];
    _alreadyCollectionLabel.textAlignment = NSTextAlignmentCenter;
    [_alreadyCollectionLabel.layer setMasksToBounds:YES];
    [_alreadyCollectionLabel.layer setCornerRadius:SIZE_WIDTH * 0.08];
    _alreadyCollectionLabel.hidden = YES;
    [self addSubview:_alreadyCollectionLabel];
    [_alreadyCollectionLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self.mas_bottom).offset(-SIZE_HEIGHT * 0.1);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(SIZE_WIDTH * 0.3));
        make.height.equalTo(@(SIZE_HEIGHT * 0.08));
    }];
    
    _cancelCollectionLabel = [[UILabel alloc] init];
    _cancelCollectionLabel.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.8];
    _cancelCollectionLabel.font = [UIFont systemFontOfSize:18];
    _cancelCollectionLabel.text = @"已取消收藏";
    _cancelCollectionLabel.textColor = [UIColor blackColor];
    _cancelCollectionLabel.textAlignment = NSTextAlignmentCenter;
    [_cancelCollectionLabel.layer setMasksToBounds:YES];
    [_cancelCollectionLabel.layer setCornerRadius:SIZE_WIDTH * 0.08];
    _cancelCollectionLabel.hidden = YES;
    [self addSubview:_cancelCollectionLabel];
    [_cancelCollectionLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self.mas_bottom).offset(-SIZE_HEIGHT * 0.1);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(SIZE_WIDTH * 0.4));
        make.height.equalTo(@(SIZE_HEIGHT * 0.08));
    }];

    
    return self;
}

- (void)addView {
    if ([_webPageFlag isEqualToString:@"topImage"]) {
        _webPageScrollView.contentSize = CGSizeMake(SIZE_WIDTH * _topIDArray.count, 0);
    } else {
        _webPageScrollView.contentSize = CGSizeMake(SIZE_WIDTH * _IDArray.count, 0);
    }
    WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectMake(SIZE_WIDTH * _pageNumber, 0, SIZE_WIDTH, SIZE_HEIGHT * 0.88)];
    [_webPageScrollView addSubview:webView];
    NSURL *url = [NSURL URLWithString:_webPageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    _webPageScrollView.contentOffset = CGPointMake(SIZE_WIDTH * _pageNumber, 0);
    [self addSubview:_webPageScrollView];

    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    [self addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(@(- SIZE_HEIGHT * 0.03));
        make.left.equalTo(@20);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];

 
}



@end
