//
//  UNLoadModel.m
//  ReporterClient
//
//  Created by easaa on 4/24/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "UNLoadModel.h"

@implementation UNLoadModel
-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        NSArray *titles = dic[@"News"];
        NSArray *photos = dic[@"Photos"];
        NSArray *videos = dic[@"Videos"];
        
        for (NSDictionary *dic in titles)
        {
            _newsTitle = dic[@"Title"];
            _contents = dic[@"contents"];
            _linkTitle = dic[@"linkTitle"];
            _dateString = dic[@"dateString"];
        }
        
        for (NSDictionary *dic in photos)
        {
            _photoFile = dic[@"fileName"];
        }
        
        for (NSDictionary *dic in videos)
        {
            _videoFile = dic[@"fileName"];
            _facePhoto = dic[@"faceImage"];
        }
        
    }
    return self;
}
@end
