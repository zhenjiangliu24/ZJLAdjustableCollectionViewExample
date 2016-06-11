//
//  ZJLAdjustableCollectionView.h
//  ZJLAdjustableCollectionViewExample
//
//  Created by ZhongZhongzhong on 16/6/10.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJLAdjustableCollectionView;
@protocol ZJLAdjustableCollectionViewDataSource <UICollectionViewDataSource>
@required
- (NSArray *)originalDataArrayFromCollectionView:(ZJLAdjustableCollectionView *)collectionView;
@end

@protocol ZJLAdjustableCollectionViewDelegate <UICollectionViewDelegate>
@required
- (void)collectionView:(ZJLAdjustableCollectionView *)collectionView updateWithArray:(NSArray *)newData;
@end

@interface ZJLAdjustableCollectionView : UICollectionView
@property (nonatomic, weak) id<ZJLAdjustableCollectionViewDataSource> ZJLDataSource;
@property (nonatomic, weak) id<ZJLAdjustableCollectionViewDelegate> ZJLDelegate;
@end
