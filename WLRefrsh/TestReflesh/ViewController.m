//
//  ViewController.m
//  TestReflesh
//
//  Created by 王声远 on 15/9/7.
//  Copyright (c) 2015年 王声远. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+WSYReflesh.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"项目上下拉刷新";
    
    //初始化tableview并添加到界面上
    CGRect mainFrame =self.view.bounds;
    mainFrame.origin.y = 64;
    mainFrame.size.height -= (64);
    UITableView *myTableView = [[UITableView alloc] initWithFrame:mainFrame style:UITableViewStylePlain];
    [self.view addSubview:myTableView];
    self.myTableView = myTableView;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 44;
    [self.myTableView setShowsVerticalScrollIndicator:NO];
    //去掉tableviewcell之间的分割线
    //self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.tableFooterView = [UIView new];
    
    //添加头部刷新
    [self setUpHeadReflesh];
    
    //添加尾部刷新
    [self setUpFootReflesh];
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

// 每一行的cell数据内容显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"KeyModeCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSString *str = self.datas[indexPath.row];
    cell.textLabel.text = str;
    
    return cell;
}

- (void)setUpHeadReflesh
{
    [self.myTableView addHeaderRefleshBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.datas removeAllObjects];//刷新所有数据
            for (int i = 0; i < 12; i ++) {//重新添加默认的12条数据
                NSString *str = [NSString stringWithFormat:@"项目刷新 -> %d",i];
                [_datas addObject:str];
            }
            [self.myTableView reloadData];
            
            [self.myTableView finishHeaderReflesh];//结束刷新
        });
    } adjust:WSYHeaderViewAdjustDefault loadByStart:YES];
    
    /*
    参数说明
    1.adjust调整参数
    WSYHeaderViewAdjustDefault -> UIViewController不继承UITableViewController时使用
    WSYHeaderViewAdjustDetail -> UIViewController继承UITableViewController时使用这个调整
    2.loadByStart是否启动时刷新
    */
}

- (void)setUpFootReflesh
{
    [self.myTableView addFooterRefleshBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //当前数据的长度
            NSInteger currentCount = self.datas.count;
            
            for (NSInteger i = currentCount; i < 5+currentCount; i ++) {//每次刷新加五条数据
                NSString *str = [NSString stringWithFormat:@"项目刷新 -> %ld",i];
                [_datas addObject:str];
            }
            
            [self.myTableView reloadData];
            [self.myTableView finishFooterReflesh];//结束刷新
            
        });
    }];
}

@end
