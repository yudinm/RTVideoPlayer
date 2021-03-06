//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKVideoPlayer.h"
#import "VKVideoPlayerConfig.h"
#import "VKVideoPlayerCaption.h"
#import "VKVideoPlayerSettingsManager.h"
#import "VKVideoPlayerLayerView.h"
#import "VKVideoPlayerTrack.h"
#import "NSObject+VKFoundation.h"
#import "VKVideoPlayerExternalMonitor.h"


#define VKCaptionPadding 10
#define degreesToRadians(x) (M_PI * x / 180.0f)

//#ifdef DEBUG
//static const int ddLogLevel = DDLogLevelWarning;
//#else
//static const int ddLogLevel = DDLogLevelWarning;
//#endif

NSString *kTracksKey		= @"tracks";
NSString *kPlayableKey		= @"playable";

static const NSString *ItemStatusContext;


typedef enum {
    VKVideoPlayerCaptionPositionTop = 1111,
    VKVideoPlayerCaptionPositionBottom
} VKVideoPlayerCaptionPosition;

@interface VKVideoPlayer()
@property (nonatomic, assign) BOOL scrubbing;
@property (nonatomic, assign) NSTimeInterval beforeSeek;
@property (nonatomic, assign) NSTimeInterval previousPlaybackTime;
@property (nonatomic, assign) double previousIndicatedBandwidth;

@property (nonatomic, strong) id timeObserver;

@property (nonatomic, strong) id<VKVideoPlayerCaptionProtocol> captionTop;
@property (nonatomic, strong) id<VKVideoPlayerCaptionProtocol> captionBottom;
@property (nonatomic, strong) id captionTopTimer;
@property (nonatomic, strong) id captionBottomTimer;


@end


@implementation VKVideoPlayer

- (id)init {
    self = [super init];
    if (self) {
        self.view = [[VKVideoPlayerView alloc] init];
        [self initialize];
    }
    return self;
}

- (id)initWithVideoPlayerView:(VKVideoPlayerView*)videoPlayerView {
    self = [super init];
    if (self) {
        self.view = videoPlayerView;
        [self initialize];
    }
    return self;
}

- (void)dealloc {
    [self removeObservers];
    
    [self.externalMonitor deactivate];
    
    self.timeObserver = nil;
    self.avPlayer = nil;
    self.captionTop = nil;
    self.captionBottom = nil;
    self.captionTopTimer = nil;
    self.captionBottomTimer = nil;
    
    self.playerItem = nil;
    
    [self pauseContent];
}

#pragma mark - initialize
- (void)initialize {
    [self initializeProperties];
    [self initializePlayerView];
    [self addObservers];
}

- (void)initializeProperties {
    self.state = VKVideoPlayerStateUnknown;
    self.scrubbing = NO;
    self.beforeSeek = 0.0;
    self.previousPlaybackTime = 0;
}

- (void)initializePlayerView {
    self.view.delegate = self;
    [self.view setPlayButtonsSelected:NO];
    [self.view.scrubber setValue:0.0f animated:NO];
    self.view.controlHideCountdown = [self.view.playerControlsAutoHideTime integerValue];
}

- (void)loadCurrentVideoTrack {
    __weak __typeof__(self) weakSelf = self;
    RUN_ON_UI_THREAD(^{
        [weakSelf playVideoTrack:self.videoTrack];
    });
}

#pragma mark - Error Handling

- (NSString*)videoPlayerErrorCodeToString:(VKVideoPlayerErrorCode)code {
    switch (code) {
        case kVideoPlayerErrorVideoBlocked:
            return @"kVideoPlayerErrorVideoBlocked";
            break;
        case kVideoPlayerErrorFetchStreamError:
            return @"kVideoPlayerErrorFetchStreamError";
            break;
        case kVideoPlayerErrorStreamNotFound:
            return @"kVideoPlayerErrorStreamNotFound";
            break;
        case kVideoPlayerErrorAssetLoadError:
            return @"kVideoPlayerErrorAssetLoadError";
            break;
        case kVideoPlayerErrorDurationLoadError:
            return @"kVideoPlayerErrorDurationLoadError";
            break;
        case kVideoPlayerErrorAVPlayerFail:
            return @"kVideoPlayerErrorAVPlayerFail";
            break;
        case kVideoPlayerErrorAVPlayerItemFail:
            return @"kVideoPlayerErrorAVPlayerItemFail";
            break;
        case kVideoPlayerErrorUnknown:
        default:
            return @"kVideoPlayerErrorUnknown";
            break;
    }
}

