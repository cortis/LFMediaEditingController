//
//  LFEditToolbar.m
//  LFImagePickerController
//
//  Created by LamTsanFeng on 2017/3/14.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import "LFEditToolbar.h"
#import "UIView+LFMEFrame.h"
#import "LFMediaEditingHeader.h"
#import "JRPickColorView.h"

#define EditToolbarButtonImageNormals @[@"EditImagePenToolBtn.png", @"EditImageEmotionToolBtn.png", @"EditImageTextToolBtn.png", @"EditImageMosaicToolBtn.png", @"EditImageCropToolBtn.png", @"EditImageAudioToolBtn.png", @"EditVideoCropToolBtn.png", @"EditImageFilterToolBtn.png", @"EditImageRateToolBtn.png"]
#define EditToolbarButtonImageHighlighted @[@"EditImagePenToolBtn_HL.png", @"EditImageEmotionToolBtn_HL.png", @"EditImageTextToolBtn_HL.png", @"EditImageMosaicToolBtn_HL.png", @"EditImageCropToolBtn_HL.png", @"EditImageAudioToolBtn_HL.png", @"EditVideoCropToolBtn_HL.png", @"EditImageFilterToolBtn_HL.png", @"EditImageRateToolBtn_HL.png"]

#define kToolbar_MainHeight 44
#define kToolbar_SubHeight 55

#define kToolbar_RateTips(r) [NSString stringWithFormat:@"x %.1f", r]

@interface LFEditToolbar () <JRPickColorViewDelegate>

/** 一级菜单 */
@property (nonatomic, weak) UIView *edit_menu;

/** 二级菜单 */
@property (nonatomic, weak) UIView *edit_drawMenu;
@property (nonatomic, weak) UIButton *edit_drawMenu_revoke;
/** 绘画颜色显示 */
@property (nonatomic, weak) UIView *edit_drawMenu_color;
@property (nonatomic, weak) UIView *edit_splashMenu;
@property (nonatomic, weak) UIButton *edit_splashMenu_revoke;
/** 进度条 */
@property (nonatomic, weak) UIView *edit_rateMenu;
@property (nonatomic, weak) UISlider *edit_rateMenu_slider;
@property (nonatomic, weak) UIButton *edit_rateMenu_tipsButton;

/** 当前激活菜单按钮 */
@property (nonatomic, weak) UIButton *edit_splashMenu_action_button;

/** 当前显示菜单 */
@property (nonatomic, weak) UIView *selectMenu;
/** 当前点击按钮 */
@property (nonatomic, weak) UIButton *selectButton;

/** 绘画拾色器 */
@property (nonatomic, weak) JRPickColorView *draw_colorSlider;

@property (nonatomic, assign) LFEditToolbarType type;
@property (nonatomic, strong) NSArray *mainImageNormals;
@property (nonatomic, strong) NSArray *mainImageHighlighted;

@end

@implementation LFEditToolbar

- (instancetype)initWithType:(LFEditToolbarType)type
{
    self = [self init];
    if (self) {
        _type = type;
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat height = kToolbar_MainHeight+kToolbar_SubHeight;
    self = [super initWithFrame:(CGRect){{0, [UIScreen mainScreen].bounds.size.height-height}, {[UIScreen mainScreen].bounds.size.width, height}}];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = kToolbar_MainHeight+kToolbar_SubHeight;
    
    if (@available(iOS 11.0, *)) {
        height += self.safeAreaInsets.bottom;
    }
    
    self.frame = (CGRect){{0, [UIScreen mainScreen].bounds.size.height-height}, {[UIScreen mainScreen].bounds.size.width, height}};
    self.edit_menu.frame = CGRectMake(0, kToolbar_SubHeight, self.width, height-kToolbar_SubHeight);
}

- (void)customInit
{
    _mainImageNormals = EditToolbarButtonImageNormals;
    _mainImageHighlighted = EditToolbarButtonImageHighlighted;
    [self mainBar];
    [self subBar];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }
    return view;
}

