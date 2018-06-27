//
//  WKWebView+Save.m
//  Electrocardiogram
//
//  Created by Jiaming Tu on 2018/1/9.
//  Copyright © 2018年 fujianzhiyou. All rights reserved.
//

#import "WKWebView+Save.h"

@implementation WKWebView (Save)

#pragma mark - WKWebView 滚动生成长图
- (void)ZTWKWebViewScrollCaptureCompletionHandler:(void(^)(NSData *data))completionHandler
{
    // 制作了一个UIView的副本
    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    
    snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
    
    [self.superview addSubview:snapShotView];
    
    // 获取当前UIView可滚动的内容长度
    CGPoint scrollOffset = self.scrollView.contentOffset;
    
    // 向上取整数 － 可滚动长度与UIView本身屏幕边界坐标相差倍数
    float maxIndex = ceilf(self.scrollView.contentSize.height/self.bounds.size.height);
    
    // [UIScreen mainScreen].scale 保持清晰度
    UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, false, [UIScreen mainScreen].scale);
    
    // 循环截图
    [self ZTContentScrollPageDraw:0 maxIndex:(int)maxIndex drawCallback:^{
        
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 恢复原UIView
        [self.scrollView setContentOffset:scrollOffset animated:NO];
        [snapShotView removeFromSuperview];
        NSData *data = UIImageJPEGRepresentation(capturedImage, 1);
        completionHandler(data);
    }];
}

- (void)ZTContentScrollPageDraw:(int)index maxIndex:(int)maxIndex drawCallback:(void(^)(void))drawCallback
{
    
    [self.scrollView setContentOffset:CGPointMake(0, (float)index * self.frame.size.height)];
    
    CGRect splitFrame = CGRectMake(0, (float)index * self.frame.size.height, self.bounds.size.width, self.bounds.size.height);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        
        if(index < maxIndex){
            [self ZTContentScrollPageDraw:index + 1 maxIndex:maxIndex drawCallback:drawCallback];
        }
        else{
            drawCallback();
        }
    });
}



@end
