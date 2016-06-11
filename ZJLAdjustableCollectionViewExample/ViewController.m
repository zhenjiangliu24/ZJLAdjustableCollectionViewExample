//
//  ViewController.m
//  ZJLAdjustableCollectionViewExample
//
//  Created by ZhongZhongzhong on 16/6/10.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ViewController.h"
#import "ZJLAdjustableCollectionView.h"
#import "MyCollectionViewCell.h"

#define ZJLScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZJLScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZJLAdjustableCollectionViewDataSource,ZJLAdjustableCollectionViewDelegate>
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, strong) ZJLAdjustableCollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [NSArray arrayWithObjects:@"Montreal",@"Toronto",@"Vancouver",@"Ottawa",@"Winnipeg",@"Saint John",@"Calgary",@"Quebec city",@"Montreal",@"Toronto",@"Vancouver",@"Ottawa",@"Winnipeg",@"Saint John",@"Calgary",@"Quebec city",@"Montreal",@"Toronto",@"Vancouver",@"Ottawa",@"Winnipeg",@"Saint John",@"Calgary",@"Quebec city",@"Montreal",@"Toronto",@"Vancouver",@"Ottawa",@"Winnipeg",@"Saint John",@"Calgary",@"Quebec city", nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ZJLScreenWidth-25)/4.0, (ZJLScreenWidth-25)/4.0);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[ZJLAdjustableCollectionView alloc] initWithFrame:CGRectMake(0, 0, ZJLScreenWidth, ZJLScreenHeight) collectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"my_cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.ZJLDataSource = self;
    self.collectionView.ZJLDelegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"my_cell" forIndexPath:indexPath];
    cell.cityLabel.text = self.data[indexPath.row];
    cell.backgroundColor = [self randomColor];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (UIColor *)randomColor
{
    CGFloat red = arc4random()%256/256.0;
    CGFloat green = arc4random()%256/256.0;
    CGFloat blue = arc4random()%256/256.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

#pragma mark - ZJL data source
- (NSArray *)originalDataArrayFromCollectionView:(ZJLAdjustableCollectionView *)collectionView
{
    return self.data;
}

#pragma mark - ZJL delegate
- (void)collectionView:(ZJLAdjustableCollectionView *)collectionView updateWithArray:(NSArray *)newData
{
    self.data = [newData copy];
    //[self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
