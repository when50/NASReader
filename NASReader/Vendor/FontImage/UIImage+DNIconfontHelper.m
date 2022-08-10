//
//  UIImage+DNIconfontHelper.m
//  dnovel
//
//  Created by user on 2020/2/4.
//  Copyright © 2020 blox. All rights reserved.
//

#import "UIImage+DNIconfontHelper.h"
#import <CoreText/CoreText.h>


@interface DNIconFont : NSObject
@end

@implementation DNIconFont
static NSString * _fontName;

+ (void)setFontName:(NSString*)fontName {
    _fontName = fontName;
}

+ (NSString *)fontName {
    NSString *str = _fontName?:@"dianyueicon";
    return str;
}

+ (NSString *)fontFile {
    return @"iconfont";
}

+ (void)registerFontWithURL:(NSURL*)url {
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Font file doesn't exist");
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef         newFont          = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(newFont, nil);
    CGFontRelease(newFont);
}

+ (UIFont*)fontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:[self fontName] size:size];
    if (font == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *fontFileUrl = [bundle URLForResource:[self fontFile] withExtension:@"ttf"];
        [self registerFontWithURL:fontFileUrl];
        font = [UIFont fontWithName:[self fontName] size:size];
        NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    }
    return font;
}

/**
 * @param fontName 字体名称, 要求字体文件和自己名称相同
 */
+ (UIFont*)fontWithSize:(CGFloat)size withFontName:(NSString*)fontName {
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (font == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *fontFileUrl = [bundle URLForResource:fontName withExtension:@"ttf"];
        [self registerFontWithURL:fontFileUrl];
        font = [UIFont fontWithName:fontName size:size];
        NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    }
    return font;
}

@end


@implementation UIImage (DNIconfontHelper)

#if USE_DYNAMICT_GEN
+ (NSDictionary*)glyphsTable {
    // 动态生成
    static dispatch_once_t onceToken;
    static NSDictionary   *glyphsTable;
    dispatch_once(&onceToken, ^{
        NSString*path = [[NSBundle mainBundle] pathForResource:@"iconfont.json" ofType:nil];
        if (!path || [[NSFileManager defaultManager] fileExistsAtPath:path]) {
            glyphsTable = @{};
        }
        NSError*error    = nil;
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:0 error:&error];
        if (error || !jsonData) {
            NSAssert(NO, @"read %@ failed", path);
            glyphsTable = @{};
        }
        @try {
            NSDictionary*jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingFragmentsAllowed error:&error];
            if (error || ![jsonObject isKindOfClass:[NSDictionary class]]) {
                NSAssert(NO, @"%@ is a invalid iconfont.json", path);
                glyphsTable = @{};
            }
            
            NSArray*glyphs = [jsonObject valueForKey:@"glyphs"];
            if (!glyphs) {
                NSAssert(NO, @"no glyphs in %@", jsonObject);
                glyphsTable = @{};
            }
            
            NSMutableDictionary*table = [NSMutableDictionary dictionaryWithCapacity:glyphs.count];
            /**
             * {
             * "icon_id": "12933882",
             * "name": "图标-本地导入",
             * "font_class": "tubiao-bendidaoru",
             * "unicode": "e76e",
             * "unicode_decimal": 59246
             * }
             */
            for (NSDictionary*glyph in glyphs) {
                NSString*name = [glyph valueForKey:@"name"];
                //NSString*code      = [glyph valueForKey:@"unicode"];
                NSNumber*object = [glyph valueForKey:@"unicode_decimal"];
                if (![object isKindOfClass:[NSNumber class]]) {
                    NSAssert(NO, @"%@ in 'glyphs' must be a integer", name);
                    glyphsTable = @{};
                    continue;
                }
                // 利用unicode_decimal构造Unicode字符串
                NSUInteger decimal = [object integerValue];
                if (name && decimal) {
                    uint32_t bytes        = htonl(decimal);
                    NSString*unicode_code = [[NSString alloc] initWithBytes:&bytes length:sizeof(bytes) encoding:NSUTF32StringEncoding];    //[NSString stringWithFormat:@"%@U%08lx",@"\\", decimal];
                    [table setValue:unicode_code forKey:name];
                }
            }
            glyphsTable = table;
        } @catch (NSException *exception) {
        } @finally {
        }
    });
    
    return glyphsTable;
} /* gen */
#else /* if 1 || USE_DYNAMICT_GEN */
/**
 *  iconfontjson_to_nsdictonary 利用脚本生成字典,并粘贴到这里
 */