- (void)handleErrorCode:(VKVideoPlayerErrorCode)errorCode track:(id<VKVideoPlayerTrackProtocol>)track {
    [self handleErrorCode:errorCode track:track customMessage:nil];
}

- (void)handleErrorCode:(VKVideoPlayerErrorCode)errorCode track:(id<VKVideoPlayerTrackProtocol>)track customMessage:(NSString*)customMessage {
    RUN_ON_UI_THREAD(^{
        if ([self.delegate respondsToSelector:@selector(handleErrorCode:track:customMessage:)]) {
            [self.delegate handleErrorCode:errorCode track:track customMessage:customMessage];
        }
    });
}

#pragma mark - KVO

- (void)setTimeObserver:(id)timeObserver {
    if (_timeObserver) {
//        DDLogVerbose(@"TimeObserver: remove %@", _timeObserver);
        [self.avPlayer removeTimeObserver:_timeObserver];
    }
    _timeObserver = timeObserver;
    if (timeObserver) {
//        DDLogVerbose(@"TimeObserver: setup %@", _timeObserver);
    }
}

- (void)setCaptionBottomTimer:(id)captionBottomTimer {
    if (_captionBottomTimer) [self.avPlayer removeTimeObserver:_captionBottomTimer];
    _captionBottomTimer = captionBottomTimer;
}

- (void)setCaptionTopTimer:(id)captionTopTimer {
    if (_captionTopTimer) [self.avPlayer removeTimeObserver:_captionTopTimer];
    _captionTopTimer = captionTopTimer;
}

- (void)addObservers {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    [defaultCenter addObserver:self selector:@selector(playerItemReadyToPlay) name:kVKVideoPlayerItemReadyToPlay object:nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults addObserver:self forKeyPath:kVKSettingsSubtitlesEnabledKey options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    [defaults addObserver:self forKeyPath:kVKSettingsTopSubtitlesEnabledKey options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    [defaults addObserver:self forKeyPath:kVKSettingsSubtitleLanguageCodeKey options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    [defaults addObserver:self forKeyPath:kVKVideoQualityKey options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObserver:self forKeyPath:kVKSettingsSubtitlesEnabledKey];
    [defaults removeObserver:self forKeyPath:kVKSettingsTopSubtitlesEnabledKey];
    [defaults removeObserver:self forKeyPath:kVKSettingsSubtitleLanguageCodeKey];
    [defaults removeObserver:self forKeyPath:kVKVideoQualityKey];
    
}

- (NSString*)observedBitrateBucket:(NSNumber*)observedKbps {
    NSString* observedKbpsString = @"";
    if ([observedKbps integerValue] <= 100) {
        observedKbpsString = @"0-100";
    } else if ([observedKbps integerValue] <= 200) {
        observedKbpsString = @"101-200";
    } else if ([observedKbps integerValue] <= 400) {
        observedKbpsString = @"201-400";
    } else if ([observedKbps integerValue] <= 600) {
        observedKbpsString = @"401-600";
    } else if ([observedKbps integerValue] <= 800) {
        observedKbpsString = @"601-800";
    } else if ([observedKbps integerValue] <= 1000) {
        observedKbpsString = @"801-1000";
    } else if ([observedKbps integerValue] > 1000) {
        observedKbpsString = @">1000";
    }
    return observedKbpsString;
}

- (void)periodicTimeObserver:(CMTime)time {
    NSTimeInterval timeInSeconds = CMTimeGetSeconds(time);
    NSTimeInterval lastTimeInSeconds = _previousPlaybackTime;
    
    if (timeInSeconds <= 0) {
        return;
    }
    
    if ([self isPlayingVideo]) {
        NSTimeInterval interval = fabs(timeInSeconds - _previousPlaybackTime);
        if (interval < 2 ) {
            if (self.captionBottom) {
                //                VKVideoPlayerView* playerView = [self activePlayerView];
                //                [self updateCaptionView:playerView.captionBottomView caption:self.captionBottom playerView:playerView];
            }
        }
        
        _previousPlaybackTime = timeInSeconds;
    }
    
    if ([self.player currentItemDuration] > 1) {
        NSDictionary *info = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:timeInSeconds] forKey:@"scrubberValue"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kVKVideoPlayerScrubberValueUpdatedNotification object:self userInfo:info];
        
        NSDictionary *durationInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:self.track.hasPrevious], @"hasPreviousVideo",
                                      [NSNumber numberWithBool:self.track.hasNext], @"hasNextVideo",
                                      [NSNumber numberWithDouble:[self.player currentItemDuration]], @"duration",
                                      nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kVKVideoPlayerDurationDidLoadNotification object:self userInfo:durationInfo];
    }
    
    [self.view hideControlsIfNecessary];
    
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didPlayFrame:time:lastTime:)]) {
        [self.delegate videoPlayer:self didPlayFrame:self.track time:timeInSeconds lastTime:lastTimeInSeconds];
    }
    
    //增加加载进度
    //    NSLog(@"加载进度:%f",);
    [self.activePlayerView.progressBar setValue:[self availableDuration] animated:YES];
}