#pragma mark - 菜单创建
- (void)mainBar
{
    CGFloat height = kToolbar_MainHeight;
    if (@available(iOS 11.0, *)) {
        height += self.safeAreaInsets.bottom;
    }
    UIView *edit_menu = [[UIView alloc] initWithFrame:CGRectMake(0, kToolbar_SubHeight, self.width, height)];
    edit_menu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    CGFloat rgb = 34 / 255.0;
    edit_menu.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.85];
    
    NSInteger buttonCount = 0;
    NSMutableArray <NSNumber *>*_imageIndexs = [@[] mutableCopy];
    NSMutableArray <NSNumber *>*_selectIndexs = [@[] mutableCopy];
    
    if (self.type&LFEditToolbarType_draw) {
        [_imageIndexs addObject:@0];
        [_selectIndexs addObject:@(LFEditToolbarType_draw)];
        buttonCount ++;
    }
    if (self.type&LFEditToolbarType_sticker) {
        [_imageIndexs addObject:@1];
        [_selectIndexs addObject:@(LFEditToolbarType_sticker)];
        buttonCount ++;
    }
    if (self.type&LFEditToolbarType_text) {
        [_imageIndexs addObject:@2];
        [_selectIndexs addObject:@(LFEditToolbarType_text)];
        buttonCount ++;
    }
    if (self.type&LFEditToolbarType_splash) {
        [_imageIndexs addObject:@3];
        [_selectIndexs addObject:@(LFEditToolbarType_splash)];
        buttonCount ++;
    }
    if (self.type&LFEditToolbarType_filter) {
        [_imageIndexs addObject:@7];
        [_selectIndexs addObject:@(LFEditToolbarType_filter)];
        buttonCount ++;
    }
    if (self.type&LFEditToolbarType_crop) {
        [_imageIndexs addObject:@4];
        [_selectIndexs addObject:@(LFEditToolbarType_crop)];
        buttonCount ++;
    }
    if (self.type&LFEditToolbarType_audio) {
        [_imageIndexs addObject:@5];
        [_selectIndexs addObject:@(LFEditToolbarType_audio)];
        buttonCount ++;
    }
    if (self.type&LFEditToolbarType_rate) {
        [_imageIndexs addObject:@8];
        [_selectIndexs addObject:@(LFEditToolbarType_rate)];
        buttonCount ++;
    }
    if (self.type&LFEditToolbarType_clip) {
        [_imageIndexs addObject:@6];
        [_selectIndexs addObject:@(LFEditToolbarType_clip)];
        buttonCount ++;
    }
    
    
    if (buttonCount > 0) {
        CGFloat width = CGRectGetWidth(self.frame)/buttonCount;
        UIFont *font = [UIFont systemFontOfSize:14];
        for (NSInteger i=0; i<buttonCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width*i, 0, width, kToolbar_MainHeight);
            button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            button.titleLabel.font = font;
            button.tag = [_selectIndexs[i] integerValue];
            int index = [_imageIndexs[i] intValue];
            [button setImage:bundleEditImageNamed(_mainImageNormals[index]) forState:UIControlStateNormal];
            [button setImage:bundleEditImageNamed(_mainImageHighlighted[index]) forState:UIControlStateHighlighted];
            [button setImage:bundleEditImageNamed(_mainImageHighlighted[index]) forState:UIControlStateSelected];
            [button addTarget:self action:@selector(edit_toolBar_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [edit_menu addSubview:button];
        }
    }
    
    UIView *divide = [[UIView alloc] init];
    CGFloat rgb2 = 40 / 255.0;
    divide.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    divide.frame = CGRectMake(0, 0, self.width, 1);
    divide.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    [edit_menu addSubview:divide];
    self.edit_menu = edit_menu;
    
    [self addSubview:edit_menu];
}

- (void)subBar
{
    [self drawMenu];
    [self splashMenu];
    [self rateMenu];
}

