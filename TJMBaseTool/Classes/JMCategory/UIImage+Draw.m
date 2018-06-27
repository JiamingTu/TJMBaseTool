//
//  UIImage+Draw.m
//  TJMBaseTool
//
//  Created by Jiaming Tu on 2018/6/27.
//

#import "UIImage+Draw.h"

@implementation UIImage (Draw)

+ (UIImage *)createQRCodeWithCodeText:(NSString *)text {
    //1.创建CIFilter过滤器 CIQRCodeGenerator 用于告诉过滤器，是要生成二维码的作用
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //2.恢复一下默认设置(在生成二维码之前，都要恢复一下默认设置)
    [filter setDefaults];
    //3.给过滤器添加数据
    //在设置的时候，采用的是KVC,但是有要求，value必须要转换成NSData数据
    NSData *textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:textData forKeyPath:@"inputMessage"];
    //4.使用过滤器生成（输出）一个二维码
    CIImage *outPutImage = [filter outputImage];
    //5.转换成UIImage
    UIImage *image = [UIImage createNonInterpolatedUImageFormCIImage:outPutImage withSize:200];
    return image;
}

+ (UIImage *)createNonInterpolatedUImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent),size / CGRectGetHeight(extent));
    //1.创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    UIImage *resultImage = [UIImage imageWithCGImage:scaledImage];
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    return resultImage;
}

//将一个CALayer对象绘制到一个UIImage对象上，并返回这个UIImage对象
+ (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end