// 计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.avPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    
    if ([self.player currentItemDuration] > 1) {
        result = [self.player currentItemDuration] - result < 1 ? [self.player currentItemDuration] : result;
    }
    
    return result;
}

- (void)seekToTimeInSecond:(float)sec userAction:(BOOL)isUserAction completionHandler:(void (^)(BOOL finished))completionHandler {
    [self scrubbingBegin];
    [self scrubbingEndAtSecond:sec userAction:isUserAction completionHandler:completionHandler];
}

- (void)scrubbingEndAtSecond:(float)sec userAction:(BOOL)isUserAction completionHandler:(void (^)(BOOL finished))completionHandler {
    [self.player seekToTimeInSeconds:sec completionHandler:completionHandler];
}


#pragma mark - Playback position

- (void)seekToLastWatchedDuration {
    RUN_ON_UI_THREAD(^{
        
        [self.view setPlayButtonsEnabled:NO];
        
        CGFloat lastWatchedTime = [self.track.lastDurationWatchedInSeconds floatValue];
        if (lastWatchedTime > 5) lastWatchedTime -= 5;
        
//        DDLogVerbose(@"Seeking to last watched duration: %f", lastWatchedTime);
        [self.view.scrubber setValue:([self.player currentItemDuration] > 0) ? lastWatchedTime / [self.player currentItemDuration] : 0.0f animated:NO];
        
        [self.player seekToTimeInSeconds:lastWatchedTime completionHandler:^(BOOL finished) {
            if (finished) [self playContent];
            [self.view setPlayButtonsEnabled:YES];
            
            if ([self.delegate respondsToSelector:@selector(videoPlayer:didStartVideo:)]) {
                [self.delegate videoPlayer:self didStartVideo:self.track];
            }
        }];
        
    });
}

- (void)playerDidPlayToEnd:(NSNotification *)notification {
//    DDLogVerbose(@"Player: Did play to the end");
    RUN_ON_UI_THREAD(^{
        
        self.track.isPlayedToEnd = YES;
        self.activePlayerView.playButton.hidden = YES;
        self.activePlayerView.replayButton.hidden = NO;
        [self.activePlayerView setControlsHidden:NO];
        [self pauseContent:NO completionHandler:^{
            if ([self.delegate respondsToSelector:@selector(videoPlayer:didPlayToEnd:)]) {
                [self.delegate videoPlayer:self didPlayToEnd:self.track];
            }
        }];
        
    });
}

#pragma mark - AVPlayer wrappers

- (BOOL)isPlayingVideo {
    return (self.avPlayer && self.avPlayer.rate != 0.0);
}


#pragma mark - Airplay

- (VKVideoPlayerView*)activePlayerView {
    if (self.externalMonitor.isConnected) {
        return self.externalMonitor.externalView;
    } else {
        return self.view;
    }
}

- (BOOL)isPlayingOnExternalDevice {
    return self.externalMonitor.isConnected;
}

#pragma mark - Hundle Videos
- (void)loadVideoWithTrack:(id<VKVideoPlayerTrackProtocol>)track {
    self.track = track;
    self.state = VKVideoPlayerStateContentLoading;
    
    VoidBlock completionHandler = ^{
        [self playVideoTrack:self.track];
    };
    switch (self.state) {
        case VKVideoPlayerStateError:
        case VKVideoPlayerStateContentPaused:
        case VKVideoPlayerStateContentLoading:
            completionHandler();
            break;
        case VKVideoPlayerStateContentPlaying:
            [self pauseContent:NO completionHandler:completionHandler];
            break;
        default:
            break;
    };
}
- (void)loadVideoWithStreamURL:(NSURL*)streamURL {
    [self loadVideoWithTrack:[[VKVideoPlayerTrack alloc] initWithStreamURL:streamURL]];
}

