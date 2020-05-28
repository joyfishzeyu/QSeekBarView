//
//  QSeekBarView.m
//  Test2
//
//  Created by fish on 2020/5/23.
//  Copyright © 2020 fish. All rights reserved.
//

#import "QSeekBarView.h"
#import <UIKit/UIKit.h>
#import "UIColor+Additions.h"

#define qScreenWidth [UIScreen mainScreen].bounds.size.width
#define qScreenHeight [UIScreen mainScreen].bounds.size.height

@interface QSeekBarView()

@property(nonatomic, strong) NSString *title;

@property(nonatomic, assign) NSInteger max;

@property(nonatomic, assign) NSInteger min;

@property(nonatomic, strong) UISlider *viewSlider;

@property(nonatomic, assign) CGFloat lineHeight;

@property(nonatomic, strong) UIView *viewLine;

@property(nonatomic, assign) NSInteger current;

@property(nonatomic, assign) CGFloat pointSpace;

@property(nonatomic, strong) UILabel *labelProgress;

@property(nonatomic, assign) NSInteger record;

@end

@implementation QSeekBarView

- (instancetype)initFrame:(CGRect)frame title:(NSString *)title minValue:(NSInteger)min maxValue:(NSInteger)max currentValue:(NSInteger)current
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, UIScreen.mainScreen.bounds.size.width, 96)];
    if (self) {
        _title = title;
        _max = max;
        _min = min;
        _current = current;
        [self initView];
    }
    return self;
}


- (void)initView{
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(8, 28 + 20, self.frame.size.width - 16, _lineHeight)];
    slider.minimumValue = 0;
    slider.value = _current;
    _record = _current;
    slider.maximumValue = _max;
    _max += 1;
    _lineHeight = 10;
    _pointSpace = ((self.frame.size.width - 25 * 2) - (6 * _max)) / (_max - 1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, qScreenWidth - 16 * 2, 20)];
    label.text = self.title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self addSubview:label];
    
    UILabel *labelProgress = [[UILabel alloc] initWithFrame:CGRectMake(100, 14, 30, 22)];
    labelProgress.textColor = [UIColor colorWithRGBHexString:@"333333"];
    labelProgress.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    labelProgress.text = @"0";
    labelProgress.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelProgress];
    _labelProgress = labelProgress;
    
    [slider setMaximumTrackTintColor:[UIColor clearColor]];
    [slider setMinimumTrackTintColor:[UIColor clearColor]];
    [self addSubview:slider];
    _viewSlider = slider;
    
    
    
    [slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    
    [self changeProgress];
}



- (void)changeValue:(UISlider *)slider{
    
    [self setNeedsDisplay];
    
    [self changeProgress];
    
    NSInteger value = @(floorf(slider.value)).integerValue;
    
    if (_blockValueChange && _record != value){
        _record = value;
        _blockValueChange(value);
    }
}


- (void)changeProgress{
    NSInteger value = @(floorf(_viewSlider.value)).integerValue;
    if(_min < 0){
        NSString *perator;
        if (_current == _min + value){
            perator = @"";
        }else if (_min + value > _current) {
            perator = @"+";
        }else {
            perator = @"";
        }
        _labelProgress.text = [NSString stringWithFormat:@"%@%zd",
                               perator, _min + value];
    }else {
        _labelProgress.text = [NSString stringWithFormat:@"%zd", value];
    }
    
}



- (CGPoint)getStartPoint{
    
    CGFloat x = 25 + (_current - 1) * (_pointSpace + 6) + (_current !=0 && _current != _max ? 8 : 0);
    
    CGFloat y = (self.frame.size.height - _lineHeight) * 0.5;
  
    return CGPointMake(x, y);
    
}


- (void)drawRect:(CGRect)rect{
    
    UIImageView *viewPoint = _viewSlider.subviews[2].subviews[0];
    
    if (viewPoint.tag != 100){
        viewPoint.tag = 100;
        viewPoint.contentMode = UIViewContentModeCenter;
        viewPoint.image = [UIImage imageNamed:@"slider_point"];
    }
      
    CGPoint center = _labelProgress.center;
    center.x = [viewPoint convertPoint:viewPoint.center toView:self].x + (viewPoint.frame.size.width - viewPoint.superview.frame.size.width) * 0.5;
    _labelProgress.center = center;
    
    CGPoint startPoint = [self getStartPoint];
    
    startPoint.x = startPoint.x + viewPoint.frame.size.width * 0.5 - 8;
    startPoint.y = _viewSlider.center.y ;
    
    NSInteger value = @(floorf(_viewSlider.value)).integerValue;
    CGPoint endPoint = CGPointMake(center.x, startPoint.y);
    
    [self drawLineStartPoint:CGPointMake(16 + 8, endPoint.y) endPoint:CGPointMake(self.frame.size.width - 16 - 8, endPoint.y) color:[UIColor colorWithRGBHexString:@"DCDCDC"]];
    
    [self drawLineStartPoint:startPoint endPoint:endPoint color:[UIColor redColor]];
    
    for (int i = 0; i < _max ; i ++) {
        UIColor *colorPoint;
        if (i == _current || (value < _current && i >= value && i < _current) || (value > _current && i <= value && i > _current)){
            colorPoint = [UIColor colorWithRGBHexString:@"E82830"];
        }else {
            colorPoint = [UIColor colorWithRGBHexString:@"E6E6E6"];
        }
        [self drawCircularFrame:CGRectMake(25 + i * (_pointSpace + 6), 68, 6, 6) color:colorPoint];
        
    }
    
}

- (void)drawCircularFrame:(CGRect)frame color:(UIColor *)color{
    
    /*画填充圆
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, frame);
    [color set];
    CGContextFillPath(context);
    
}

- (void)drawLineStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)color{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置绘制的颜色
    [color setStroke];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    // 设置线条绘制的起始点
    
    [bezierPath moveToPoint:startPoint];
    
    [bezierPath addLineToPoint:endPoint];
    CGContextSetLineWidth(context, _lineHeight);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextAddPath(context, bezierPath.CGPath);
    // 执行绘制路径操作
    CGContextStrokePath(context);
}

- (NSInteger)value{
    return _value;
}

@end
