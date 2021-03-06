//
//  UIImage+Extrnsion.m
//  UICategory
//
//  Created by cguo on 2017/5/6.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "UIImage+Extrnsion.h"
#import <objc/runtime.h>

@implementation UIImage (Extrnsion)



-(UIImage*)addWatemarkImageWithtranslucentWatemarkImage:(UIImage*)waterImage withwaterImageFrame:(CGRect)frame withAlpha:(CGFloat)Alpha
{
    
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //设置水印图片的透明度
    // 四个参数为水印的位置
    [[waterImage imageByApplyingAlpha:Alpha] drawInRect:frame];
    UIImage * resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
- (UIImage *)addWatemarkTextInLogoImage:(NSString *)watemarkText
                              whitLabelFrame:(CGRect)frame
                              withAlpha:(CGFloat)alpha
                          withTextColor:(UIColor*)color{
    int w = self.size.width;
    int h = self.size.height;
    UIGraphicsBeginImageContext(self.size);
//    [color set];
   
    
    [self drawInRect:CGRectMake(0, 0, w, h)];
    UIFont * font = [UIFont systemFontOfSize:56.0];
    [watemarkText drawInRect:frame withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[color colorWithAlphaComponent:alpha]}];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  设置图片透明度
 * @param alpha 透明度
 */
-(UIImage *)imageByApplyingAlpha:(CGFloat )alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
  
    CGContextSetAlpha(ctx, alpha);
 
    CGContextDrawImage(ctx, area, self.CGImage);
  
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
 
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
-(UIImage *)compressImageToByte:(float)maxLength
{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return self;
    
    CGFloat max = 1.0;
   
    for (int i = 0; i < 1; ++i) {
        if (data.length < maxLength) {
            break;
        }
        max-=0.1;
        data = UIImageJPEGRepresentation(self, max);
      
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    //修正图片的方向
    resultImage=[self fixOrientationWithImage:resultImage];
    return resultImage;

}

//如果要保证图片清晰度，建议选择压缩图片质量。如果要使图片一定小于指定大小，压缩图片尺寸可以满足。对于后一种需求，还可以先压缩图片质量，如果已经小于指定大小，就可得到清晰的图片，否则再压缩图片尺寸。

+ (UIImage *)compressImage:(UIImage *)image toByte:(float)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
   
    CGFloat max = 1.0;
    
    for (int i = 0; i < 1; ++i) {
        if (data.length < maxLength) {
            break;
        }
        max-=0.1;
        data = UIImageJPEGRepresentation(image, max);
        
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    //修正图片的方向
    resultImage=[self fixOrientation:resultImage];
    return resultImage;
}


- (UIImage*)scaledToSize:(CGSize)newSize
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height){
        return self;
    }
    
    if (width == 0 || height == 0){
        return self;
    }
    
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)circleImage
{
    // 开始图形上下文，NO代表透明
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得图形上下文
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置一个范围
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // 根据一个rect创建一个椭圆
    
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    
    CGContextClip(ctx);
    
    // 将原照片画到图形上下文
    
    [self drawInRect:rect];
    
    // 从上下文上获取剪裁后的照片
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    
    UIGraphicsEndImageContext();
    
    return newImage;

}

+(void)load
{
//
//    Method imageNamemethod= class_getClassMethod([UIImage class], @selector(imageNamed:));
//
//    Method imagezjqMethod= class_getClassMethod([UIImage class], @selector(zjq_imageName:));
    
//    method_exchangeImplementations(imageNamemethod, imagezjqMethod);
}

+(__kindof UIImage*)zjq_imageName:(NSString *)imageName
{
    //    加载图片
    UIImage *image=[UIImage zjq_imageName:imageName];
   
    if (image==nil) {
        NSLog(@"图片为空");
    }
    //在这里可以对图片进行相关的操作
    
    return image;
}

