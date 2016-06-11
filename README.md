# ZJLAdjustableCollectionViewExample
Adjustable collection view with dragging

Collection view with ability to drag the cell to reorganize it.  
![Alt text](/adjustable collection view.gif?raw=true "screen shot")  
How to use it:  
Step one, set the view controller to be the delegate of ZJLAdjustableCollectionViewDataSource,ZJLAdjustableCollectionViewDelegate.  

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZJLAdjustableCollectionViewDataSource,ZJLAdjustableCollectionViewDelegate>  
@property (nonatomic, copy) NSArray *data;  
@property (nonatomic, strong) ZJLAdjustableCollectionView *collectionView;  
@end  

Step two:initilize the collection view with the layout and frame.  
self.collectionView = [[ZJLAdjustableCollectionView alloc] initWithFrame:CGRectMake(0, 0, ZJLScreenWidth, ZJLScreenHeight) collectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"my_cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.ZJLDataSource = self;
    self.collectionView.ZJLDelegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];  
    
Step three: implement the ZJL delegate and data source.  
- (NSArray *)originalDataArrayFromCollectionView:(ZJLAdjustableCollectionView *)collectionView  
- (void)collectionView:(ZJLAdjustableCollectionView *)collectionView updateWithArray:(NSArray *)newData  