- (void)setTrack:(id<VKVideoPlayerTrackProtocol>)track {
    
    _track = track;
    [self clearPlayer];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kVKVideoPlayerUpdateVideoTrack object:track];
}


- (void)clearPlayer {
    self.playerItem = nil;
    self.avPlayer = nil;
    self.player = nil;
}

- (void)playVideoTrack:(id<VKVideoPlayerTrackProtocol>)track {
    
    [self.activePlayerView resetTimeLabelsInit]; // add by vince
    if ([self.delegate respondsToSelector:@selector(shouldVideoPlayer:startVideo:)]) {
        if (![self.delegate shouldVideoPlayer:self startVideo:track]) {
            return;
        }
    }
    [self clearPlayer];
    
    NSURL *streamURL = [track streamURL];
    if (!streamURL) {
        return;
    }
    
    [self playOnAVPlayer:streamURL playerLayerView:[self activePlayerView].playerLayerView track:track];
}

- (void)playOnAVPlayer:(NSURL*)streamURL playerLayerView:(VKVideoPlayerLayerView*)playerLayerView track:(id<VKVideoPlayerTrackProtocol>)track {
    
    if (!track.isVideoLoadedBefore) {
        track.isVideoLoadedBefore = YES;
    }
    
    AVURLAsset* asset = [[AVURLAsset alloc] initWithURL:streamURL options:@{ AVURLAssetPreferPreciseDurationAndTimingKey : @YES }];
    [asset loadValuesAsynchronouslyForKeys:@[kTracksKey, kPlayableKey] completionHandler:^{
        // Completion handler block.
        RUN_ON_UI_THREAD(^{
            if (self.state == VKVideoPlayerStateDismissed) return;
            if (![asset.URL.absoluteString isEqualToString:streamURL.absoluteString]) {
//                DDLogVerbose(@"Ignore stream load success. Requested to load: %@ but the current stream should be %@.", asset.URL.absoluteString, streamURL.absoluteString);
                return;
            }
            NSError *error = nil;
            AVKeyValueStatus status = [asset statusOfValueForKey:kTracksKey error:&error];
            if (status == AVKeyValueStatusLoaded) {
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                self.avPlayer = [self playerWithPlayerItem:self.playerItem];
                self.player = (id<VKPlayer>)self.avPlayer;
                [playerLayerView setPlayer:self.avPlayer];
                
            } else {
                // You should deal with the error appropriately.
                [self handleErrorCode:kVideoPlayerErrorAssetLoadError track:track];
//                DDLogWarn(@"The asset's tracks were not loaded:\n%@", error);
            }
        });
    }];
}