+ (NSDictionary*)glyphsTable {
    return @{@"图标-标签":@"\U0000e7df",
             @"图标-本地导入":@"\U0000e76e",
             @"图标-对勾":@"\U0000e770",
             @"图标-帮助":@"\U0000e771",
             @"图标-充值":@"\U0000e772",
             @"图标-对号":@"\U0000e773",
             @"图标-反馈 (2)":@"\U0000e774",
             @"图标-法律条款":@"\U0000e775",
             @"图标-返回上级":@"\U0000e776",
             @"图标-返回":@"\U0000e777",
             @"图标-更多":@"\U0000e778",
             @"图标-反馈":@"\U0000e779",
             @"图标-更换":@"\U0000e77a",
             @"图标-检查更新":@"\U0000e77b",
             @"图标-加入书架":@"\U0000e77c",
             @"图标-减号":@"\U0000e77d",
             @"图标-加入书架 (2)":@"\U0000e77e",
             @"图标-垃圾桶":@"\U0000e77f",
             @"图标-加号":@"\U0000e780",
             @"图标-分享":@"\U0000e781",
             @"图标-取消输入":@"\U0000e782",
             @"图标-亮度+":@"\U0000e783",
             @"图标-目录":@"\U0000e784",
             @"图标-扫描":@"\U0000e785",
             @"图标-上箭头-面":@"\U0000e786",
             @"图标-上箭头-粗":@"\U0000e787",
             @"图标-上箭头-细":@"\U0000e788",
             @"图标-亮度-":@"\U0000e789",
             @"图标-上箭头-三角":@"\U0000e78a",
             @"图标-删除":@"\U0000e78c",
             @"书城_线性":@"\U0000e640",
             @"图标-搜索":@"\U0000e78e",
             @"图标-设置":@"\U0000e78f",
             @"图标-锁":@"\U0000e790",
             @"图标-书":@"\U0000e791",
             @"书架_线性":@"\U0000e63d",
             @"图标-添加":@"\U0000e793",
             @"图标-未选择2":@"\U0000e794",
             @"图标-搜索1":@"\U0000e795",
             @"图标-书签":@"\U0000e796",
             @"图标-文字-":@"\U0000e797",
             @"图标-微信支付":@"\U0000e798",
             @"图标-五角星":@"\U0000e799",
             @"图标-未选择":@"\U0000e79a",
             @"图标-下箭头-粗":@"\U0000e79b",
             @"图标-向下":@"\U0000e79c",
             @"图标-下箭头-细":@"\U0000e79d",
             @"图标-微信":@"\U0000e79e",
             @"图标-刷新":@"\U0000e79f",
             @"图标-行间距1":@"\U0000e7a0",
             @"图标-显示":@"\U0000e7a1",
             @"我的_线性":@"\U0000e63e",
             @"图标-已选择2":@"\U0000e7a3",
             @"图标-已加入书架":@"\U0000e7a4",
             @"图标-下箭头-面":@"\U0000e7a5",
             @"图标-文字+":@"\U0000e7a6",
             @"图标-向上":@"\U0000e7a7",
             @"图标-我的账户":@"\U0000e7a8",
             @"图标-隐私政策":@"\U0000e7a9",
             @"图标-右箭头":@"\U0000e7aa",
             @"图标-夜间模式":@"\U0000e7ab",
             @"图标-阅读记录":@"\U0000e7ac",
             @"图标-整理书架 (2)":@"\U0000e7ad",
             @"图标-行间距4":@"\U0000e7ae",
             @"图标-行间距2":@"\U0000e7af",
             @"图标-相机":@"\U0000e7b0",
             @"图标-行间距3":@"\U0000e7b1",
             @"图标-隐藏":@"\U0000e7b2",
             @"图标-x1":@"\U0000e7b3",
             @"图标-已选择":@"\U0000e7b4",
             @"图标-支付宝":@"\U0000e7b5",
             @"图标-圆圈1":@"\U0000e7b6",
             @"图标-右箭头-小":@"\U0000e7b7",
             @"图标-下箭头-三角":@"\U0000e7b8",
             @"图标-意见反馈":@"\U0000e7b9",
             @"图标-右箭头-三角":@"\U0000e7ba",
             @"图标-阅读记录 (2)":@"\U0000e7bb",
             @"我的_账户":@"\U0000e631",
             @"分类_线性":@"\U0000e63f",
             @"图标-loading":@"\U0000e7bd",
             @"图标-整理书架":@"\U0000e7be",
             @"图标-QQ":@"\U0000e7bf",
             @"图标-已添加书签":@"\U0000e7c0",
             @"图标-阅读偏好":@"\U0000e7c1",
             /*新增*/
             @"图标-已缓存-2":@"\U0000e7de",
             @"图标-返回当前":@"\U0000e7aa",
             @"图标-短横线":@"\U0000e7b6",
             @"图标-播放":@"\U0000e7be",
             @"图标-编辑-2":@"\U0000e7c2",
             @"图标-更多-1":@"\U0000e7c3",
             @"图标-更多设置":@"\U0000e7c4",
             @"图标-缓存-2":@"\U0000e7c5",
             @"图标-关闭护眼":@"\U0000e7c6",
             @"图标-缓存-1":@"\U0000e7c7",
             @"图标-缓存-3":@"\U0000e7c8",
             @"图标-加载-粗线":@"\U0000e7c9",
             @"图标-缓存暂停-1":@"\U0000e7ca",
             @"图标-加载-面":@"\U0000e7cb",
             @"图标-警示-2":@"\U0000e7cc",
             @"图标-警示-3":@"\U0000e7cd",
             @"图标-结束":@"\U0000e7ce",
             @"图标-静音":@"\U0000e7cf",
             @"图标-开启护眼":@"\U0000e7d0",
             @"图标-全屏":@"\U0000e7d1",
             @"图标-书城-面":@"\U0000e7d2",
             @"图标-评论":@"\U0000e7d3",
             @"图标-书架-面":@"\U0000e7d4",
             @"图标-书架":@"\U0000e792",
             @"图标-声音":@"\U0000e7d5",
             @"图标-已缓存-3":@"\U0000e7d6",
             @"图标-右箭头-线":@"\U0000e7d7",
             @"图标-已缓存-1":@"\U0000e7d8",
             @"图标-信息":@"\U0000e7d9",
             @"dark_我的":@"\U0000e647",
             @"图标-自动翻页 2":@"\U0000e7db",
             @"dark_分类找书":@"\U0000e649",
             @"图标-分享的副本":@"\U0000e7dd",
             @"图标-清理":@"\U0000e7e7",
             @"图标-关于我们":@"\U0000e7ea",
             @"图标-账户设置":@"\U0000e7ec",
             @"图标-设置-线":@"\U0000e7e8",
             /*新增*/
             @"图标-开始阅读":@"\U0000e7f1",
             @"图标-缓存-4":@"\U0000e7f2",
             @"图标-缓存暂停-4":@"\U0000e7f3",
             @"图标-缓存完成-2":@"\U0000e7ef",
             @"图标-听书-2":@"\U0000e7f0",
             @"听书-返回":@"\U0000e60e",
             @"听书-推荐书籍播":@"\U0000e60c",
             @"听书-loading":@"\U0000e60a",
             @"听书-暂停":@"\U0000e609",
             @"听书-章节":@"\U0000e608",
             @"听书-定时":@"\U0000e606",
             @"听书-播放":@"\U0000e605",
             @"听书-下一个":@"\U0000e602",
             @"听书-上一个":@"\U0000e601",
             @"图标-暂停 (2)":@"\U0000e7e5",
             @"图标-播放 (2)":@"\U0000e7e6",
             @"漫画阅读器-loading":@"\U0000e613",
             @"漫画阅读器-刷新":@"\U0000e612",
             @"漫画阅读器-亮度":@"\U0000e614",
             @"图标-设置-面":@"\U0000e7e9",
             @"阅读器-反馈":@"\U0000e616",
             @"小说/漫画详情":@"\U0000e615",
             };
} /* glyphsTable */
#endif /* if USE_DYNAMICT_GEN */

