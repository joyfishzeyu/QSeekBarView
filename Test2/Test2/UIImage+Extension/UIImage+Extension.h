//
//  UIImage+Extension.h
//  ZiJingiOSBasicFrameWork
//
//  Created by kunge on 2017/2/6.
//  Copyright © 2017年 kunge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
//通过颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;
//通过颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//按比例缩放,size 是你要把图显示到 多大区域 CGSizeMake(300, 140)
- (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

//图片旋转
- (UIImage *)rotatedByDegrees:(CGFloat)degrees;

- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

- (UIImage *)fixOrientation;

/**
 *  剪切图片为正方形
 *
 *  @param image   原始图片比如size大小为(400x200)pixels
 *  @param newSize 正方形的size比如400pixels
 *
 *  @return 返回正方形图片(400x400)pixels
 */
+ (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;

/**
 *  UIColor生成UIImage
 *
 *  @param color     生成的颜色
 *  @param imageSize 生成的图片大小
 *
 *  @return 生成后的图片
 */
+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize ;

//画一条线
+ (void)drawALineWithFrame:(CGRect)frame andColor:(UIColor*)color inLayer:(CALayer*)parentLayer;

#pragma mark -------------save image to local---------------
//保存照片至本机
+ (void)saveImageToPhotoAlbum:(UIImage*)image;

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

//图片等比处理
+ (UIImage *)imageCompressionRatio:(UIImage *)image;
/**
 *  识别图片中的二维码
 */
-(BOOL)HaveQRCode;

#pragma mark - Blur
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

/**根据URL生成图片*/
+(UIImage*)GetImageByURLStr:(NSString*)urlStr;

+(UIImage*)GetImageResizing:(UIImage *)image model:(UIImageResizingMode)model;

/**
 压缩图片

 @param sourceImage 源图片
 @param maxSize 最大尺寸
 @return NSData
 */
+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize;


- (UIImage *)getTiledImageWithSize:(CGSize)size;


@end
