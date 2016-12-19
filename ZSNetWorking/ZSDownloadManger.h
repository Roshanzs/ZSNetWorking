//
//  ZSDownloadManger.h
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/12/9.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSDownFile.h"

@interface ZSDownloadManger : NSObject
//已下载的
@property(nonatomic,strong)NSMutableDictionary *finishDownloadFile;


+(instancetype)sharemanger;

//根据url区获取文件大小
-(ZSDownFile *)createFileInfoWithUrl:(NSString *)url;
@end
