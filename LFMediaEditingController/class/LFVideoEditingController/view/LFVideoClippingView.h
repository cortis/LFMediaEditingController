//
//  LFVideoClippingView.h
//  LFMediaEditingController
//
//  Created by LamTsanFeng on 2017/7/17.
//  Copyright © 2017年 LamTsanFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LFScrollView.h"
#import "LFEditingProtocol.h"

@class LFFilter;

@protocol LFVideoClippingViewDelegate;

@interface LFVideoClippingView : LFScrollView <LFEditingProtocol>

@property (nonatomic, weak) id<LFVideoClippingViewDelegate> _Nullable clipDelegate;


/** 开始播放时间 */
@property (nonatomic, assign) double startTime;
/** 结束播放时间 */
@property (nonatomic, assign) double endTime;
/** 视频总时长 */
@property (nonatomic, readonly) double totalDuration;
/** 是否正在设置进度 */
@property (nonatomic, readonly) BOOL isScrubbing;
/** 是否存在水印 */
@property (nonatomic, readonly) BOOL hasWatermark;
/** 水印层 */
@property (nonatomic, weak, readonly) UIView * _Nullable overlayView;
/** 滤镜 */
@property (nonatomic, readonly, nullable) LFFilter *filter;

/** 数据 */
- (void)setVideoAsset:(AVAsset *_Nonnull)asset placeholderImage:(UIImage *_Nonnull)image;

/** 剪切范围 */
@property (nonatomic, assign) CGRect cropRect;

/** 播放速率 */
@property (nonatomic, assign) float rate;

/** 保存 */
- (void)save;
/** 取消 */
- (void)cancel;

/** 播放 */
- (void)playVideo;
/** 暂停 */
- (void)pauseVideo;
/** 静音原音 */
- (void)muteOriginalVideo:(BOOL)mute;
/** 是否播放 */
- (BOOL)isPlaying;
/** 重新播放 */
- (void)replayVideo;
/** 重置视频 */
- (void)resetVideoDisplay;
/** 增加音效 */
- (void)setAudioMix:(NSArray <NSURL *>*_Nullable)audioMix;

/** 移动到某帧 */
- (void)beginScrubbing;
- (void)seekToTime:(CGFloat)time;
- (void)endScrubbing;

@end

@protocol LFVideoClippingViewDelegate <NSObject>

/** 视频准备完毕，可以获取相关属性与操作 */
- (void)lf_videLClippingViewReadyToPlay:(LFVideoClippingView *_Nonnull)clippingView;
/** 进度回调 */
- (void)lf_videoClippingView:(LFVideoClippingView *_Nonnull)clippingView duration:(double)duration;
/** 进度长度 */
- (CGFloat)lf_videoClippingViewProgressWidth:(LFVideoClippingView *_Nonnull)clippingView;

@end
