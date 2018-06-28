//
//  UIViewController+Config.h
//  TJMJinDouYun
//
//  Created by Jiaming Tu on 2017/4/28.
//  Copyright © 2017年 zhongzhichuangying. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonBlock)(UIButton *button);

@interface UIViewController (Config)

//@property (nonatomic,strong) AppDelegate *appDelegate;

- (void)setTitle:(NSString *)title fontSize:(CGFloat)size color:(UIColor *)color;
//设置导航按钮
- (void)setBackNaviItem;
- (void)itemAction:(UIButton *)button;

/**
 右导航按钮 图片

 @param imageName imageName
 @param target target
 @param action action
 @return button
 */
- (UIButton *)setRightNaviItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

/**
 右导航按钮 文字

 @param title title
 @param color titleColor
 @param fontSize font size
 @param target targe
 @param action action
 @return button
 */
- (UIButton *)setRightNaviItemWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action;
/**设置首页左导航按钮尺寸*/
//- (void)setNaviLeftButtonFrameWithButton:(UIButton *)button;

/**得到想要pop到指定界面 的界面*/
- (__kindof UIViewController *)popTargetViewControllerWithViewControllerNumber:(NSInteger)number;
/**调起alert 选择相册或相机*/
- (void)alertSelectImagePickerVCSourceTypeWithImagePickerVC:(UIImagePickerController *)imagePickerVC delegate:(id)delegate;
/**弹出界面*/
- (void)presentViewControllerWithStoryboardName:(NSString *)name storyboardId:(NSString *)storyboardId;

/**设置标题透明度*/
- (void)setTitleViewAlpha:(CGFloat)alpha;


@end
