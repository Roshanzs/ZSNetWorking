//
//  zsTableViewCell.m
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/12/9.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import "zsTableViewCell.h"
#import "ZSDownloadManger.h"
#import "ZSNetworking.h"

@interface zsTableViewCell()
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UILabel *correntSizeLab;
@property(nonatomic,strong)UIProgressView *progress;
@end
@implementation zsTableViewCell

-(UIButton *)btn{
    if (_btn == nil) {
        _btn =  [[UIButton alloc]init];
    }
    return _btn;
}

-(UILabel *)correntSizeLab{
    if (_correntSizeLab == nil) {
        _correntSizeLab = [[UILabel alloc]init];
    }
    return _correntSizeLab;
}

-(UIProgressView *)progress{
    if (_progress == nil) {
        _progress = [[UIProgressView alloc]init];
    }
    return _progress;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.btn.frame = CGRectMake(300, 30, 60, 40);
        [self.contentView addSubview:self.btn];
        [self.btn addTarget:self action:@selector(btnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.btn.clipsToBounds = YES;
        self.btn.layer.cornerRadius = 10;
        self.btn.layer.borderWidth = 1;
        self.btn.layer.borderColor = [UIColor orangeColor].CGColor;
        [self.btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.correntSizeLab.frame = CGRectMake(0, 40, 300, 40);
        [self.contentView addSubview:self.correntSizeLab];
        self.progress.frame = CGRectMake(0, 0, 300, 40);
        [self.contentView addSubview:self.progress];
    }
    return self;
}



-(void)setUrl:(NSString *)url{
    _url = url;
    self.correntSizeLab.text = url.lastPathComponent;
    ZSDownFile *downfile = [[ZSDownloadManger sharemanger] createFileInfoWithUrl:url];
    self.progress.progress = downfile.progress.fractionCompleted;
    if (downfile.downState == ZSDownIng) {
        [self.btn setTitle:@"停止" forState:UIControlStateNormal];
    }else if (downfile.downState == ZSDownFinish) {
        [self.btn setTitle:@"播放" forState:UIControlStateNormal];
    }else {
        [self.btn setTitle:@"下载" forState:UIControlStateNormal];
    }

}


-(void)btnClickWithBtn:(UIButton *)btn{
    ZSDownFile *downfile = [[ZSDownloadManger sharemanger] createFileInfoWithUrl:self.url];
    
    if (downfile.downState == ZSDownIng) {
        [self.btn setTitle:@"下载" forState:UIControlStateNormal];
        //暂停
    }else if (downfile.downState == ZSDownFinish) {
        
        if ([self.delegate respondsToSelector:@selector(cell:didClickedBtn:)]) {
            [self.delegate cell:self didClickedBtn:btn];
        }
    }else {
        [self.btn setTitle:@"停止" forState:UIControlStateNormal];
        [self download];
    }

}

- (void)download {
        ZSNetworking *z = [ZSNetworking shareZSNetworkingWithMaxLoadingNum:1];
        [z DownloadWithURLString:self.url setProgressValue:^(NSProgress *progress) {
            NSLog(@"%@",progress);
            self.progress.progress = progress.fractionCompleted;
            self.correntSizeLab.text = [NSString stringWithFormat:@"%0.2fm/%0.2fm", progress.completedUnitCount/1024.0/1024, progress.totalUnitCount/1024.0/1024];

        } downloadfinish:^{
            NSLog(@"下载完毕");
    
        }];

}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
