//
//  TestModel.h
//  HuofaDemo
//
//  Created by 郭凯 on 2017/10/27.
//  Copyright © 2017年 guokai. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSInteger const defaultSelectedOption = 999;

@interface TestModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *answerState;      //0:没有回答   1:已经回答
@property (nonatomic, assign) NSInteger resultIndex;    //选中的 那个结果 (0,1,2,3,4)
@end
