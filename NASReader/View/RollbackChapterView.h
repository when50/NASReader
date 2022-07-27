//
//  DNRollbackChapterView.h
//  dnovel
//
//  Created by oneko on 2021/1/26.
//  Copyright © 2021 blox. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^Rollback)(void);

@interface RollbackChapterView : UIView

@property (nonatomic, copy, nullable) Rollback rollback;
@property (nonatomic, copy) NSString *origChapterName;
@property (nonatomic, assign) CGFloat origLocationPercent;

- (void)updateChapter:(NSString *)chapter
      locationPercent:(CGFloat)percent
      rollbackEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