- (void)playerItemReadyToPlay {
    
//    DDLogVerbose(@"Player: playerItemReadyToPlay");
    
    RUN_ON_UI_THREAD(^{
        switch (self.state) {
            case VKVideoPlayerStateContentPaused:
                break;
            case VKVideoPlayerStateContentLoading:{}
            case VKVideoPlayerStateError:{
                [self pauseContent:NO completionHandler:^{
                    if ([self.delegate respondsToSelector:@selector(videoPlayer:willStartVideo:)]) {
                        [self.delegate videoPlayer:self willStartVideo:self.track];
                    }
                    [self seekToLastWatchedDuration];
                }];
                break;
            }
            default:
                break;
        }
    });
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    _playerItem = playerItem;
    _previousIndicatedBandwidth = 0.0f;
    
    if (!playerItem) {
        return;
    }
    [_playerItem addObserver:self forKeyPath:@"status" options:0 context:&ItemStatusContext];
    [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    
}

- (void)setAvPlayer:(AVPlayer *)avPlayer {
    self.timeObserver = nil;
    self.captionTopTimer = nil;
    self.captionBottomTimer = nil;
    [_avPlayer removeObserver:self forKeyPath:@"status"];
    _avPlayer = avPlayer;
    if (avPlayer) {
        __weak __typeof(self) weakSelf = self;
        [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
        self.timeObserver = [avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time){
            [weakSelf periodicTimeObserver:time];
        }];
    }
}

- (AVPlayer*)playerWithPlayerItem:(AVPlayerItem*)playerItem {
    AVPlayer* player = [AVPlayer playerWithPlayerItem:playerItem];
    if ([player respondsToSelector:@selector(setAllowsExternalPlayback:)]) player.allowsExternalPlayback = YES;
    if ([player respondsToSelector:@selector(setUsesExternalPlaybackWhileExternalScreenIsActive:)]) player.usesExternalPlaybackWhileExternalScreenIsActive = YES;
    return player;
}

- (void)reloadCurrentVideoTrack {
    RUN_ON_UI_THREAD(^{
        VoidBlock completionHandler = ^{
            self.state = VKVideoPlayerStateContentLoading;
            [self loadCurrentVideoTrack];
        };
        
        switch (self.state) {
            case VKVideoPlayerStateUnknown:
            case VKVideoPlayerStateContentLoading:
            case VKVideoPlayerStateContentPaused:
            case VKVideoPlayerStateError:
//                DDLogVerbose(@"Reload stream now.");
                completionHandler();
                break;
            case VKVideoPlayerStateContentPlaying:
//                DDLogVerbose(@"Reload stream after pause.");
                [self pauseContent:NO completionHandler:completionHandler];
                break;
            case VKVideoPlayerStateDismissed:
            case VKVideoPlayerStateSuspend:
                break;
        }
    });
}

- (float)currentBitRateInKbps {
    return [self.playerItem.accessLog.events.lastObject observedBitrate]/1000;
}


#pragma mark -

- (NSTimeInterval)currentTime {
    if (!self.track.isVideoLoadedBefore) {
        return [self.track.lastDurationWatchedInSeconds doubleValue] > 0 ? [self.track.lastDurationWatchedInSeconds doubleValue] : 0.0f;
    } else return CMTimeGetSeconds([self.player currentCMTime]);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [NSUserDefaults standardUserDefaults]) {
        if ([keyPath isEqualToString:kVKSettingsSubtitlesEnabledKey]) {
            NSString  *fromLang, *toLang;
            if ([[change valueForKeyPath:NSKeyValueChangeNewKey] boolValue]) {
                fromLang = @"null";
                toLang = VKSharedVideoPlayerSettingsManager.subtitleLanguageCode;
            } else {
                self.captionBottomTimer = nil;
                self.captionBottom = nil;
                fromLang = VKSharedVideoPlayerSettingsManager.subtitleLanguageCode;
                toLang = @"null";
            }
            
            if ([self.delegate respondsToSelector:@selector(videoPlayer:didChangeSubtitleFrom:to:)]) {
                [self.delegate videoPlayer:self didChangeSubtitleFrom:fromLang to:toLang];
            }
        }
    }
    
    if (object == self.avPlayer) {
        if ([keyPath isEqualToString:@"status"]) {
            switch ([self.avPlayer status]) {
                case AVPlayerStatusReadyToPlay:
//                    DDLogVerbose(@"AVPlayerStatusReadyToPlay");
                    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kVKVideoPlayerItemReadyToPlay object:nil];
                    }
                    break;
                case AVPlayerStatusFailed:
//                    DDLogVerbose(@"AVPlayerStatusFailed");
                    [self handleErrorCode:kVideoPlayerErrorAVPlayerFail track:self.track];
                default:
                    break;
            }
        }
    }
    
    if (object == self.playerItem) {
        if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            if (self.playerItem.isPlaybackBufferEmpty && [self.delegate respondsToSelector:@selector(videoPlayer:isBuffering:)]) {
                [self.delegate videoPlayer:self isBuffering:YES];
            }
            
//            DDLogVerbose(@"playbackBufferEmpty: %@", self.playerItem.isPlaybackBufferEmpty ? @"yes" : @"no");
            if (self.playerItem.isPlaybackBufferEmpty && [self currentTime] > 0 && [self currentTime] < [self.player currentItemDuration] - 1 && self.state == VKVideoPlayerStateContentPlaying) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kVKVideoPlayerPlaybackBufferEmpty object:nil];
            }
        }
        if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            if (self.view.window == nil) {
                self.state = VKVideoPlayerStateContentPaused;
                return;
            }
            if (self.playerItem.playbackLikelyToKeepUp && [self.delegate respondsToSelector:@selector(videoPlayer:isBuffering:)]) {
                [self.delegate videoPlayer:self isBuffering:NO];
            }
            
