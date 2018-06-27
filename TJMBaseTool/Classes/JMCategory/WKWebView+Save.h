//
//  WKWebView+Save.h
//  Electrocardiogram
//
//  Created by Jiaming Tu on 2018/1/9.
//  Copyright © 2018年 fujianzhiyou. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (Save)

- (void)ZTWKWebViewScrollCaptureCompletionHandler:(void(^)(NSData *data))completionHandler;

@end