#pragma mark - 二级菜单栏(懒加载)
- (void)drawMenu
{
    if (_edit_drawMenu == nil && self.type&LFEditToolbarType_draw) {
        UIView *edit_drawMenu = [[UIView alloc] initWithFrame:CGRectMake(_edit_menu.x, _edit_menu.y, _edit_menu.width, kToolbar_SubHeight)];
        edit_drawMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        edit_drawMenu.backgroundColor = _edit_menu.backgroundColor;
        edit_drawMenu.alpha = 0.f;
        /** 添加按钮获取点击 */
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = edit_drawMenu.bounds;
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [edit_drawMenu addSubview:button];
        
        UIButton *edit_drawMenu_revoke = [self revokeButtonWithType:LFEditToolbarType_draw];
        [edit_drawMenu addSubview:edit_drawMenu_revoke];
        self.edit_drawMenu_revoke = edit_drawMenu_revoke;
        
        /** 分隔线 */
        UIView *separateView = [self separateView];
        separateView.frame = CGRectMake(CGRectGetMinX(edit_drawMenu_revoke.frame)-2-5, (CGRectGetHeight(edit_drawMenu.frame)-25)/2, 2, 25);
        separateView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [edit_drawMenu addSubview:separateView];
        
        /** 颜色显示 */
        CGFloat margin = isiPad ? 85.f : 25.f;
//        CGFloat colorViewHeight = 20.f;
//        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(margin, (CGRectGetHeight(edit_drawMenu.frame)-colorViewHeight)/2, colorViewHeight, colorViewHeight)];
//        colorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        colorView.layer.cornerRadius = colorViewHeight/2;
//        colorView.layer.borderWidth = 1.0f;
//        colorView.layer.borderColor = [UIColor whiteColor].CGColor;
//        colorView.layer.masksToBounds = YES;
//        colorView.userInteractionEnabled = NO;
//        [edit_drawMenu addSubview:colorView];
//        self.edit_drawMenu_color = colorView;
        
        /** 拾色器 */
        CGFloat surplusWidth = CGRectGetMinX(separateView.frame)-CGRectGetMaxX(self.edit_drawMenu_color.frame)-2*margin;
        CGFloat sliderHeight = 34.f, sliderWidth = MIN(surplusWidth, 350);
        JRPickColorView *_colorSlider = [[JRPickColorView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.edit_drawMenu_color.frame) + margin + (surplusWidth - sliderWidth) / 2, (CGRectGetHeight(edit_drawMenu.frame)-sliderHeight)/2, sliderWidth, sliderHeight) colors:kSliderColors];
        _colorSlider.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _colorSlider.delegate = self;
        [_colorSlider setMagnifierMaskImage:bundleEditImageNamed(@"EditImageWaterDrop.png")];
        [edit_drawMenu addSubview:_colorSlider];
        self.draw_colorSlider = _colorSlider;
        
        /** 颜色显示 */
        self.edit_drawMenu_color.backgroundColor = _colorSlider.color;
        
        self.edit_drawMenu = edit_drawMenu;
        
        [self insertSubview:edit_drawMenu belowSubview:_edit_menu];
    }
}

