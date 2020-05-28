//
//  QSeekBarView.h
//  Test2
//
//  Created by fish on 2020/5/23.
//  Copyright © 2020 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QSeekBarView : UIView

/**
 
 title = 文本显示
 min = 文本进度转换最小显示（根实际返回的Value是不一样的，可以为负数。例如：-7 value = -7 进度标题是-7， 0 value = 0 进度标题就是0）
 max = 最大数值
 current = 起点（线条起点的值）
 */
- (instancetype)initFrame:(CGRect)frame title:(NSString *)title minValue:(NSInteger)min maxValue:(NSInteger)max currentValue:(NSInteger)current;

@property(nonatomic, assign, getter=value) NSInteger value;

@property(nonatomic, copy) void (^blockValueChange) (NSInteger);

@end

NS_ASSUME_NONNULL_END
