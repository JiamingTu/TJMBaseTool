//
//  NSData+AES.m
//  加密算法
//
//  Created by scn on 16/9/5.
//  Copyright © 2016年 TAnna. All rights reserved.
//

#import "NSData+AES.h"

@implementation NSData (AES)
//上述代码AES256EncryptWithKey方法为加密函数，AES256DecryptWithKey为解密函数，加密和解密方法使用的参数密钥均为32位长度的字符串

- (NSData*)AES256EncryptWithKey:(NSString*)key {
    
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

- (NSData*)AES256DecryptWithKey:(NSString*)key {
    
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}
@end

@implementation NSString (AES)
+ (NSData*)AES256Encrypt:(NSString*)strSource withKey:(NSString*)key {
    NSData *dataSource = [strSource dataUsingEncoding:NSUTF8StringEncoding];
    return [dataSource AES256EncryptWithKey:[key MD5]];
}
+ (NSString*)AES256Decrypt:(NSData*)dataSource withKey:(NSString*)key {
    NSData *decryptData = [dataSource AES256DecryptWithKey:[key MD5]];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}

@end