- (void)splashMenu
{
    if (_edit_splashMenu == nil && self.type&LFEditToolbarType_splash) {
        UIView *edit_splashMenu = [[UIView alloc] initWithFrame:CGRectMake(_edit_menu.x, _edit_menu.y, _edit_menu.width, kToolbar_SubHeight)];
        edit_splashMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        edit_splashMenu.backgroundColor = _edit_menu.backgroundColor;
        edit_splashMenu.alpha = 0.f;
        /** 添加按钮获取点击 */
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = edit_splashMenu.bounds;
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [edit_splashMenu addSubview:button];
        
        UIButton *edit_splashMenu_revoke = [self revokeButtonWithType:LFEditToolbarType_splash];
        [edit_splashMenu addSubview:edit_splashMenu_revoke];
        self.edit_splashMenu_revoke = edit_splashMenu_revoke;
        
        /** 分隔线 */
        UIView *separateView = [self separateView];
        separateView.frame = CGRectMake(CGRectGetMinX(edit_splashMenu_revoke.frame)-2-5, (CGRectGetHeight(edit_splashMenu.frame)-25)/2, 2, 25);
        separateView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [edit_splashMenu addSubview:separateView];
        
        /** 剩余长度 */
        CGFloat width = CGRectGetMinX(edit_splashMenu_revoke.frame);
        /** 按钮个数 */
        int count = 3;
        /** 平分空间 */
        CGFloat averageWidth = width/(count+1);
        
        NSArray *icons = @[@"EditImageTraditionalMosaicBtn.png", @"EditImageBrushBlurryBtn.png", @"EditImageBrushMosaicBtn.png"];
        NSArray *icons_HL = @[@"EditImageTraditionalMosaicBtn_HL.png", @"EditImageBrushBlurryBtn_HL.png", @"EditImageBrushMosaicBtn_HL.png"];
        
        for (NSInteger i=0; i<count; i++) {
            UIButton *action = [UIButton buttonWithType:UIButtonTypeCustom];
            action.frame = CGRectMake(averageWidth*(i+1)-44/2, (CGRectGetHeight(edit_splashMenu.frame)-30)/2, 44, 30);
            action.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [action addTarget:self action:@selector(splashMenu_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [action setImage:bundleEditImageNamed(icons[i]) forState:UIControlStateNormal];
            [action setImage:bundleEditImageNamed(icons_HL[i]) forState:UIControlStateHighlighted];
            [action setImage:bundleEditImageNamed(icons_HL[i]) forState:UIControlStateSelected];
            action.tag = i+1;
            [edit_splashMenu addSubview:action];
            
            if (i == 0) {
                /** 优先激活首个按钮 */
                _edit_splashMenu_action_button = action;
                action.selected = YES;
            }
        }
        
        self.edit_splashMenu = edit_splashMenu;
        [self insertSubview:edit_splashMenu belowSubview:_edit_menu];
    }
}

- (UIButton *)revokeButtonWithType:(NSInteger)type
{
    UIButton *revoke = [UIButton buttonWithType:UIButtonTypeCustom];
    revoke.frame = CGRectMake(_edit_menu.width-44-5, 0, 44, kToolbar_SubHeight);
    revoke.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [revoke setImage:bundleEditImageNamed(@"EditImageRevokeBtn.png") forState:UIControlStateNormal];
    [revoke setImage:bundleEditImageNamed(@"EditImageRevokeBtn_HL.png") forState:UIControlStateHighlighted];
    [revoke setImage:bundleEditImageNamed(@"EditImageRevokeBtn_HL.png") forState:UIControlStateSelected];
    revoke.tag = type;
    [revoke addTarget:self action:@selector(revoke_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return revoke;
}

- (UIImageView *)separateView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:bundleEditImageNamed(@"AlbumCommentLine.png")];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (UIView *)rateMenu
{
    if (_edit_rateMenu == nil && self.type&LFEditToolbarType_rate) {
        UIView *edit_rateMenu = [[UIView alloc] initWithFrame:CGRectMake(_edit_menu.x, _edit_menu.y, _edit_menu.width, kToolbar_SubHeight)];
        edit_rateMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        edit_rateMenu.backgroundColor = _edit_menu.backgroundColor;
        edit_rateMenu.alpha = 0.f;
        /** 添加按钮获取点击 */
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = edit_rateMenu.bounds;
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [edit_rateMenu addSubview:button];
        
        /** 间距 */
        CGFloat margin = isiPad ? 85.f : 25.f;
        
        /** 提示label */
        CGFloat labelWidth = 40.f;
        UIButton *tipsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tipsButton.frame = CGRectMake(margin, 0, labelWidth, edit_rateMenu.frame.size.height);
        [tipsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tipsButton setTitle:kToolbar_RateTips(1.0) forState:UIControlStateNormal];
        [tipsButton addTarget:self action:@selector(sliderTipsOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [edit_rateMenu addSubview:tipsButton];
        _edit_rateMenu_tipsButton = tipsButton;
        
        /** slider */
        CGFloat sliderWidth = CGRectGetWidth(edit_rateMenu.frame)-CGRectGetMaxX(tipsButton.frame)-2*margin;
        CGFloat sliderHeight = 34.f;
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipsButton.frame)+margin, (edit_rateMenu.frame.size.height-sliderHeight)/2, sliderWidth, sliderHeight)];
        slider.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
//        slider.continuous = NO;
        slider.maximumValue = LFMediaEditMaxRate;
        slider.minimumValue = LFMediaEditMinRate;
        slider.value = 1.0;
        [edit_rateMenu addSubview:slider];
        _edit_rateMenu_slider = slider;
        
        self.edit_rateMenu = edit_rateMenu;
        
        [self insertSubview:edit_rateMenu belowSubview:_edit_menu];
    }
    return _edit_rateMenu;
}

- (void)sliderTipsOnClick:(UIButton *)button
{
    [_edit_rateMenu_tipsButton setTitle:kToolbar_RateTips(1.0) forState:UIControlStateNormal];
    _edit_rateMenu_slider.value = 1.0;
    if ([self.delegate respondsToSelector:@selector(lf_editToolbar:rateDidChange:)]) {
        [self.delegate lf_editToolbar:self rateDidChange:_edit_rateMenu_slider.value];
    }
}

- (void)sliderDidChange:(UISlider *)slider
{
    [_edit_rateMenu_tipsButton setTitle:kToolbar_RateTips(slider.value) forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(lf_editToolbar:rateDidChange:)]) {
        float value = [[NSString stringWithFormat:@"%.1f", slider.value] floatValue];
        [self.delegate lf_editToolbar:self rateDidChange:value];
    }
}

#pragma mark - 一级菜单事件(action)
- (void)edit_toolBar_buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case LFEditToolbarType_draw:
        {
            [self showMenuView:_edit_drawMenu];
            if (button.isSelected == NO) {
                if ([self.delegate respondsToSelector:@selector(lf_editToolbar:canRevokeAtIndex:)]) {
                    BOOL canRevoke = [self.delegate lf_editToolbar:self canRevokeAtIndex:button.tag];
                    _edit_drawMenu_revoke.enabled = canRevoke;
                }
            }
            [self changedButton:button];
        }
            break;
        case LFEditToolbarType_splash:
        {
            [self showMenuView:_edit_splashMenu];
            if (button.isSelected == NO) {
                if ([self.delegate respondsToSelector:@selector(lf_editToolbar:canRevokeAtIndex:)]) {
                    BOOL canRevoke = [self.delegate lf_editToolbar:self canRevokeAtIndex:button.tag];
                    _edit_splashMenu_revoke.enabled = canRevoke;
                }
            }
            [self changedButton:button];
        }
            break;
        case LFEditToolbarType_rate:
        {
            [self showMenuView:_edit_rateMenu];
            [self changedButton:button];
        }
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(lf_editToolbar:mainDidSelectAtIndex:)]) {
        [self.delegate lf_editToolbar:self mainDidSelectAtIndex:button.tag];
    }
}

