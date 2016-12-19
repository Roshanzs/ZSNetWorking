//
//  ZSNetworking.m
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/11/28.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import "ZSNetworking.h"
#import "ZSNetworkTool.h"

@interface ZSNetworking()
//当前并发数
@property(nonatomic,assign)NSInteger currDownLoading;
//最大并发数
@property(nonatomic,assign)NSInteger maxDownLoading;

@end

@implementation ZSNetworking
+(instancetype)shareZSNetworkingWithMaxLoadingNum:(NSInteger)maxNum{
    static ZSNetworking *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ZSNetworking alloc]init];
        share.currDownLoading = 0;
        share.maxDownLoading = maxNum;
    });
    return share;
}

-(void)DownloadWithURLString:(NSString *)urlString setProgressValue:(SetProgress)setProgressValue downloadfinish:(downFinish)finish{
        ZSNetworkTool *tool = [ZSNetworkTool DownloadWithURLString:urlString setProgressValue:^(NSProgress *progressValue) {
            setProgressValue(progressValue);
        }];
    tool.downloadFinish = finish;
    if (_currDownLoading < _maxDownLoading) {
        [tool startDownload];
        _currDownLoading +=1;
    }
}
@end
