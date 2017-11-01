//
//  TestSelectedCell.m
//  HuofaDemo
//
//  Created by 郭凯 on 2017/10/27.
//  Copyright © 2017年 guokai. All rights reserved.
//

#import "TestSelectedCell.h"

@implementation TestSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in self.optionView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 22.5;
            view.layer.borderColor = [UIColor lightGrayColor].CGColor;
            view.layer.borderWidth = 0.5;
        }
    }
}

- (void)setModel:(TestModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    [self setOptionBtnSelected:model.resultIndex];
}

- (void)setOptionBtnSelected:(NSInteger)index {
    for (UIView *view in self.optionView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag == (100 +index)) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor orangeColor];
            }else {
                [btn setTitleColor:[UIColor colorWithRed:74/255.0f green:74/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

- (IBAction)optionBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    for (UIView *view in self.optionView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (btn == button) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor orangeColor];
            }else {
                [button setTitleColor:[UIColor colorWithRed:74/255.0f green:74/255.0f blue:74/255.0f alpha:1] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    
    NSLog(@"______model.resultIndex:%ld",_model.resultIndex);
    if (self.selectedBlock) {
        self.selectedBlock(btn.tag-100);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