- (UIImage *)imageByScalingAspectToMinSize:(CGSize)targetSize
{
    // 获取源图片的宽和高
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    // 获取图片缩放目标大小的宽和高
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    // 定义图片缩放后的宽度
    CGFloat scaledWidth = targetWidth;
    // 定义图片缩放后的高度
    CGFloat scaledHeight = targetHeight;
    CGPoint anchorPoint = CGPointZero;
    // 如果源图片的大小与缩放的目标大小不相等
    if (!CGSizeEqualToSize(imageSize, targetSize))
    {
        // 计算水平方向上的缩放因子
        CGFloat xFactor = targetWidth / width;
        // 计算垂直方向上的缩放因子
        CGFloat yFactor = targetHeight / height;
        // 定义缩放因子scaleFactor，为两个缩放因子中较大的一个
        CGFloat scaleFactor = xFactor > yFactor? xFactor : yFactor;
        // 根据缩放因子计算图片缩放后的宽度和高度
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // 如果横向上的缩放因子大于纵向上的缩放因子，那么图片在纵向上需要裁切
        if (xFactor > yFactor)
        {
            anchorPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        // 如果横向上的缩放因子小于纵向上的缩放因子，那么图片在横向上需要裁切
        else if (xFactor < yFactor)
        {
            anchorPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // 开始绘图
    UIGraphicsBeginImageContext(targetSize);
    // 定义图片缩放后的区域
    CGRect anchorRect = CGRectZero;
    anchorRect.origin = anchorPoint;
    anchorRect.size.width  = scaledWidth;
    anchorRect.size.height = scaledHeight;
    // 将图片本身绘制到auchorRect区域中
    [self drawInRect:anchorRect];
    // 获取绘制后生成的新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 返回新图片
    return newImage ;
}
- (UIImage *)imageByScalingAspectToMaxSize:(CGSize)targetSize
{
    // 获取源图片的宽和高
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    // 获取图片缩放目标大小的宽和高
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    // 定义图片缩放后的实际的宽和高度
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint anchorPoint = CGPointZero;
    // 如果源图片的大小与缩放的目标大小不相等
    if (!CGSizeEqualToSize(imageSize, targetSize))
    {
        CGFloat xFactor = targetWidth / width;
        CGFloat yFactor = targetHeight / height;
        // 定义缩放因子scaleFactor，为两个缩放因子中较小的一个
        CGFloat scaleFactor = xFactor < yFactor ? xFactor:yFactor;
        // 根据缩放因子计算图片缩放后的宽度和高度
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // 如果横向的缩放因子小于纵向的缩放因子，图片在上面、下面有空白
        // 那么图片在纵向上需要下移一段距离，保持图片在中间
        if (xFactor < yFactor)
        {
            anchorPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        // 如果横向的缩放因子小于纵向的缩放因子，图片在左边、右边有空白
        // 那么图片在横向上需要右移一段距离，保持图片在中间
        else if (xFactor > yFactor)
        {
            anchorPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // 开始绘图
    UIGraphicsBeginImageContext(targetSize);
    // 定义图片缩放后的区域
    CGRect anchorRect = CGRectZero;
    anchorRect.origin = anchorPoint;
    anchorRect.size.width  = scaledWidth;
    anchorRect.size.height = scaledHeight;
    // 将图片本身绘制到auchorRect区域中
    [self drawInRect:anchorRect];
    

    
    // 获取绘制后生成的新图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 返回新图片
    return newImage ;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    
    
    // 获取源图片的宽和高
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    // 获取图片缩放目标大小的宽和高
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    // 定义图片缩放后的实际的宽和高度
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint anchorPoint = CGPointZero;
    // 如果源图片的大小与缩放的目标大小不相等
    if (!CGSizeEqualToSize(imageSize, targetSize))
    {
        CGFloat xFactor = targetWidth / width;
        CGFloat yFactor = targetHeight / height;
        // 定义缩放因子scaleFactor，为两个缩放因子中较小的一个
        CGFloat scaleFactor = xFactor < yFactor ? xFactor:yFactor;
        // 根据缩放因子计算图片缩放后的宽度和高度
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // 如果横向的缩放因子小于纵向的缩放因子，图片在上面、下面有空白
        // 那么图片在纵向上需要下移一段距离，保持图片在中间
        if (xFactor < yFactor)
        {
            anchorPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        // 如果横向的缩放因子小于纵向的缩放因子，图片在左边、右边有空白
        // 那么图片在横向上需要右移一段距离，保持图片在中间
        else if (xFactor > yFactor)
        {
            anchorPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // 开始绘图
     UIGraphicsBeginImageContext(targetSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, CGRectMake(0, 0, targetSize.width, targetSize.height));
    
    // 定义图片缩放后的区域
    CGRect anchorRect = CGRectZero;
    anchorRect.origin = anchorPoint;
    anchorRect.size.width  = scaledWidth;
    anchorRect.size.height = scaledHeight;
    // 将图片本身绘制到auchorRect区域中
    [self drawInRect:anchorRect];
    

    
    // 获取绘制后生成的新图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 返回新图片
    return newImage ;
    
//    // 开始绘图
//    UIGraphicsBeginImageContext(targetSize);
//    // 定义图片缩放后的区域，因此无需保持纵横比，所以直接缩放
//    CGRect anchorRect = CGRectZero;
//    anchorRect.origin = CGPointZero;
//    anchorRect.size = targetSize;
//    // 将图片本身绘制到auchorRect区域中
//    [self drawInRect:anchorRect];
//    // 获取绘制后生成的新图片
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    // 返回新图片
//    return newImage;
}

// 图片旋转角度
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    // 定义一个执行旋转的CGAffineTransform结构体
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    // 对图片的原始区域执行旋转，获取旋转后的区域
    CGRect rotatedRect = CGRectApplyAffineTransform(
                                                    CGRectMake(0.0 , 0.0, self.size.width, self.size.height) , t);
    // 获取图片旋转后的大小
    CGSize rotatedSize = rotatedRect.size;
    // 创建绘制位图的上下文
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 指定坐标变换，将坐标中心平移到图片的中心
    CGContextTranslateCTM(ctx, rotatedSize.width/2, rotatedSize.height/2);
    // 执行坐标变换，旋转过radians弧度
    CGContextRotateCTM(ctx , radians);
    // 执行坐标变换，执行缩放
    CGContextScaleCTM(ctx, 1.0, -1.0);
    // 绘制图片
    CGContextDrawImage(ctx, CGRectMake(-self.size.width / 2
                                       , -self.size.height / 2,
                                       self.size.width,
                                       self.size.height), self.CGImage);
    // 获取绘制后生成的新图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 返回新图片
    
    return newImage;
}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    return [self imageRotatedByRadians:degrees * M_PI / 180];
}

+ (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


-(UIImage *)fixOrientationWithImage:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    
    return [image imageByScalingToSize:size];
  //  return [self getThumImgOfCIWithData:UIImagePNGRepresentation(image) withMaxPixelSize:MAX(size.width, size.height)];
 
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}


/** CoreImage 获取指定尺寸的图片，返回的结果Image 目标尺寸大小 <= 图片原始尺寸大小
 @param data ---- 图片Data
 @param maxPixelSize ---- 图片最大宽/高尺寸 ，设置后图片会根据最大宽/高 来等比例缩放图片
 
 @return 目标尺寸的图片Image  */
- (UIImage*) getThumImgOfCIWithData:(NSData*)data withMaxPixelSize:(int)maxPixelSize{
    
    UIImage *imgResult = nil;
    if(data == nil)         { return imgResult; }
    if(data.length <= 0)    { return imgResult; }
    if(maxPixelSize <= 0)   { return imgResult; }
    
    const float scale = 1;
    CIImage *imgInput = [CIImage imageWithData:data];
    if(imgInput == nil) { return imgResult; }
    const float maxSizeTo = scale * maxPixelSize;
    
    float scaleHandle = 0;
    CGSize sizeImg = imgInput.extent.size;
    
    if(sizeImg.width > sizeImg.height){ // 根据最大的宽/高 值，等比例计算出最终目标尺寸
        scaleHandle = maxSizeTo / sizeImg.width;
    } else {
        scaleHandle = maxSizeTo / sizeImg.height;
    }
    if(scaleHandle > 1.0){
        scaleHandle = 1.0;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    [filter setValue:imgInput forKey:kCIInputImageKey];
    [filter setValue:@(scaleHandle) forKey:kCIInputScaleKey]; // 设置图片的缩放比例
    CIImage *imgOuput = [filter valueForKey:kCIOutputImageKey];
    if(imgOuput != nil){ // 此时imgOuput属于CIImage，不能直接通过CPU渲染到屏幕上，需要一个中间对象进行转换
        
        // 方法1：CIContext
        NSDictionary *dicOptions = @{kCIContextUseSoftwareRenderer : @(YES)}; // kCIContextUseSoftwareRenderer 默认YES，设置YES是创建基于GPU的CIContext对象，效率要比CPU高很多。
        CIContext *context = [CIContext contextWithOptions:dicOptions];
        CGImageRef imgRef = [context createCGImage:imgOuput fromRect:imgOuput.extent];
        imgResult = [UIImage imageWithCGImage:imgRef scale:scale orientation:UIImageOrientationUp];
        
        // 方法2： [UIImage imageWithCIImage:]生成UIImage，但是这个方法不能指定CIContext的设置
//        imgResult = [UIImage imageWithCIImage:imgOuput scale:scale orientation:UIImageOrientationUp];
        
        /* ========================================================
         方法1和2的区别在于，方法1把图片渲染到屏幕的准备工作已经提前完成了，CPU可以直接把结果图片显示到图片上；
         而方法2则是把屏幕渲染工作推迟到了图片真正显示到屏幕的时候才进行，会卡住主线程的。
          ======================================================== */
    }
    
    return imgResult;
}

- (UIImage *)getTiledImageWithSize:(CGSize)size
{
    UIView *tempView = [[UIView alloc] init];
    tempView.bounds = (CGRect){CGPointZero, size};
    tempView.backgroundColor = [UIColor colorWithPatternImage:self];
    
    UIGraphicsBeginImageContext(size);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return bgImage;
}

@end