//            DDLogVerbose(@"playbackLikelyToKeepUp: %@", self.playerItem.playbackLikelyToKeepUp ? @"yes" : @"no");
            if (self.playerItem.playbackLikelyToKeepUp) {
                if (self.state == VKVideoPlayerStateContentPlaying && ![self isPlayingVideo]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kVKVideoPlayerPlaybackLikelyToKeepUp object:nil];
                    [self.player play];
                }
            }
        }
        if ([keyPath isEqualToString:@"status"]) {
            switch ([self.playerItem status]) {
                case AVPlayerItemStatusReadyToPlay:
//                    DDLogVerbose(@"AVPlayerItemStatusReadyToPlay");
                    if ([self.avPlayer status] == AVPlayerStatusReadyToPlay) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kVKVideoPlayerItemReadyToPlay object:nil];
                    }
                    break;
                case AVPlayerItemStatusFailed:
//                    DDLogVerbose(@"AVPlayerItemStatusFailed");
                    [self handleErrorCode:kVideoPlayerErrorAVPlayerItemFail track:self.track];
                default:
                    break;
            }
        }
    }
}

#pragma mark - Controls

- (NSString*)playerStateDescription:(VKVideoPlayerState)playerState {
    switch (playerState) {
        case VKVideoPlayerStateUnknown:
            return @"Unknown";
            break;
        case VKVideoPlayerStateContentLoading:
            return @"ContentLoading";
            break;
        case VKVideoPlayerStateContentPaused:
            return @"ContentPaused";
            break;
        case VKVideoPlayerStateContentPlaying:
            return @"ContentPlaying";
            break;
        case VKVideoPlayerStateSuspend:
            return @"Player Stay";
            break;
        case VKVideoPlayerStateDismissed:
            return @"Player Dismissed";
            break;
        case VKVideoPlayerStateError:
            return @"Player Error";
            break;
    }
}


- (void)setState:(VKVideoPlayerState)newPlayerState {
    if ([self.delegate respondsToSelector:@selector(shouldVideoPlayer:changeStateTo:)]) {
        if (![self.delegate shouldVideoPlayer:self changeStateTo:newPlayerState]) {
            return;
        }
    }
    RUN_ON_UI_THREAD(^{
        if ([self.delegate respondsToSelector:@selector(videoPlayer:willChangeStateTo:)]) {
            [self.delegate videoPlayer:self willChangeStateTo:newPlayerState];
        }
        
        VKVideoPlayerState oldPlayerState = self.state;
        if (oldPlayerState == newPlayerState) return;
        
        switch (oldPlayerState) {
            case VKVideoPlayerStateContentLoading:
                [self setLoading:NO];
                break;
            case VKVideoPlayerStateContentPlaying:
                //                self.view.playButton.playing = NO;
                break;
            case VKVideoPlayerStateContentPaused:
                //                self.view.playButton.playing = YES;
                break;
            case VKVideoPlayerStateDismissed:
                break;
            case VKVideoPlayerStateError:
                break;
            default:
                break;
        }
        
//        DDLogVerbose(@"Player State: %@ -> %@", [self playerStateDescription:self.state], [self playerStateDescription:newPlayerState]);
        _state = newPlayerState;
        
        switch (newPlayerState) {
            case VKVideoPlayerStateUnknown:
                break;
            case VKVideoPlayerStateContentLoading:
                [self setLoading:YES];
                self.playerControlsEnabled = NO;
                break;
            case VKVideoPlayerStateContentPlaying: {
                self.view.controlHideCountdown = [self.view.playerControlsAutoHideTime integerValue];
                self.playerControlsEnabled = YES;
                [self.view setPlayButtonsSelected:NO];
                self.view.playerLayerView.hidden = NO;
                [self.player play];
            } break;
            case VKVideoPlayerStateContentPaused:
                self.playerControlsEnabled = YES;
                [self.view setPlayButtonsSelected:YES];
                self.view.playerLayerView.hidden = NO;
                self.track.lastDurationWatchedInSeconds = [NSNumber numberWithFloat:[self currentTime]];
                [self.player pause];
                break;
            case VKVideoPlayerStateSuspend:
                [self setLoading:YES];
                break;
            case VKVideoPlayerStateError:{
                [self.player pause];
                self.view.playerLayerView.hidden = YES;
                self.playerControlsEnabled = NO;
                self.view.controlHideCountdown = kPlayerControlsDisableAutoHide;
                break;
            }
            case VKVideoPlayerStateDismissed:
                self.view.playerLayerView.hidden = YES;
                self.playerControlsEnabled = NO;
                self.avPlayer = nil;
                self.playerItem = nil;
                break;
        }
        
        if ([self.delegate respondsToSelector:@selector(videoPlayer:didChangeStateFrom:)]) {
            [self.delegate videoPlayer:self didChangeStateFrom:oldPlayerState];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kVKVideoPlayerStateChanged object:nil userInfo:@{
                                                                                                                    @"oldState":[NSNumber numberWithInteger:oldPlayerState],
                                                                                                                    @"newState":[NSNumber numberWithInteger:newPlayerState]
                                                                                                                    }];
    });
}

