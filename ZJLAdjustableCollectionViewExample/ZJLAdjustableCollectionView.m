//
//  ZJLAdjustableCollectionView.m
//  ZJLAdjustableCollectionViewExample
//
//  Created by ZhongZhongzhong on 16/6/10.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLAdjustableCollectionView.h"

typedef NS_ENUM(NSInteger , ZJLScrollDirection){
    ZJLScrollUp = 0,
    ZJLScrollDown
};

@interface ZJLAdjustableCollectionView()
@property (nonatomic, assign) CGPoint fingerPosition;
@property (nonatomic, strong) NSIndexPath *fromIndexPath;
@property (nonatomic, strong) NSIndexPath *toIndexPath;
@property (nonatomic, strong) UIView *chosenViewCopy;
@property (nonatomic, assign) ZJLScrollDirection scrollDirection;
@property (nonatomic, strong) CADisplayLink *autoScrollTimer;
@end

@implementation ZJLAdjustableCollectionView

float const autoScrollSpeed = 5.0;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if(self = [super initWithFrame:frame collectionViewLayout:layout]){
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture
{
    self.fingerPosition = [gesture locationInView:self];
    self.toIndexPath = [self indexPathForItemAtPoint:self.fingerPosition];
    
    UIGestureRecognizerState longPressState = gesture.state;
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{
            self.fromIndexPath = [self indexPathForItemAtPoint:self.fingerPosition];
            if (self.fromIndexPath) {
                UICollectionViewCell *cell = [self cellForItemAtIndexPath:self.fromIndexPath];
                self.chosenViewCopy = [self createChosenViewCopyWith:cell];
                [self addSubview:self.chosenViewCopy];
                cell.hidden = YES;
                
                CGPoint center = self.chosenViewCopy.center;
                center.y = self.fingerPosition.y;
                [UIView animateWithDuration:0.3 animations:^{
                    self.chosenViewCopy.transform = CGAffineTransformMakeScale(1.03, 1.03);
                    self.chosenViewCopy.alpha = 0.96;
                    self.chosenViewCopy.center = center;
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            self.chosenViewCopy.center = self.fingerPosition;
            if ([self checkCollectionViewNeedScroll]) {
                if (!self.autoScrollTimer) {
                    self.autoScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAutoScroll)];
                    [self.autoScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
                }
            }else{
                [self.autoScrollTimer invalidate];
                self.autoScrollTimer = nil;
            }
            self.toIndexPath = [self indexPathForItemAtPoint:self.fingerPosition];
            if (self.toIndexPath && ![self.fromIndexPath isEqual:self.toIndexPath]) {
                [self reorganizeCollectionView];
            }
            break;
        }
        default:{
            [self.autoScrollTimer invalidate];
            self.autoScrollTimer = nil;
            [self endDrag];
            break;
        }
    }
    
}

- (BOOL)checkCollectionViewNeedScroll
{
    CGFloat minY = CGRectGetMinY(self.chosenViewCopy.frame);
    CGFloat maxY = CGRectGetMaxY(self.chosenViewCopy.frame);
    if (minY<self.contentOffset.y) {
        self.scrollDirection = ZJLScrollUp;
        return YES;
    }
    if (maxY>self.bounds.size.height+self.contentOffset.y) {
        self.scrollDirection = ZJLScrollDown;
        return YES;
    }
    return NO;
}
                                            
- (void)startAutoScroll
{
    if (self.scrollDirection == ZJLScrollUp) {
        if (self.contentOffset.y>0) {
            [self setContentOffset:CGPointMake(0, self.contentOffset.y - autoScrollSpeed)];
            self.chosenViewCopy.center = CGPointMake(self.chosenViewCopy.center.x, self.chosenViewCopy.center.y-autoScrollSpeed);
        }
    }else if (self.scrollDirection == ZJLScrollDown){
        if (self.bounds.size.height+self.contentOffset.y<self.contentSize.height) {
            [self setContentOffset:CGPointMake(0, self.contentOffset.y + autoScrollSpeed)];
            self.chosenViewCopy.center = CGPointMake(self.chosenViewCopy.center.x, self.chosenViewCopy.center.y+autoScrollSpeed);
        }
    }
    self.toIndexPath = [self indexPathForItemAtPoint:self.chosenViewCopy.center];
    if (self.toIndexPath && ![self.fromIndexPath isEqual:self.toIndexPath]) {
        [self reorganizeCollectionView];
    }
}

- (void)reorganizeCollectionView
{
    NSMutableArray *temp = [NSMutableArray array];
    if ([self.ZJLDataSource respondsToSelector:@selector(originalDataArrayFromCollectionView:)]) {
        [temp addObjectsFromArray:[self.ZJLDataSource originalDataArrayFromCollectionView:self]];
    }
    [self moveInArray:temp from:self.fromIndexPath.row to:self.toIndexPath.row];
    if ([self.ZJLDelegate respondsToSelector:@selector(collectionView:updateWithArray:)]) {
        [self.ZJLDelegate collectionView:self updateWithArray:temp];
    }
    [self moveItemAtIndexPath:self.fromIndexPath toIndexPath:self.toIndexPath];
    self.fromIndexPath = self.toIndexPath;
}

- (void)moveInArray:(NSMutableArray *)array from:(NSUInteger)fromIndex to:(NSUInteger)toIndex
{
    if (fromIndex<toIndex) {
        for (NSUInteger i = fromIndex; i<toIndex; i++) {
            [array exchangeObjectAtIndex:i withObjectAtIndex:i+1];
        }
    }else{
        for (NSUInteger i = fromIndex; i>toIndex; i--) {
            [array exchangeObjectAtIndex:i withObjectAtIndex:i-1];
        }
    }
}

- (UIView *)createChosenViewCopyWith:(UICollectionViewCell *)cell
{
    UIGraphicsBeginImageContext(cell.bounds.size);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.center = cell.center;
    imageView.layer.masksToBounds = NO;
    imageView.layer.cornerRadius = 0.0;
    
    return imageView;
}

- (void)endDrag
{
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:self.fromIndexPath];
    cell.hidden = NO;
    cell.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.chosenViewCopy.center = cell.center;
        self.chosenViewCopy.alpha = 0;
        self.chosenViewCopy.transform = CGAffineTransformIdentity;
        cell.alpha = 1.0;
    } completion:^(BOOL finished){
        cell.hidden = NO;
        [self.chosenViewCopy removeFromSuperview];
        self.fromIndexPath = nil;
        self.toIndexPath = nil;
    }];
}

@end
