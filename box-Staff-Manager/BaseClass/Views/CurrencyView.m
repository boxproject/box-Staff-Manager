//
//  CurrencyView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CurrencyView.h"
#import "CurrentcyListCollectionViewCell.h"

@interface CurrencyView()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UILabel *laber;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowlayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *sourceArray;

@end

#define CellReuseIdentifier  @"CurrentcyList"

@implementation CurrencyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _sourceArray = [[NSMutableArray alloc] init];
        [self createView];
        [self requestData];
    }
    return self;
}

-(void)createView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, kTopHeight + 1)];
    topView.backgroundColor = [UIColor clearColor];
    topView.alpha = 0.6;
    [self addSubview:topView];
    
    _collectionFlowlayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionFlowlayout.itemSize = CGSizeMake(self.frame.size.width/3, 70);
    //_collectionFlowlayout.minimumLineSpacing = 0;
    // 最小列间距
    _collectionFlowlayout.minimumInteritemSpacing = 0;
    // 最小行间距
    _collectionFlowlayout.minimumLineSpacing = 0;
    _collectionFlowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kTopHeight + 1, SCREEN_WIDTH ,70*3) collectionViewLayout:_collectionFlowlayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[CurrentcyListCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    [self addSubview:_collectionView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 70*3 + kTopHeight,  SCREEN_WIDTH, SCREEN_HEIGHT - 70*3 - kTopHeight)];
    view.backgroundColor = [UIColor colorWithHexString:@"#18191c"];
    view.alpha = 0.6;
    [self addSubview:view];
    UITapGestureRecognizer *cancelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTapAction:)];
    [view addGestureRecognizer:cancelTap];
}

-(void)cancelTapAction:(UITapGestureRecognizer *)tap
{
    [self removeFromSuperview];
}

#pragma mark  ----- UICollectionViewDataSource -----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _sourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CurrentcyListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    CurrencyModel *model = _sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CurrencyModel *model = _sourceArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.delegate didSelectItem:model];
        [self removeFromSuperview];
    }
}

#pragma mark  ----- 币种拉取 -----
-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"app_account_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/capital/currency/list" params:paramsDic success:^(id responseObject)
    {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            for (NSDictionary *dataDic in dict[@"data"][@"currency_list"]) {
                CurrencyModel *model = [[CurrencyModel alloc] initWithDict:dataDic];
                [_sourceArray addObject:model];
            }
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)reloadAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
