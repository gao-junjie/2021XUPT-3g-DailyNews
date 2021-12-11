//
//  WebPageModel.h
//  知乎日报
//
//  Created by mac on 2021/11/11.
//  Copyright © 2021 mac. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebPageModel : JSONModel
@property (nonatomic, strong) NSString* comments;
@property (nonatomic, strong) NSString* popularity;

@end

NS_ASSUME_NONNULL_END
