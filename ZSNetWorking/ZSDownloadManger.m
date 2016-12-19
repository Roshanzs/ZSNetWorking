//
//  ZSDownloadManger.m
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/12/9.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import "ZSDownloadManger.h"

NSString * const ZSDownloadCacheFolderName = @"ZSDownloadCache";

static NSString * cacheFolder() {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    static NSString *cacheFolder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cacheFolder) {
            NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
            cacheFolder = [cacheDir stringByAppendingPathComponent:ZSDownloadCacheFolderName];
        }
        NSError *error = nil;
        if(![filemgr createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Failed to create cache directory at %@", cacheFolder);
            cacheFolder = nil;
        }
    });
    return cacheFolder;
}

static NSString * LocalReceiptsPath() {
    return [cacheFolder() stringByAppendingPathComponent:@"downfile.data"];
}

@interface ZSDownloadManger()
@property (nonatomic, strong) dispatch_queue_t synchronizationQueue;

@end


@implementation ZSDownloadManger

+(instancetype)sharemanger{
    static ZSDownloadManger *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ZSDownloadManger alloc]init];
    });
    return share;
}

-(dispatch_queue_t)synchronizationQueue{
    if (_synchronizationQueue == nil) {
        NSString *name = [NSString stringWithFormat:@"com.qibaoyouwu.synchronizationqueue-%@", [[NSUUID UUID] UUIDString]];
        _synchronizationQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
    }
    return _synchronizationQueue;
}


-(ZSDownFile *)createFileInfoWithUrl:(NSString *)url{
    if (url == nil) {
        return nil;
    }
    //先从归档中取试下有没有
    ZSDownFile *downFlie = self.finishDownloadFile[url];
    if (downFlie) {
        return downFlie;
    }
    downFlie = [[ZSDownFile alloc] initWithUrl:url];
    downFlie.downState = ZSDownNone;
    downFlie.totalBytesExpectedToWrite = 1;
    
    //异步保存这个下载模型
    dispatch_sync(self.synchronizationQueue, ^{
        [self.finishDownloadFile setObject:downFlie forKey:url];
        [self saveReceipts:self.finishDownloadFile];
    });
    return downFlie;
}

//保存到偏好设置
- (void)saveReceipts:(NSDictionary *)file {
    [NSKeyedArchiver archiveRootObject:file toFile:LocalReceiptsPath()];
}


-(NSMutableDictionary *)finishDownloadFile{
    if (_finishDownloadFile == nil) {
        NSDictionary *filedic = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalReceiptsPath()];
        _finishDownloadFile = filedic != nil ? filedic.mutableCopy : [NSMutableDictionary dictionary];
    }
    return _finishDownloadFile;
  
}













@end