#pragma mark - 二级菜单撤销（action）
- (void)revoke_buttonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(lf_editToolbar:subDidRevokeAtIndex:)]) {
        [self.delegate lf_editToolbar:self subDidRevokeAtIndex:button.tag];
    }
    if ([self.delegate respondsToSelector:@selector(lf_editToolbar:canRevokeAtIndex:)]) {
        BOOL canRevoke = [self.delegate lf_editToolbar:self canRevokeAtIndex:button.tag];
        button.enabled = canRevoke;
    }
}

- (void)splashMenu_buttonClick:(UIButton *)button
{
    if (_edit_splashMenu_action_button != button) {
        _edit_splashMenu_action_button.selected = NO;
        button.selected = YES;
        _edit_splashMenu_action_button = button;
        if ([self.delegate respondsToSelector:@selector(lf_editToolbar:subDidSelectAtIndex:)]) {
            [self.delegate lf_editToolbar:self subDidSelectAtIndex:[NSIndexPath indexPathForRow:button.tag-1 inSection:LFEditToolbarType_splash]];
        }
    }
}

#pragma mark - 显示二级菜单栏
- (void)showMenuView:(UIView *)menu
{
    /** 将显示的菜单先关闭 */
    if (_selectMenu) {
        [self hidenMenuView];
    }
    if (_selectMenu != menu) {
        /** 显示新菜单 */
        _selectMenu = menu;
        [UIView animateWithDuration:0.25f animations:^{
            menu.y = 0;
            menu.alpha = 1.f;
        }];
    } else {
        _selectMenu = nil;
    }
}
- (void)hidenMenuView
{
    [self sendSubviewToBack:_selectMenu];
    [UIView animateWithDuration:0.25f animations:^{
        self->_selectMenu.y = self->_edit_menu.y;
        self->_selectMenu.alpha = 0.f;
    }];
}

