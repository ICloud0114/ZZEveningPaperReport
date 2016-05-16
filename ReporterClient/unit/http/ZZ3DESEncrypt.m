//
//  ZZ3DESEncrypt.m
//  ZZMostTalented
//
//  Created by wangshaosheng on 13-4-8.
//  Copyright (c) 2013年 wangshaosheng. All rights reserved.
//

#import "NSData+Base64.h"
#import "ZZ3DESEncrypt.h"

@implementation ZZ3DESEncrypt

+ (NSData*)encryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv {
    NSData* result = nil;
    
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
	bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];
	
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
	size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
	char *buffer = malloc(bufferSize);
    
    // do encrypt
	size_t encryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
										  &encryptedSize);
	if (cryptStatus == kCCSuccess) {
		result = [NSData dataWithBytes:buffer length:encryptedSize];
        NSLog(@"Encrypt Success");
	} else {
        NSLog(@"[ERROR] failed to encrypt|CCCryptoStatus: %d", cryptStatus);
    }
    free(buffer);
	return result;
}

+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv {
    NSData* result = nil;
    
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
	bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];
    
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
	size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
	void *buffer = malloc(bufferSize);
	
    // do decrypt
	size_t decryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
										  cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
	
	if (cryptStatus == kCCSuccess) {
		result = [NSData dataWithBytes:buffer length:decryptedSize];
	} else {
        NSLog(@"[ERROR] failed to decrypt| CCCryptoStatus: %d", cryptStatus);
    }
    free(buffer);
	return result;
}


+ (NSString*)encrypt:(NSString*)string keyString:(NSString*)keyString {
    //    kcfStringencodinggb
    NSStringEncoding strEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [self encryptData:[string dataUsingEncoding:strEncode]
                                 key:[keyString dataUsingEncoding:strEncode]
                                  iv:[keyString dataUsingEncoding:strEncode]];
    NSString *dataHex = [ZZ3DESEncrypt hexStringForData:data];
    return dataHex;//[data base64EncodedStringWithSeparateLines:separateLines];
}

+ (NSString*)decrypt:(NSString*)encryptedString keyString:(NSString*)keyString {
//    NSString *code;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mystring" ofType:@"txt" ];
//    NSData *myData = [NSData dataWithContentsOfFile:filePath];
//    if (myData) {
//        code = [[[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding] autorelease];
//        //        code = [ZZ3DESEncrypt encrypt:code keyString:@"SDFL#)@F"];
//        code = [ZZ3DESEncrypt encrypt:code keyString:@"WZYCSDFL"];
//        // do something useful
//    }
    NSData* encryptedData = [ZZ3DESEncrypt dataForHexString:encryptedString];
    NSData* data = [self decryptData:encryptedData
                                 key:[keyString dataUsingEncoding:NSUTF8StringEncoding]
                                  iv:[keyString dataUsingEncoding:NSUTF8StringEncoding]];
    if (data)
    {       
        return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
    else
    {
        return nil;
    }
}


#define FBENCRYPT_IV_HEX_LEGNTH (FBENCRYPT_BLOCK_SIZE*2)

+ (NSData*)generateIv {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand(time(NULL));
    });
    
    char cIv[FBENCRYPT_BLOCK_SIZE];
    for (int i=0; i < FBENCRYPT_BLOCK_SIZE; i++) {
        cIv[i] = rand() % 256;
    }
    return [NSData dataWithBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
}


+ (NSString*)hexStringForData:(NSData*)data {
    static const char hexdigits[] = "0123456789ABCDEF";
	const size_t numBytes = [data length];
	const unsigned char* bytes = [data bytes];
	char *strbuf = (char *)malloc(numBytes * 2 + 1);
	char *hex = strbuf;
	NSString *hexBytes = nil;
    
	for (int i = 0; i<numBytes; ++i) {
		const unsigned char c = *bytes++;
		*hex++ = hexdigits[(c >> 4) & 0xF];
		*hex++ = hexdigits[(c ) & 0xF];
	}
	*hex = 0;
	hexBytes = [NSString stringWithUTF8String:strbuf];
	free(strbuf);
	return hexBytes;
}

+ (NSData*)dataForHexString:(NSString*)hexString {
    if (hexString == nil) {
        return nil;
    }
    hexString = [hexString lowercaseString];
    int j=0;
    int length = hexString.length/2;
    if (hexString.length % 2 > 0)
    {
        length++;
    }
    Byte bytes[length];  ///3ds key的Byte 数组， 128位
    
    for(int i=0;i<[hexString length];i++)
    {
        if (hexString.length%2 > 0 && i == [hexString length]- 1)
        {
            break;
        }
        
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)        
        int int_ch1;        
        if(hex_char1 >= '0' && hex_char1 <='9')
        {
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        }
        else if(hex_char1 >= 'A' && hex_char1 <='F')            
        {
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        }
        else
        {
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        }        
        i++;

        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)        
        int int_ch2;        
        if(hex_char2 >= '0' && hex_char2 <='9')
        {
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        }
        else if(hex_char1 >= 'A' && hex_char1 <='F')
        {
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        }
        else
        {
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        }
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
        
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:length];
    return [newData autorelease];
}

+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
@end
