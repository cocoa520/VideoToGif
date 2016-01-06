//
//  main.m
//  VideoToGif
//
//  Created by shyee  on 16-1-6.
//  Copyright (c) 2016年 cocoa520. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GifGenerater.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc < 3) {
            NSLog(@"the param is less.");
            NSLog(@"the first is video src path.");
            NSLog(@"the second is gif dst path.");
            return -1;
        }
        
        NSString* srcPath = [NSString stringWithUTF8String:argv[1]];
        NSString* desPath = [NSString stringWithUTF8String:argv[2]];
        
        if ([srcPath length] == 0 || [desPath length] == 0) {
            NSLog(@"the srcPath or desPath is empty.");
            return -2;
        }
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:srcPath]) {
            NSLog(@"the srcPath:%@ file not exsit.",srcPath);
            return -3;
        }
        
        BOOL isDir = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:desPath isDirectory:&isDir];
        if (isDir) {
            NSString* fileName = [[srcPath lastPathComponent] stringByDeletingPathExtension];
            fileName = [fileName stringByAppendingPathExtension:@"GIF"];
            desPath = [desPath stringByAppendingPathComponent:fileName];
        }
        
        if(0 == [GifGenerater generateGIFFromPath:srcPath destPath:desPath]) {
            NSLog(@"succ");
        }
    }
    return 0;
}

