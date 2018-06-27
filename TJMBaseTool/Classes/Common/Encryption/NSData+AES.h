//
//  NSData+AES.h
//  加密算法
//
//  Created by scn on 16/9/5.
//  Copyright © 2016年 TAnna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSString+MD5.h"
@interface NSData (AES)
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key ;
@end
@interface NSString (AES)
+ (NSData*)AES256Encrypt:(NSString*)strSource withKey:(NSString*)key ;
+ (NSString*)AES256Decrypt:(NSData*)dataSource withKey:(NSString*)key;
@end