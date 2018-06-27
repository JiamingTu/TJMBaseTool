//
//  UITextView+InputRule.h
//  TJMBaseTool
//
//  Created by Jiaming Tu on 2018/6/27.
//

#import <UIKit/UIKit.h>

@interface UITextView (InputRule)

/**只输入汉字*/
- (BOOL)realNameInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text;
/**身份证号格式化*/
- (BOOL)idCardInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text;
/**电话号码格式化*/
- (BOOL)phoneNumInpuRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text;
/**银行卡格式化*/
- (BOOL)bankCardInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text;
/**两位小数*/
- (BOOL)precisionTwoDecimalWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text;
/**没有表情和空格*/
- (BOOL)noEmojiAndNoSpaceWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text;

@end
