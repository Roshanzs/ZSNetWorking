//
//  zsTableViewCell.h
//  ZSNetWorking
//
//  Created by 紫贝壳 on 2016/12/9.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zsTableViewCell;
@protocol zsTableViewCellDelegate <NSObject>

- (void)cell:(zsTableViewCell *)cell didClickedBtn:(UIButton *)btn;

@end

@interface zsTableViewCell : UITableViewCell
@property(nonatomic,strong)NSString *url;
@property(nonatomic,weak)id<zsTableViewCellDelegate> delegate;
@end
