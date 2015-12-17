//
//  LZSlider.h
//  LZSlider
//
//  Created by mac on 12/2/15.
//  Copyright © 2015 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^valueChangedBlock)(CGFloat progress);

@interface LZSlider : UIView

@property (nonatomic, strong) UIImage *trackImage;
@property (nonatomic, strong) UIImage *bufferImage;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIImage *dotBackgroundImage;

@property (nonatomic, assign) CGFloat dotWidth;
@property (nonatomic, assign) CGFloat dotHeight;
@property (nonatomic, assign) CGFloat dotCornerRadius;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityStyle;

@property (nonatomic, assign) CGFloat progressWidth;
@property (nonatomic, assign) CGFloat buffer;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) dispatch_block_t beginChageValue;
@property (nonatomic, strong) valueChangedBlock valueChanged;

- (void)start;
- (void)stop;
@end
