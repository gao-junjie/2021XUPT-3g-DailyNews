//
//  HomeModel.h
//  知乎日报
//
//  Created by mac on 2021/10/20.
//  Copyright © 2021 mac. All rights reserved.
//

@protocol StoriesModel
@end

@protocol Top_StoriesModel
@end

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoriesModel : JSONModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSString *hint;
@property (nonatomic, copy) NSString *image_hue;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *id;
@end

@interface Top_StoriesModel : JSONModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *hint;
@property (nonatomic, copy) NSString *image_hue;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *id;
@end

@interface HomeModel : JSONModel
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSArray<StoriesModel> *stories;
@property (nonatomic, copy) NSArray<Top_StoriesModel> *top_stories;
@end

NS_ASSUME_NONNULL_END
