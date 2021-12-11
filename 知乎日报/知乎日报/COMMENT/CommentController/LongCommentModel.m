//
//  LongCommentModel.m
//  知乎日报
//
//  Created by mac on 2021/11/6.
//  Copyright © 2021 mac. All rights reserved.
//

#import "LongCommentModel.h"

@implementation LongModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation ShortReplyModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation LongCommentModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
