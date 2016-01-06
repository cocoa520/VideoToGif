//
//  GifGenerater.h
//  VideoToGif
//
//  Created by shyee  on 16-1-6.
//  Copyright (c) 2016年 cocoa520. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GifGenerater : NSObject

/*
 * @method srcPath 传入视频的路径 desPath 生成Gif的路径
 */
+ (int)generateGIFFromPath:(NSString*)srcPath destPath:(NSString*)desPath;
@end
