//
//  UIViewController+Config.m
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/28.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import "UIViewController+Config.h"
const char *kTJMAppDelegateKey = "AppDelegateKey";
@implementation UIViewController (Config)
//#pragma  mark 增加AppDelegate 属性
//- (void)setAppDelegate:(AppDelegate *)appDelegate {
//    objc_setAssociatedObject(self, kTJMAppDelegateKey, appDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//- (AppDelegate *)appDelegate {
//    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    return objc_getAssociatedObject(self, kTJMAppDelegateKey);
//}

- (void)setTitle:(NSString *)title fontSize:(CGFloat)size color:(UIColor *)color {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, title.length * size + 4, size + 4)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.font = [UIFont boldSystemFontOfSize:size];
    label.text = title;
    self.navigationItem.titleView = label;
}

#pragma  mark - 设置导航左右按钮(返回)
- (void)setBackNaviItem {
    UIImage *itemImage = [UIImage imageNamed:[JMCommon sharedCommon].backItemImageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (itemImage) {
        [button setImage:itemImage forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, itemImage.size.width * 2, itemImage.size.height * 2);
    }
    [button addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)itemAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma  mark 设置右导航按钮
- (UIButton *)setRightNaviItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action  {
    UIImage *itemImage = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:itemImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, itemImage.size.width * 2, itemImage.size.height * 2);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    return button;
}

- (UIButton *)setRightNaviItemWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    UIFont *font = [UIFont systemFontOfSize:15];
    button.frame = CGRectMake(0, 0, font.pointSize * title.length + 5, font.pointSize * 2);
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    return button;
}

//#pragma  mark 设置左导航按钮尺寸(首页左导航)
//- (void)setNaviLeftButtonFrameWithButton:(UIButton *)button {
//    CGFloat titleLabelInset = 10.5 * TJMWidthRatio;
//    button.titleEdgeInsets = UIEdgeInsetsMake(0, -titleLabelInset, 0, titleLabelInset);
//    //字的宽度 字体长度 * 字体尺寸 + （图片宽度 + UI偏移量 - titleLabel偏移量）* 比例系数
//    CGFloat imageInset = button.currentTitle.length * button.titleLabel.font.pointSize + (button.currentImage.size.width + 6.5 - titleLabelInset) * TJMWidthRatio;
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, imageInset, 0, -imageInset);
//    CGFloat width = button.currentImage.size.width + button.currentTitle.length * button.titleLabel.font.pointSize + 6.5 * TJMWidthRatio;
//    CGFloat height = button.titleLabel.font.pointSize + 2;
//    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, width, height);
//}


#pragma  mark - pop到指定界面的界面
- (__kindof UIViewController *)popTargetViewControllerWithViewControllerNumber:(NSInteger)number {
    NSArray *viewControllerArray = self.navigationController.viewControllers;
    if (viewControllerArray.count != 0 && viewControllerArray.count >= number + 1) {
        UIViewController *VC = viewControllerArray[viewControllerArray.count - number - 1];
        return VC;
    }
    return nil;
}

#pragma - mark alert 调起相机 相册
- (void)alertSelectImagePickerVCSourceTypeWithImagePickerVC:(UIImagePickerController *)imagePickerVC delegate:(id)delegate {
    imagePickerVC.delegate = delegate;
    // 创建一个警告控制器
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 设置警告响应事件
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 设置照片来源为相机
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 展示选取照片控制器
        [self presentViewController:imagePickerVC animated:YES completion:^{}];
    }];
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerVC animated:YES completion:^{}];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 添加警告按钮
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    // 展示警告控制器
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentViewControllerWithStoryboardName:(NSString *)name storyboardId:(NSString *)storyboardId {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UINavigationController *naviC = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:naviC animated:YES completion:^{
        
    }];
}



#pragma  mark - 设置标题透明度
- (void)setTitleViewAlpha:(CGFloat)alpha {
    self.navigationItem.titleView.alpha = alpha;
}




@end