+ (NSString *)fontName {
    return nil;
}

+ (NSString *)nameToUnicode:(NSString*)name {
    NSDictionary *nameToUnicode = [self glyphsTable];
    NSString     *code          = nameToUnicode[name];
    return code?:name;
}

+ (UIImage *)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color {
    return [self iconWithName:name fontSize:size color:color inset:UIEdgeInsetsZero backgroundColor:nil];
}

+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color padding:(CGFloat)paddingPercent {
    CGFloat      padding = size * paddingPercent;
    UIEdgeInsets inset   = UIEdgeInsetsMake(padding, padding, padding, padding);
    return [self iconWithName:name fontSize:size color:color inset:inset backgroundColor:nil];
}

+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color inset:(UIEdgeInsets)inset {
    return [self iconWithName:name fontSize:size color:color inset:inset backgroundColor:nil];
}

+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color backgroundColor:(UIColor*)backgroundColor {
    return [self iconWithName:name fontSize:size color:color inset:UIEdgeInsetsZero backgroundColor:backgroundColor];
}

+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color padding:(CGFloat)paddingPercent backgroundColor:(UIColor*)backgroundColor {
    CGFloat      padding = size * paddingPercent;
    UIEdgeInsets inset   = UIEdgeInsetsMake(padding, padding, padding, padding);
    return [self iconWithName:name fontSize:size color:color inset:inset backgroundColor:backgroundColor];
}

