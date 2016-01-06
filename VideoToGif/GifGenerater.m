//
//  GifGenerater.m
//  VideoToGif
//
//  Created by shyee  on 16-1-6.
//  Copyright (c) 2016年 cocoa520. All rights reserved.
//

#import "GifGenerater.h"
#import <ImageIO/ImageIO.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreServices/CoreServices.h>
#import <CoreMedia/CoreMedia.h>
#import <QTKit/QTKit.h>

@implementation GifGenerater

+ (int)generateGIFFromPath:(NSString*)srcPath destPath:(NSString*)desPath {
    NSError* error = nil;
    QTMovie* mov = [QTMovie movieWithFile:srcPath error:&error];
    if (!mov) {
        NSLog(@"error:%s",[[error description] UTF8String]);
        return -1;
    }
    
    QTTime duration = [mov duration];
    float videoLength = (float)duration.timeValue/duration.timeScale;
    int framesPerSecond = 4;
    int frameCount = videoLength*framesPerSecond;
    
    // 每帧时长
    float increment = (float)videoLength/frameCount;
    
    //图像目标
    CGImageDestinationRef destination;
    CFURLRef url = CFURLCreateWithFileSystemPath (kCFAllocatorDefault,
                                                  (CFStringRef)desPath,
                                                  kCFURLPOSIXPathStyle,
                                                  false);
    if(!url) {
        NSLog(@"the url is null.\n");
        return -2;
    }
    //通过一个url返回图像目标
    destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, frameCount, NULL);
    if(!destination) {
        NSLog(@"the destination is null.\n");
        return -3;
    }
    
    //设置gif的信息,播放间隔时间,基本数据,和delay时间
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:
                                     [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:0.2], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                                                forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    [dict setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    
    [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    // 优化大小
    NSSize sourceSize = [[[mov movieAttributes] valueForKey:@"QTMovieNaturalSizeAttribute"] sizeValue];
    if (sourceSize.width > 1000){
        sourceSize.width /= 3;
        sourceSize.height /= 3;
    }else if (sourceSize.width > 500) {
        sourceSize.width /= 2;
        sourceSize.height /= 2;
    }
    //QTKit取图片参数
    NSDictionary* param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSValue valueWithSize:sourceSize],QTMovieFrameImageSize,QTMovieFrameImageTypeCGImageRef,QTMovieFrameImageType, nil];
    
    for (int currentFrame = 0; currentFrame < frameCount; ++currentFrame) {
        float seconds = (float)increment * currentFrame;
        QTTime time = QTMakeTimeWithTimeInterval(seconds);
        CGImageRef image = [mov frameImageAtTime:time withAttributes:param error:nil];
        if (image) {
            CGImageDestinationAddImage(destination, image, (CFDictionaryRef)frameProperties);
        }
    }
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
    // Finalize the GIF
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to finalize GIF destination: %s", [[error description] UTF8String]);
        return -4;
    }
    CFRelease(destination);
    CFRelease(url);
    
    return 0;
}

@end
