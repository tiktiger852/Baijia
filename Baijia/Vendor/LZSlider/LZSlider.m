//
//  LZSlider.m
//  LZSlider
//
//  Created by mac on 12/2/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import "LZSlider.h"
#import <QuartzCore/QuartzCore.h>

@interface LZSlider()

@property (nonatomic, strong) UIImageView *trackImageView;
@property (nonatomic, strong) UIImageView *bufferImageView;
@property (nonatomic, strong) UIView *progressView;


@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) CGFloat touchPointX;
@property (nonatomic, assign) CGFloat moveOffsetX;
@property (nonatomic, assign) CGFloat dotViewCenterX;

@end

@implementation LZSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    
    self.trackImageView = [UIImageView new];
    [self addSubview:self.trackImageView];
    
    self.bufferImageView = [UIImageView new];
    [self addSubview:self.bufferImageView];
    
    self.progressView = [UIView new];
    [self addSubview:self.progressView];
    
    [self addSubview:self.dotView];
    
    self.progressWidth = 2.0;
    self.dotWidth = 30;
    self.dotHeight = 30;
    self.activityStyle = UIActivityIndicatorViewStyleWhite;
}

- (void)setTrack {
    _trackImageView.frame = CGRectMake(self.dotWidth/2, (self.frame.size.height - _progressWidth)/2, self.frame.size.width - self.dotWidth, _progressWidth);
    _trackImageView.layer.cornerRadius = _progressWidth/2;
}

- (void)setBuffer {
    CGFloat offsetX = (self.frame.size.width - self.dotWidth) * _buffer;
    
    _bufferImageView.frame = CGRectMake(self.dotWidth/2, (self.frame.size.height - _progressWidth)/2, offsetX, _progressWidth);
    _bufferImageView.layer.cornerRadius = _progressWidth/2;
}

- (void)setProgress {
    CGFloat offsetX = (self.frame.size.width - self.dotWidth) * _progress;

    _progressView.frame = CGRectMake(self.dotWidth/2, (self.frame.size.height - _progressWidth)/2, offsetX, _progressWidth);
    _progressView.layer.cornerRadius = _progressWidth/2;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setProgress];
    [self setDotView];
}

- (void)setBuffer:(CGFloat)buffer {
    _buffer = buffer;
    
    [self setBuffer];
}

- (void)setTrackImage:(UIImage *)trackImage {
    _trackImage = trackImage;
    _trackImageView.image = _trackImage;
}

- (void)setBufferImage:(UIImage *)bufferImage {
    _bufferImage = bufferImage;
    _bufferImageView.image = _bufferImage;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    _progressView.backgroundColor = _progressColor;
    
    [[_dotView subviews] objectAtIndex:1].backgroundColor = _progressColor;
}

- (void)setDotBackgroundImage:(UIImage *)dotBackgroundImage {
    _dotBackgroundImage = dotBackgroundImage;
    
    ((UIImageView *)[[_dotView subviews] firstObject]).image = _dotBackgroundImage;
}

- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
    
    CGFloat y = (self.frame.size.height-_progressWidth)/2;
    
    _trackImageView.frame = CGRectMake(_trackImageView.frame.origin.x, y, _trackImageView.frame.size.width, _progressWidth);
    _bufferImageView.frame = CGRectMake(_bufferImageView.frame.origin.x, y, _bufferImageView.frame.size.width, _progressWidth);
    _progressView.frame = CGRectMake(_progressView.frame.origin.x, y, _progressView.frame.size.width, _progressWidth);

    UIView *trackDotView = [[_dotView subviews] objectAtIndex:1];
    CGRect rect = trackDotView.frame;
    rect.size.width = _progressWidth + 2;
    rect.size.height = _progressWidth + 2;
    trackDotView.frame = rect;
    trackDotView.layer.cornerRadius = rect.size.width/2;
}

- (void)setDotView {
    CGFloat offsetX = (self.frame.size.width - self.dotWidth) * _progress + self.dotWidth/2;
    self.dotView.center = CGPointMake(offsetX, self.dotView.center.y);
}

- (void)setDotWidth:(CGFloat)dotWidth {
    _dotWidth = dotWidth;
    CGRect rect = _dotView.frame;
    rect.size.width = _dotWidth;
    _dotView.frame = rect;

}

- (void)setDotHeight:(CGFloat)dotHeight {
    _dotHeight = dotHeight;
    CGRect rect = _dotView.frame;
    rect.size.height = _dotHeight;
    rect.origin.y = (CGRectGetHeight(self.frame) - dotHeight) / 2;
    _dotView.frame = rect;
}

- (void)setDotCornerRadius:(CGFloat)dotCornerRadius {
    _dotCornerRadius = dotCornerRadius;
    _dotView.clipsToBounds = YES;
    _dotView.layer.cornerRadius = _dotCornerRadius;
}

- (UIView *)dotView {
    if(_dotView == nil) {
        _dotView = [[UIView alloc] initWithFrame:CGRectZero];
        _dotView.backgroundColor = [UIColor clearColor];
        _dotView.autoresizesSubviews = YES;
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_dotView addSubview:bgImageView];
        
        
        UIView *trackDotView = [[UIView alloc] initWithFrame:CGRectZero];
        trackDotView.center = CGPointMake(_dotView.frame.size.width/2, _dotView.frame.size.height/2);
        trackDotView.backgroundColor = _progressColor;
        trackDotView.layer.cornerRadius = CGRectGetWidth(trackDotView.frame)/2;
        trackDotView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        [_dotView addSubview:trackDotView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _activityView.activityIndicatorViewStyle = _activityStyle;
        _activityView.autoresizesSubviews = YES;
        _activityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_dotView addSubview:_activityView];
    }
    
    return _dotView;
}

- (void)setActivityStyle:(UIActivityIndicatorViewStyle)activityStyle {
    _activityStyle = activityStyle;
    _activityView.activityIndicatorViewStyle = _activityStyle;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setTrack];
    [self setBuffer];
    [self setProgress];
}

- (void)start {
    [_activityView startAnimating];
}

- (void)stop {
    [_activityView stopAnimating];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.touchPointX = [touch locationInView:self].x;
    self.dotViewCenterX = self.dotView.center.x;
    if(self.beginChageValue) {
        self.beginChageValue();
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.moveOffsetX = point.x - self.touchPointX;
        
    CGFloat offsetX = self.dotViewCenterX + self.moveOffsetX;
    if(offsetX <= self.dotWidth/2) {
        offsetX = self.dotWidth/2;
    }else if(offsetX >= (self.frame.size.width - self.dotWidth/2)) {
        offsetX = self.frame.size.width - self.dotWidth/2;
    }

    self.progress = (offsetX - self.dotWidth/2)/(self.frame.size.width - self.dotWidth);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self.valueChanged) {
        self.valueChanged(_progress);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self.valueChanged) {
        self.valueChanged(_progress);
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint dotViewPoint = [_dotView convertPoint:point fromView:self];
    if([_dotView pointInside:dotViewPoint withEvent:event]) {
        return _dotView;
    }
    return [super hitTest:point withEvent:event];
}

@end
