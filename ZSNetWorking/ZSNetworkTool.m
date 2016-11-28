//
//  ZSNetworkTool.m
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/11/28.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import "ZSNetworkTool.h"
#import "ExpendFileAttributes.h"

#define Key_FileTotalSize @"Key_FileTotalSize"

@interface ZSNetworkTool()<NSURLSessionDataDelegate>
//session会话
@property(nonatomic,strong)NSURLSession *session;
//task任务
@property(nonatomic,strong)NSURLSessionDataTask *dataTask;
//文件的全路径
@property(nonatomic,strong)NSString *fileFullPath;
//进度的block
@property(nonatomic,copy)SetProgressValue progressValu;
/** 当前已经下载的文件的长度 */
@property (nonatomic,assign)NSInteger fileCurrentSize;
/** 输出流 */
@property (nonatomic,strong)NSOutputStream *outputStream;
/** 不变的文件总长度 */
@property (nonatomic,assign)NSInteger fileTotalSize;

@end
@implementation ZSNetworkTool

//创建下载工具
+(instancetype)DownloadWithURLString:(NSString *)urlString setProgressValue:(SetProgressValue)setProgressValue{
    ZSNetworkTool *downTool = [[ZSNetworkTool alloc]init];
    downTool.progressValu = setProgressValue;
    [downTool getFileSizeWithURLString:urlString];
    [downTool creatDownloadSessionTaskWithURLString:urlString];
    return downTool;
}


//刚创建下载时要检测本地是否有已经下载的文件 如果已经下载则接着下,没有则从头开始下
-(void)getFileSizeWithURLString:(NSString*)urlString{
    //创建文件管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    //获取文件各个部分
    NSArray *filecomponents = [manger componentsToDisplayForPath:urlString];
    //获取下载之后的文件名
    NSString *fileName = [filecomponents lastObject];
    //根据文件名拼接沙盒名
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:fileName];
    _fileFullPath = filePath;
    //获取文件的所有属性
    NSDictionary *fileAttributes = [manger attributesOfItemAtPath:filePath error:nil];
    //如果有已经下载的文件,就直接拿出下载的文件长度,并设置为当前文件的长度;
    NSInteger flieCurrentlength = [fileAttributes[@"NSFileSize"] integerValue];
    //判断有没有当前长度,如果当前长度为0就不需要计算进度值了
    if (flieCurrentlength != 0) {
        NSInteger fileTotleLength = [[ExpendFileAttributes stringValueWithPath:self.fileFullPath key:Key_FileTotalSize] integerValue];
        _fileTotalSize = fileTotleLength;
        _fileCurrentSize = flieCurrentlength;
        self.progressValu(1.0 * flieCurrentlength / fileTotleLength);
    }
    NSLog(@"地址%@",_fileFullPath);
}

//创建网络会话任务,并启动任务
-(void)creatDownloadSessionTaskWithURLString:(NSString*)urlString{
    //判断文件是否已经下载完毕
    if (self.fileTotalSize == self.fileCurrentSize && self.fileCurrentSize != 0) {
        NSLog(@"文件已经下载完毕");
        return;
    }
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *Mrequest = [NSMutableURLRequest requestWithURL:url];
    //设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.fileCurrentSize];
    [Mrequest setValue:range forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:Mrequest];
    self.session = session;
    self.dataTask = datatask;
    
}


//开始下载
-(void)startDownload{
    [self.dataTask resume];
}
//暂停下载
-(void)suspendDownload{
    [self.dataTask suspend];
}

#pragma mark - NSURLSessionDataDelegate 的代理方法
// 收到响应调用的代理方法
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSLog(@"收到响应调用的方法");
    //创建输出流,并打开输出流
    NSOutputStream *stream = [[NSOutputStream alloc]initToFileAtPath:self.fileFullPath append:YES];
    self.outputStream = stream;
    [stream open];
    //如果当前下载的长度为0,就需要将总长度的信息写入文件中
    if (self.fileCurrentSize == 0) {
        NSInteger totlelength = response.expectedContentLength;
        NSString *totleString = [NSString stringWithFormat:@"%zd",totlelength];
        [ExpendFileAttributes extendedStringValueWithPath:self.fileFullPath key:Key_FileTotalSize value:totleString];
        //设置总长度
        self.fileTotalSize = totlelength;
    }
    //设置允许收到响应,允许执行返回数据的代理方法
    completionHandler(NSURLSessionResponseAllow);
}

//收到返回的数据的代理方法
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSLog(@"收到返回的数据的方法");
    //通过输入流写入数据
    [self.outputStream write:data.bytes maxLength:data.length];
    //将写入的数据长度加到当前已下载的长度
    self.fileCurrentSize += data.length;
    //设置进度
//    NSLog(@"%f",1.0 * self.fileCurrentSize / self.fileTotalSize);
    //在主线程返回进度
    NSOperationQueue *mainqueue = [NSOperationQueue mainQueue];
    [mainqueue addOperationWithBlock:^{
        self.progressValu(1.0 * self.fileCurrentSize / self.fileTotalSize);
    }];
}

//数据下载完成调用的代理方法
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    //关闭输出流
    [self.outputStream close];
    //关闭强指针
    self.outputStream = nil;
    //关闭会话
    [self.session invalidateAndCancel];
    NSLog(@"下载完毕 %@",NSHomeDirectory());
}











@end
