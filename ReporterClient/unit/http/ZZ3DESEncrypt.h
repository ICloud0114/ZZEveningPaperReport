//
//  ZZ3DESEncrypt.h
//  ZZMostTalented
//
//  Created by wangshaosheng on 13-4-8.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#define FBENCRYPT_ALGORITHM kCCAlgorithmDES
#define FBENCRYPT_BLOCK_SIZE kCCBlockSizeAES128
#define FBENCRYPT_KEY_SIZE kCCKeySizeDES


@interface ZZ3DESEncrypt : NSObject

//-----------------
// API (raw data)
//-----------------
+ (NSData*)generateIv;
+ (NSData*)encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSString *) md5:(NSString *)str;

//-----------------
// API (base64)
//-----------------
// the return value of encrypteMessage: and 'encryptedMessage' are encoded with base64.
//
+ (NSString*)encrypt:(NSString*)string keyString:(NSString*)keyString;
+ (NSString*)decrypt:(NSString*)encryptedString keyString:(NSString*)keyString;

//-----------------
// API (utilities)
//-----------------
+ (NSString*)hexStringForData:(NSData*)data;
+ (NSData*)dataForHexString:(NSString*)hexString;

@end
