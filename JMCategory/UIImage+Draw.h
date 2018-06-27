//
//  UIImage+Draw.h
//  TJMBaseTool
//
//  Created by Jiaming Tu on 2018/6/27.
//

#import <UIKit/UIKit.h>

@interface UIImage (Draw)

/**
 制作二维码图片

 @param text text
 @return image
 */
+ (UIImage *)createQRCodeWithCodeText:(NSString *)text;

/**
 layer -> image

 @param layer layer
 @return image
 */
+ (UIImage *)imageFromLayer:(CALayer *)layer;

@end
