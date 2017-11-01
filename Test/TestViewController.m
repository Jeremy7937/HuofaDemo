//
//  TestViewController.m
//  HuofaDemo
//
//  Created by 郭凯 on 2017/10/27.
//  Copyright © 2017年 guokai. All rights reserved.
//

#import "TestViewController.h"
#import "TestNormalCell.h"
#import "TestSelectedCell.h"
#import "TestModel.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kHeaderViewH 160
static NSInteger const defaultSelectedIndex = 9999;
static CGFloat const normalCellHeight = 65;

@interface TestViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger currentAnswerIndex;
@property (nonatomic, assign) NSInteger alreadyAnswerSelectedIndex;
@property (nonatomic, assign) BOOL isShowCommitBtn;
@property (nonatomic, strong) UIView *pageView;
@property (nonatomic, strong) UILabel *numberPageLabel;
@property (nonatomic, strong) UIView *commitView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TestViewController

//提交测试 按钮所在View
- (UIView *)commitView {
    if (!_commitView) {
        _commitView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-80, kScreenSize.width, 80)];
        
        UIView *alphaView = [[UIView alloc] initWithFrame:_commitView.bounds];
        alphaView.alpha = 0.8;
        alphaView.backgroundColor = [UIColor whiteColor];
        [_commitView addSubview:alphaView];
        
        UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commitBtn.frame = CGRectMake(60, 10, kScreenSize.width - 60*2, 40);
        [commitBtn setTitle:@"提交测试" forState:UIControlStateNormal];
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitBtn.layer.masksToBounds = YES;
        commitBtn.layer.cornerRadius = 20;
        commitBtn.backgroundColor = [UIColor orangeColor];
        [_commitView addSubview:commitBtn];
    }
    return _commitView;
}

- (UILabel *)numberPageLabel {
    if (!_numberPageLabel) {
        _numberPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenSize.width, 20)];
        _numberPageLabel.text = [NSString stringWithFormat:@"1/%ld",self.dataArr.count];
        _numberPageLabel.textAlignment = NSTextAlignmentCenter;
        _numberPageLabel.font = [UIFont systemFontOfSize:14];
    }
    return _numberPageLabel;
}

- (UIView *)pageView {
    if (!_pageView) {
        _pageView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-50, kScreenSize.width, 50)];
        
        UIView *alphaView = [[UIView alloc] initWithFrame:_pageView.bounds];
        alphaView.alpha = 0.8;
        alphaView.backgroundColor = [UIColor whiteColor];
        [_pageView addSubview:alphaView];
        
        [_pageView addSubview:self.numberPageLabel];
        
    }
    return _pageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.alreadyAnswerSelectedIndex = defaultSelectedIndex;
    self.navigationItem.title = @"专业版中医体质测试";
    [self setupHeaderView];
    [self setupTableView];
    [self structDataArr];
    [self.view addSubview:self.pageView];
}

- (void)structDataArr {
    self.dataArr = [NSMutableArray array];
    for (NSInteger i = 0; i < 30; i++) {
        TestModel *model = [[TestModel alloc] init];
        model.title = [NSString stringWithFormat:@"%ld.你喜欢安静懒得说话吗安静懒得说话吗安静懒得说话吗",i+1];
        model.answerState = @"0";
        [self.dataArr addObject:model];
    }
    
    [self.tableView reloadData];
}

- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kHeaderViewH)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headerView];
}

- (UIView *)getFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 100)];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenSize.width-15, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:lineLabel];
    
    return view;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderViewH + 64, kScreenSize.width, kScreenSize.height-kHeaderViewH-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = normalCellHeight;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableFooterView = [self getFooterView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView registerNib:[UINib nibWithNibName:@"TestNormalCell" bundle:nil] forCellReuseIdentifier:@"TestNormalCell"];
    [tableView registerNib:[UINib nibWithNibName:@"TestSelectedCell" bundle:nil] forCellReuseIdentifier:@"TestSelectedCell"];
}

//回答完最后一道题
- (void)selectedLastQuestion {
    //答完最后一道题
    self.alreadyAnswerSelectedIndex = self.dataArr.count-1;
    //记录答完最后一道题
    self.isShowCommitBtn = YES;
    //隐藏页码所在View
    self.pageView.hidden = YES;
    //添加提交按钮
    [self.view addSubview:self.commitView];
    [self.tableView reloadData];
}

//答完一道题之后
- (void)selectedQuestion {
    self.currentAnswerIndex ++; //答下一道
    //如果 打开过 已答题目 关闭
    self.alreadyAnswerSelectedIndex = defaultSelectedIndex;
    //刷新列表
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];

    //改变tableView的偏移量  始终保持当前答题项之前有两项已答题目
    NSInteger offIndex = self.currentAnswerIndex - 2;
    if (offIndex > 0) {
        CGFloat contentOffsetY = offIndex * normalCellHeight;
        CGFloat maxContentOffsetY = self.tableView.contentSize.height-CGRectGetHeight(self.tableView.frame);
        //计算出的偏移量大于 tableView最大偏移量
        if (contentOffsetY > maxContentOffsetY) {
            contentOffsetY = maxContentOffsetY;
        }
        self.tableView.contentOffset = CGPointMake(0, contentOffsetY);
    }
}

- (void)selectedOptionsWithIndex:(NSInteger)index model:(TestModel *)model {
    //判断是修改答案 还是选择答案 resultIndex 等于默认 就是选择答案
    if (model.resultIndex == defaultSelectedOption) {
        //选择答案
        model.answerState = @"1";
        model.resultIndex = index;
        if (self.currentAnswerIndex == self.dataArr.count - 1) {
            //回答完最后一道题
            [self selectedLastQuestion];
            return ;
        }else if (self.currentAnswerIndex < self.dataArr.count - 1) {
            //答完一道题之后（不是最后一道）
            [self selectedQuestion];
        }
        self.numberPageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(self.currentAnswerIndex+1),self.dataArr.count];

    }else {
        //修改答案
        model.resultIndex = index;
    }
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestModel *model = self.dataArr[indexPath.row];
    if (indexPath.row == self.currentAnswerIndex ||
        indexPath.row == self.alreadyAnswerSelectedIndex) {
        //问题展开样式
        TestSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestSelectedCell" forIndexPath:indexPath];
        cell.model = model;
        cell.selectedBlock = ^(NSInteger selectedIndex) {
            [self selectedOptionsWithIndex:selectedIndex model:model];
        };
        return cell;
        
    }else {
        //问题关闭样式
        TestNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestNormalCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = model.title;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isShowCommitBtn) {
        //所有问题全部回答完 只显示一个选中样式的。
        self.currentAnswerIndex = self.dataArr.count;
    }
    
    TestModel *model = self.dataArr[indexPath.row];
    if ([model.answerState integerValue] == 1) {
        self.alreadyAnswerSelectedIndex = indexPath.row;
        [tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.currentAnswerIndex ||
        indexPath.row == self.alreadyAnswerSelectedIndex) {
        return UITableViewAutomaticDimension;
    }else {
        return normalCellHeight;
    }
}

@end
