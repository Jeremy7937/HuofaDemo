//
//  TestSelectedCell.h
//  HuofaDemo
//
//  Created by 郭凯 on 2017/10/27.
//  Copyright © 2017年 guokai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestModel.h"

typedef void(^OptionBtnClicked)(NSInteger selectedIndex);

@interface TestSelectedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *optionView;

@property (nonatomic, strong) TestModel *model;

@property (nonatomic, copy) OptionBtnClicked selectedBlock;

@end
