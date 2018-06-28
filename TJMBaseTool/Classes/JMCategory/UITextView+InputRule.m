//
//  UITextView+InputRule.m
//  TJMBaseTool
//
//  Created by Jiaming Tu on 2018/6/27.
//

#import "UITextView+InputRule.h"
#import "NSString+RegEx.h"
@implementation UITextView (InputRule)

#pragma  mark - 输入规则
#pragma  mark - 银行卡 格式化
- (BOOL)bankCardInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text  {
    if (self) {
        NSString* text = self.text;
        //删除
        if([text isEqualToString:@""]){
            //删除一位
            if(range.length == 1){
                //最后一位,遇到空格则多删除一次
                if (range.location == text.length-1 ) {
                    if ([text characterAtIndex:text.length-1] == ' ') {
                        [self deleteBackward];
                    }
                    return YES;
                }
                //从中间删除
                else{
                    NSInteger offset = range.location;
                    
                    if (range.location < text.length && [text characterAtIndex:range.location] == ' ' && [self.selectedTextRange isEmpty]) {
                        [self deleteBackward];
                        offset --;
                    }
                    [self deleteBackward];
                    self.text = [self parseString:self.text];
                    UITextPosition *newPos = [self positionFromPosition:self.beginningOfDocument offset:offset];
                    self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
                    return NO;
                }
            }
            else if (range.length > 1) {
                BOOL isLast = NO;
                //如果是从最后一位开始
                if(range.location + range.length == self.text.length ){
                    isLast = YES;
                }
                [self deleteBackward];
                self.text = [self parseString:self.text];
                
                NSInteger offset = range.location + text.length;
                if (range.location == 4 || range.location == 9 || range.location == 14 || range.location == 19) {
                    offset ++;
                }
                if (isLast) {
                    //光标直接在最后一位了
                }else{
                    UITextPosition *newPos = [self positionFromPosition:self.beginningOfDocument offset:offset];
                    self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
                }
                
                return NO;
            }
            
            else{
                return YES;
            }
        }
        else if(text.length >0){
            //限制输入字符个数
            if (([self noneSpaseString:self.text].length + text.length - range.length > 19) ) {
                return NO;
            }
            //判断是否是纯数字(千杀的搜狗，百度输入法，数字键盘居然可以输入其他字符)
            if(![text isNumber]) {
                return NO;
            }
            [self insertText:text];
            self.text = [self parseString:self.text];
            
            NSInteger offset = range.location + text.length;
            if (range.location == 4 || range.location == 9 || range.location == 14 || range.location == 19) {
                offset ++;
            }
            UITextPosition *newPos = [self positionFromPosition:self.beginningOfDocument offset:offset];
            self.selectedTextRange = [self textRangeFromPosition:newPos toPosition:newPos];
            return NO;
        }else{
            return YES;
        }
        
    }
    
    return YES;
}

- (NSString*)noneSpaseString:(NSString*)string
{
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString*)parseString:(NSString*)string
{
    if (!string) {
        return nil;
    }
    NSMutableString* mStr = [NSMutableString stringWithString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]];
    for (int i = 0; i < string.length / 4; i ++) {
        if (mStr.length != 0 && (mStr.length - i) / 4 > i) {
            [mStr insertString:@" " atIndex: (i+1) * 4 + i];
        }
    }
    return  mStr;
}

#pragma  mark - 只输入中文
- (BOOL)realNameInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 1) {
        if ([text isChinese]) {
            return YES;
        }
    } else if (text.length > 1) {
        for (int i = 0; i < text.length; i ++) {
            NSRange myRange = NSMakeRange(i, 1);
            NSString *myRangeString = [text substringWithRange:myRange];
            if ([myRangeString isChinese])[self insertText:myRangeString];
        }
        return NO;
    } else if (text.length == 0) {
        return YES;
    }
    return NO;
}
#pragma  mark 身份证号
- (BOOL)idCardInputRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text {
    //获取输入框 输入下一位之前的值
    NSMutableString *newValue = [self.text mutableCopy];
    //拼接 下一位 得到输入框输入完成后的值
    [newValue replaceCharactersInRange:range withString:text];
    if (newValue.length <= 17 && [newValue isNumber]) {
        return YES;
    } else if (newValue.length == 18 && [[newValue substringToIndex:16] isNumber] && ([[newValue substringFromIndex:17] isNumber] || [[newValue substringFromIndex:17] isEqualToString:@"X"] || [[newValue substringFromIndex:17] isEqualToString:@"x"])) {
        return YES;
    }
    return NO;
}

- (BOOL)phoneNumInpuRuleWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text {
    //获取输入框 输入下一位之前的值
    NSMutableString *newValue = [self.text mutableCopy];
    //拼接 下一位 得到输入框输入完成后的值
    [newValue replaceCharactersInRange:range withString:text];
    if (newValue.length <= 13 && [newValue isNumber]) {
        return YES;
    }
    return NO;
}

#pragma  mark - 数字加小数两位
- (BOOL)precisionTwoDecimalWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *string             = self.text;
    NSString *decimalSeperator = @".";
    NSCharacterSet *charSet    = nil;
    NSString *numberChars      = @"0123456789";
    
    if ([text isEqualToString:decimalSeperator] && [string length] == 0) {
        return NO;
    }
    
    NSRange decimalRange = [text rangeOfString:decimalSeperator];
    BOOL isDecimalNumber = (decimalRange.location != NSNotFound);
    if (isDecimalNumber) {
        charSet = [NSCharacterSet characterSetWithCharactersInString:numberChars];
        if ([string rangeOfString:decimalSeperator].location != NSNotFound) {
            return NO;
        }
    }
    else {
        numberChars = [numberChars stringByAppendingString:decimalSeperator];
        charSet = [NSCharacterSet characterSetWithCharactersInString:numberChars];
    }
    
    NSCharacterSet *invertedCharSet = [charSet invertedSet];
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:invertedCharSet];
    text = [text stringByReplacingCharactersInRange:range withString:trimmedString];
    
    if (isDecimalNumber) {
        NSArray *arr = [text componentsSeparatedByString:decimalSeperator];
        if ([arr count] == 2) {
            if ([arr[1] length] > 2) {
                return NO;
            }
        }
    }
    self.text = text;
    return NO;
}

- (BOOL)noEmojiAndNoSpaceWithTextFieldShouldChangeCharactersInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"➋➌➏➎➍➐➑➒" containsString:text]) {//包含系统中文输入法字符
        return YES;
    }
    NSString *tem = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![text isEqualToString:tem]) {
        return NO;
    }
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:0 error:nil];
    NSString *noEmojiStr = [regularExpression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    if (![noEmojiStr isEqualToString:text]) {
        return NO;
    }
    return YES;
}


@end
