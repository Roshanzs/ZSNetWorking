//
//  ViewController.m
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/11/28.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import "ViewController.h"
#import "zsTableViewCell.h"

#define MP4_URL_String @"http://120.25.226.186:32812/resources/videos/minion_02.mp4"
#define MP4_URL_String2 @"http://pic1.win4000.com/wallpaper/a/53e03d0887d5a.jpg"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,zsTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *urls;

@end

@implementation ViewController

- (NSMutableArray *)urls
{
    if (!_urls) {
        self.urls = [NSMutableArray array];
        for (int i = 1; i<=10; i++) {
            [self.urls addObject:[NSString stringWithFormat:@"http://120.25.226.186:32812/resources/videos/minion_%02d.mp4", i]];
            //       [self.urls addObject:@"http://localhost/MJDownload-master.zip"];
        }
    }
    return _urls;
}

-(UITableView *)tableview{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]init];
        _tableview.frame = self.view.frame;
        _tableview.backgroundColor = [UIColor grayColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 80;
        [_tableview registerClass:[zsTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableview];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.urls.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    zsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.url = self.urls[indexPath.row];
    cell.delegate = self;
    return cell;
}


- (void)cell:(zsTableViewCell *)cell didClickedBtn:(UIButton *)btn {
//    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:cell.url];
//    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
//    MPMoviePlayerViewController *mpc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:receipt.filePath]];
//    [vc presentViewController:mpc animated:YES completion:nil];
}


@end