- (void)playContent {
    RUN_ON_UI_THREAD(^{
        if (self.state == VKVideoPlayerStateContentPaused) {
            self.state = VKVideoPlayerStateContentPlaying;
            self.view.playButton.playing = YES;
        }
    });
}

- (void)pauseContent {
    [self pauseContent:NO completionHandler:nil];
}

- (void)pauseContentWithCompletionHandler:(void (^)())completionHandler {
    [self pauseContent:NO completionHandler:completionHandler];
}

- (void)pauseContent:(BOOL)isUserAction completionHandler:(void (^)())completionHandler {
    
    RUN_ON_UI_THREAD(^{
        self.view.playButton.playing = NO;
        
        switch ([self.playerItem status]) {
            case AVPlayerItemStatusFailed:
                self.state = VKVideoPlayerStateError;
                return;
                break;
            case AVPlayerItemStatusUnknown:
//                DDLogVerbose(@"Trying to pause content but AVPlayerItemStatusUnknown.");
                self.state = VKVideoPlayerStateContentLoading;
                return;
                break;
            default:
                break;
        }
        
        switch ([self.avPlayer status]) {
            case AVPlayerStatusFailed:
                self.state = VKVideoPlayerStateError;
                return;
                break;
            case AVPlayerStatusUnknown:
//                DDLogVerbose(@"Trying to pause content but AVPlayerStatusUnknown.");
                self.state = VKVideoPlayerStateContentLoading;
                return;
                break;
            default:
                break;
        }
        
        switch (self.state) {
            case VKVideoPlayerStateContentLoading:
            case VKVideoPlayerStateContentPlaying:
            case VKVideoPlayerStateContentPaused:
            case VKVideoPlayerStateSuspend:
            case VKVideoPlayerStateError:
                self.state = VKVideoPlayerStateContentPaused;
                if (completionHandler) completionHandler();
                break;
            default:
                break;
        }
    });
}

- (void)setPlayerControlsEnabled:(BOOL)enabled {
    [self.view setControlsEnabled:enabled];
}

#pragma mark - VKScrubberDelegate

- (void)scrubbingBegin {
    [self pauseContent:NO completionHandler:^{
        _scrubbing = YES;
        self.view.controlHideCountdown = -1;
        _beforeSeek = [self currentTime];
    }];
}

- (void)scrubbingEnd {
    _scrubbing = NO;
    float afterSeekTime = self.view.scrubber.value;
    [self scrubbingEndAtSecond:afterSeekTime userAction:YES completionHandler:^(BOOL finished) {
        if (finished) [self playContent];
    }];
}

- (void)scrubberValueChanged;
{
    self.activePlayerView.replayButton.hidden = YES;
    self.activePlayerView.playButton.hidden = NO;
}

- (void)zoomInPressed {
    ((AVPlayerLayer *)self.view.layer).videoGravity = AVLayerVideoGravityResizeAspectFill;
    if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"5"]) {
        self.view.frame = self.view.frame;
    }
}

- (void)zoomOutPressed {
    ((AVPlayerLayer *)self.view.layer).videoGravity = AVLayerVideoGravityResizeAspect;
    if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"5"]) {
        self.view.frame = self.view.frame;
    }
}

#pragma mark - VKVideoPlayerViewDelegate
- (id<VKVideoPlayerTrackProtocol>)videoTrack {
    return self.track;
}

