//
//  ZSNetworkTool.h
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/11/28.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义一个block用来传递进度值
typedef  void (^SetProgressValue)(float progressValue);

@interface ZSNetworkTool : NSObject
/** 创建下载工具对象 */
+ (instancetype)DownloadWithURLString:(NSString*)urlString setProgressValue:(SetProgressValue)setProgressValue;
/** 开始下载 */
-(void)startDownload;
/** 暂停下载 */
-(void)suspendDownload;

@end
