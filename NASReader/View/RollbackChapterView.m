//
//  DNRollbackChapterView.m
//  dnovel
//
//  Created by oneko on 2021/1/26.
//  Copyright © 2021 blox. All rights reserved.
//

#import "RollbackChapterView.h"
#import "UIImage+DNIconfontHelper.h"

@interface RollbackChapterView()

@property (nonatomic, strong) UILabel *chapterLabel;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UIButton *rollbackBtn;

@end

@implementation RollbackChapterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    UILabel *chapterLabel = [UILabel new];
    chapterLabel.font = [UIFont systemFontOfSize:13];
    chapterLabel.textColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    chapterLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:chapterLabel];
    self.chapterLabel = chapterLabel;
    
    UILabel *percentLabel = [UILabel new];
    percentLabel.font = [UIFont systemFontOfSize:13];
    percentLabel.textColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    [percentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    percentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:percentLabel];
    self.percentLabel = percentLabel;
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:line];
    
    UIColor *btnColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    UIButton *rollbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rollbackBtn setImage:[UIImage iconWithName:@"图标-返回当前" fontSize:14 color:btnColor] forState:UIControlStateNormal];
    [rollbackBtn addTarget:self action:@selector(rollbackAction:) forControlEvents:UIControlEventTouchUpInside];
    rollbackBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:rollbackBtn];
    
    
    
    NSLayoutConstraint *chapterCenterY = [NSLayoutConstraint constraintWithItem:chapterLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *chapterLeading = [NSLayoutConstraint constraintWithItem:chapterLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20.0];
    [self addConstraints:@[chapterCenterY, chapterLeading]];
    
    NSLayoutConstraint *percentCenterY = [NSLayoutConstraint constraintWithItem:percentLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *percentTrailing = [NSLayoutConstraint constraintWithItem:percentLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-75];
    NSLayoutConstraint *percentLeading = [NSLayoutConstraint constraintWithItem:percentLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:chapterLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5];
    [self addConstraints:@[percentCenterY, percentTrailing, percentLeading]];
    
    NSLayoutConstraint *lineCenterY = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *lineTrailing = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-54];
    NSLayoutConstraint *lineWidth = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:1.0];
    NSLayoutConstraint *lineHeight = [NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:35];
    [self addConstraints:@[lineCenterY, lineTrailing, lineHeight, lineWidth]];
    
    NSLayoutConstraint *rollbackCenter = [NSLayoutConstraint constraintWithItem:rollbackBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    NSLayoutConstraint *rollbackTrailing = [NSLayoutConstraint constraintWithItem:rollbackBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-18];
    [self addConstraints:@[rollbackCenter, rollbackTrailing]];
    
    self.backgroundColor = [UIColor colorWithRed:0.137 green:0.137 blue:0.137 alpha:1.0];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

- (void)rollbackAction:(UIButton *)sender {
    if (self.rollback) {
        self.rollback();
    }
}

- (void)updateChapter:(NSString *)chapter
      locationPercent:(CGFloat)percent
      rollbackEnabled:(BOOL)enabled {
    self.chapterLabel.text = chapter;
    self.percentLabel.text = [NSString stringWithFormat:@"%.2f%%", percent * 100];
    self.rollbackBtn.selected = !enabled;
}

@end
