//
//  LongCommentModel.h
//  知乎日报
//
//  Created by mac on 2021/11/6.
//  Copyright © 2021 mac. All rights reserved.
//

@protocol LongModel
@end

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShortReplyModel : JSONModel
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) long status;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *author;
@end

@interface LongModel : JSONModel
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* avatar;
@property (nonatomic, strong) NSString* time;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* likes;
@property (nonatomic, strong) ShortReplyModel *reply_to;

@end

@interface LongCommentModel : JSONModel
@property (nonatomic, copy) NSArray<LongModel>* comments;
@end

NS_ASSUME_NONNULL_END
