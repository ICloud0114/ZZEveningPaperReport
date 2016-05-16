//
//  UNLoadModel.h
//  ReporterClient
//
//  Created by easaa on 4/24/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNLoadModel : NSObject
@property (nonatomic, strong) NSString *newsTitle;
@property (nonatomic, strong) NSString *contents;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *linkTitle;
@property (nonatomic, strong) NSString *photoFile;
@property (nonatomic, strong) NSString *videoFile;
@property (nonatomic, strong) NSString *facePhoto;

-(id)initWithDictionary:(NSDictionary*)dic;
@end