//主方法
+ (UIImage*)iconWithName:(NSString*)name fontSize:(CGFloat)size color:(UIColor*)color inset:(UIEdgeInsets)imageInsets backgroundColor:(UIColor*)backgroundColor {
    NSString *code     = [self nameToUnicode:name];
    NSString *fontName = [self fontName];
    
    CGFloat   w1        = size - imageInsets.left - imageInsets.right;
    CGFloat   w2        = size - imageInsets.top - imageInsets.bottom;
    CGFloat   min_size  = MIN(w1, w2);
    CGFloat   scale     = [UIScreen mainScreen].scale;
    CGFloat   realSize  = min_size * scale - 1; // 为了防止icon被剪裁调1pt，所以这里高度去掉1pt，确保icon在范围内。
    CGFloat   imageSize = size * scale;
    UIFont   *font      = fontName?[DNIconFont fontWithSize:realSize withFontName:fontName]:[DNIconFont fontWithSize:realSize];
    
    UIGraphicsBeginImageContext(CGSizeMake(imageSize, imageSize));
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (backgroundColor) {
        [backgroundColor set];
        UIRectFill(CGRectMake(0.0, 0.0, imageSize, imageSize)); //fill the background
    }
    CGPoint point = CGPointMake(imageInsets.left * scale, imageInsets.top * scale);
    
    if ([code respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        /**
         * 如果这里抛出异常，请打开断点列表，右击All Exceptions -> Edit Breakpoint -> All修改为Objective-C
         * See: http://stackoverflow.com/questions/1163981/how-to-add-a-breakpoint-to-objc-exception-throw/14767076#14767076
         */
        [code drawAtPoint:point withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, color.CGColor);
        [code drawAtPoint:point withFont:font];
#pragma clang pop
    }
    
    UIImage *image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
    UIGraphicsEndImageContext();
    
    return image;
}

@end
