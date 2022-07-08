//
//  UIImage+DNIconfontHelper.h
//  dnovel
//
//  Created by user on 2020/2/4.
//  Copyright © 2020 blox. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define DNIconInfoMake(text, imageSize, imageColor) [DNInconfontInfo iconInfoWithText:text size:imageSize color:imageColor]

@interface UIImage (DNIconfontHelper)

+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color inset:(UIEdgeInsets)insets backgroundColor:(nullable UIColor*)backgroundColor;
+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(nullable UIColor*)color;

+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(nullable UIColor*)color padding:(CGFloat)paddingPercent;

+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(nullable UIColor*)color inset:(UIEdgeInsets)inset;

+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(nullable UIColor*)color backgroundColor:(nullable UIColor*)backgroundColor;
+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(nullable UIColor*)color padding:(CGFloat)paddingPercent backgroundColor:(nullable UIColor*)backgroundColor;

@end

NS_ASSUME_NONNULL_END
