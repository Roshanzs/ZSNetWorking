//
//  ZSDownFile.h
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/12/9.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZSDownstate){
    ZSDownNone,      //没有状态
    ZSDownIng,       //下载中
    ZSDownFinish,   //下载完成
    ZSDownPause,    //暂停
    ZSDownWillDowning,  //准备下载
    ZSDownFailed    //下载出错
};

@interface ZSDownFile : NSObject<NSCoding>

@property(nonatomic,strong)NSString *url;
@property(nonatomic,assign)ZSDownstate downState;
@property(nonatomic,copy)NSProgress *progress;
@property(nonatomic,assign)NSString *filePath;
@property(nonatomic,strong)NSString *fileName;
@property (assign, nonatomic) long long totalBytesWritten;
@property (assign, nonatomic) long long totalBytesExpectedToWrite;

-(instancetype)initWithUrl:(NSString *)url;
@end