- (void)videoQualityButtonTapped {
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
        [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventTapVideoQuality];
    }
}

- (void)fullScreenButtonTapped {
    // self.fullScreen = !self.fullScreen;
    
    
    //    if (self.isFullScreen) {
    //        [self performOrientationChange:UIInterfaceOrientationLandscapeRight];
    //    } else {
    //        [self performOrientationChange:UIInterfaceOrientationPortrait];
    //    }
    
    
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
        [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventTapFullScreen];
    }
}

- (void)setFullScreen:(BOOL)fullScreen; {
    _fullScreen = fullScreen;
    self.view.fullscreenButton.fullScreen = fullScreen;
}

- (void)captionButtonTapped {
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
        [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventTapCaption];
    }
}

- (void)playButtonPressed {
    [self playContent];
}

- (void)replayButtonPressed {
    [self reloadCurrentVideoTrack];
}

- (void)pauseButtonPressed {
    switch (self.state) {
        case VKVideoPlayerStateContentPlaying:
            [self pauseContent:YES completionHandler:nil];
            break;
        default:
            break;
    }
}

- (void)downloadButtonPressed {
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
        [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventDownload];
    }
}

- (void)nextTrackButtonPressed {
    if (self.track.hasNext) {
        if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
            [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventTapNext];
        }
    }
}

- (void)previousTrackButtonPressed {
    if (self.track.hasPrevious) {
        if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
            [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventTapPrevious];
        }
    }
}

- (void)nextTrackBySwipe {
    if (self.track.hasNext) {
        if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
            [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventSwipeNext];
        }
    }
}

- (void)previousTrackBySwipe {
    if (self.track.hasPrevious) {
        if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
            [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventSwipePrevious];
        }
    }
}

- (void)rewindButtonPressed {
    
    float seekToTime = [self currentTime] - 30;
    [self seekToTimeInSecond:seekToTime userAction:YES completionHandler:^(BOOL finished) {
        if (finished) [self playContent];
    }];
}

- (void)doneButtonTapped {
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
        [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventTapDone];
    }
}

- (void)playerViewSingleTapped {
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
        [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventTapPlayerView];
    }
}

- (void)presentSubtitleLangaugePickerFromButton:(VKPickerButton*)button {
    if ([self.delegate respondsToSelector:@selector(videoPlayer:didControlByEvent:)]) {
        [self.delegate videoPlayer:self didControlByEvent:VKVideoPlayerControlEventTapDone];
    }
}

- (void)pinchIn;
{
    [self.delegate handlePinchIn:self];
}

- (void)pinchOut;
{
    [self.delegate handlePinchOut:self];
}


#pragma mark - Auto hide controls

- (void)setLoading:(BOOL)loading {
    if (loading) {
        [self.view.activityIndicator startAnimating];
        [self.view.playButton setHidden:YES];
    } else {
        [self.view.activityIndicator stopAnimating];
        [self.view.playButton setHidden:NO];
    }
}

#pragma mark - Handle volume change

- (void)volumeChanged:(NSNotification *)notification {
    self.view.controlHideCountdown = [self.view.playerControlsAutoHideTime integerValue];
}



#pragma mark - Remote Control Events handler

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self playButtonPressed];
                break;
            case UIEventSubtypeRemoteControlPause:
                [self pauseButtonPressed];
            case UIEventSubtypeRemoteControlStop:
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self nextTrackButtonPressed];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self previousTrackButtonPressed];
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                [self scrubbingBegin];
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                self.view.scrubber.value = receivedEvent.timestamp;
                [self scrubbingEnd];
                break;
            default:
                break;
        }
    }
}

@end


@implementation AVPlayer (VKPlayer)

- (void)seekToTimeInSeconds:(float)time completionHandler:(void (^)(BOOL finished))completionHandler {
    if ([self respondsToSelector:@selector(seekToTime:toleranceBefore:toleranceAfter:completionHandler:)]) {
        [self seekToTime:CMTimeMakeWithSeconds(time, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
    } else {
        [self seekToTime:CMTimeMakeWithSeconds(time, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        completionHandler(YES);
    }
}

- (NSTimeInterval)currentItemDuration {
    return CMTimeGetSeconds([self.currentItem duration]);
}

- (CMTime)currentCMTime {
    return [self currentTime];
}

@end

