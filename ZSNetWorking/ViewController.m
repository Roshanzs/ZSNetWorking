//
//  ViewController.m
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/11/28.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import "ViewController.h"
#import "ZSNetworkTool.h"

#define MP4_URL_String @"http://120.25.226.186:32812/resources/videos/minion_02.mp4"
//#define MP4_URL_String @"http://pic1.win4000.com/wallpaper/a/53e03d0887d5a.jpg"

@interface ViewController ()
@property(nonatomic,strong)ZSNetworkTool *tool;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZSNetworkTool *tool = [ZSNetworkTool DownloadWithURLString:MP4_URL_String setProgressValue:^(float progressValue) {
        NSLog(@"%f",progressValue);
    }];
    self.tool = tool;
}
- (IBAction)start:(id)sender {
    [self.tool startDownload];
    
}
- (IBAction)pause:(id)sender {
    [self.tool suspendDownload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
