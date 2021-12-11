//
//  HomeModel.m
//  知乎日报
//
//  Created by mac on 2021/10/20.
//  Copyright © 2021 mac. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation StoriesModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation Top_StoriesModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end



