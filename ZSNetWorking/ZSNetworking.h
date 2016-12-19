//
//  ZSNetworking.h
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/11/28.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void (^SetProgress)(NSProgress *progress);
// 下载完成后回调的block
typedef  void (^downFinish)();

@interface ZSNetworking : NSObject
//单例
+(instancetype)shareZSNetworkingWithMaxLoadingNum:(NSInteger)maxNum;

-(void)DownloadWithURLString:(NSString*)urlString setProgressValue:(SetProgress)setProgressValue downloadfinish:(downFinish)finish;

@end