#pragma mark - 按钮激活切换
- (BOOL)changedButton:(UIButton *)button
{
    /** 选中按钮 */
    button.selected = !button.selected;
    if (_selectButton != button) {
        _selectButton.selected = !_selectButton.selected;
        _selectButton = button;
    } else {
        _selectButton = nil;
    }
    return (_selectButton != nil);
}

/** 当前激活主菜单 */
- (NSUInteger)mainSelectAtIndex
{
    return _selectButton ? _selectButton.tag : -1;
}

/** 允许撤销 */
- (void)setRevokeAtIndex:(NSUInteger)index
{
    switch (index) {
        case LFEditToolbarType_draw:
        {
            _edit_drawMenu_revoke.enabled = YES;
        }
            break;
        case LFEditToolbarType_splash:
        {
            _edit_splashMenu_revoke.enabled = YES;
        }
            break;
        default:
            break;
    }
}

/** 获取拾色器的颜色 */
- (NSArray <UIColor *>*)drawSliderColors
{
    return self.draw_colorSlider.colors;
}
- (UIColor *)drawSliderCurrentColor
{
    return self.draw_colorSlider.color;
}

/** 设置绘画拾色器默认颜色 */
- (void)setDrawSliderColor:(UIColor *)color
{
    self.draw_colorSlider.color = color;
    self.edit_drawMenu_color.backgroundColor = color;
}

- (void)setDrawSliderColorAtIndex:(NSUInteger)index
{
    self.draw_colorSlider.index = index;
    self.edit_drawMenu_color.backgroundColor = self.draw_colorSlider.color;
}

- (float)rate
{
    return self.edit_rateMenu_slider.value;
}

- (void)setRate:(float)rate
{
    self.edit_rateMenu_slider.value = rate;
    [_edit_rateMenu_tipsButton setTitle:kToolbar_RateTips(rate) forState:UIControlStateNormal];
}

#pragma mark - JRPickColorViewDelegate
- (void)JRPickColorView:(JRPickColorView *)pickColorView didSelectColor:(UIColor *)color
{
    self.edit_drawMenu_color.backgroundColor = color;
    if ([self.delegate respondsToSelector:@selector(lf_editToolbar:drawColorDidChange:)]) {
        [self.delegate lf_editToolbar:self drawColorDidChange:color];
    }
}

#pragma mark - public对外
- (void)selectMainMenuIndex:(NSUInteger)index
{
    UIButton *button = [self.edit_menu viewWithTag:index];
    if ([button isKindOfClass:[UIButton class]]) {
        [self edit_toolBar_buttonClick:button];
    }
}

/** 设置默认模糊类型 */
- (void)setSplashIndex:(NSUInteger)index
{
    UIView *view = [self.edit_splashMenu viewWithTag:index+1];
    if ([view isKindOfClass:[UIButton class]]) {
        [self splashMenu_buttonClick:(UIButton *)view];
    }
}

/** 设置模糊等待状态 */
- (void)setSplashWait:(BOOL)isWait index:(NSUInteger)index
{
    UIView *view = [self.edit_splashMenu viewWithTag:index+1];
    if ([view isKindOfClass:[UIButton class]]) {
        NSInteger tag = 100 + view.tag;
        if (isWait) {
            if ([view.superview viewWithTag:tag]) {
                return;
            }
            UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            aiView.frame = view.frame;
            aiView.tag = tag;
            [aiView startAnimating];
            [view.superview addSubview:aiView];
            view.hidden = YES;
        } else {
            [[view.superview viewWithTag:tag] removeFromSuperview];
            view.hidden = NO;
        }
    }
}

@end
