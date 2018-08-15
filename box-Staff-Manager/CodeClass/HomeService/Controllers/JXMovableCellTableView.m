//
//  JXMovableCellTableView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "JXMovableCellTableView.h"
#import "DepartmentModel.h"

static NSTimeInterval kJXMovableCellAnimationTime = 0.25;

@interface JXMovableCellTableView ()
@property (nonatomic, strong) UILongPressGestureRecognizer *gesture;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) NSMutableArray *tempDataSource;
@property (nonatomic, strong) CADisplayLink *edgeScrollTimer;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;
@property (nonatomic, strong) NSIndexPath *toScrollIndexPath;

@end

@implementation JXMovableCellTableView

@dynamic dataSource, delegate;

- (void)dealloc
{
    _drawMovalbeCellBlock = nil;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self jx_initData];
        [self jx_addGesture];
        _aWrapper = [[DDRSAWrapper alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self jx_initData];
        [self jx_addGesture];
    }
    return self;
}

- (void)jx_initData
{
    _gestureMinimumPressDuration = 1.f;
    _canEdgeScroll = YES;
    _edgeScrollRange = 150.f;
}

#pragma mark Setter

- (void)setGestureMinimumPressDuration:(CGFloat)gestureMinimumPressDuration
{
    _gestureMinimumPressDuration = gestureMinimumPressDuration;
    _gesture.minimumPressDuration = MAX(0.2, gestureMinimumPressDuration);
}

- (void)setCanScroll:(BOOL)canScroll
{
    _gesture.enabled = canScroll;
}

#pragma mark Gesture

- (void)jx_addGesture
{
    _gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jx_processGesture:)];
    _gesture.minimumPressDuration = _gestureMinimumPressDuration;
    [self addGestureRecognizer:_gesture];
    //_gesture.enabled = NO;
}

- (void)jx_processGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self jx_gestureBegan:gesture];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (!_canEdgeScroll) {
                [self jx_gestureChanged:gesture];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [self jx_gestureEndedOrCancelled:gesture];
        }
            break;
        default:
            break;
    }
}

- (void)jx_gestureBegan:(UILongPressGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    NSIndexPath *selectedIndexPath = [self indexPathForRowAtPoint:point];
    if (!selectedIndexPath) {
        return;
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        if (![self.dataSource tableView:self canMoveRowAtIndexPath:selectedIndexPath]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:tryMoveUnmovableCellAtIndexPath:)]) {
                [self.delegate tableView:self tryMoveUnmovableCellAtIndexPath:selectedIndexPath];
            }
            return;
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:willMoveCellAtIndexPath:)]) {
        [self.delegate tableView:self willMoveCellAtIndexPath:selectedIndexPath];
    }
    if (_canEdgeScroll) {
        //开启边缘滚动
        [self jx_startEdgeScroll];
    }
    //每次移动开始获取一次数据源
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataSourceArrayInTableView:)]) {
        _tempDataSource = [self.dataSource dataSourceArrayInTableView:self];
    }
    _selectedIndexPath = selectedIndexPath;
    UITableViewCell *cell = [self cellForRowAtIndexPath:selectedIndexPath];
    _tempView = [self jx_snapshotViewWithInputView:cell];
    if (_drawMovalbeCellBlock) {
        //将_tempView通过block让使用者自定义
        _drawMovalbeCellBlock(_tempView);
    }else {
        //配置默认样式
        _tempView.layer.shadowColor = [UIColor grayColor].CGColor;
        _tempView.layer.masksToBounds = NO;
        _tempView.layer.cornerRadius = 0;
        _tempView.layer.shadowOffset = CGSizeMake(-5, 0);
        _tempView.layer.shadowOpacity = 0.4;
        _tempView.layer.shadowRadius = 5;
    }
    _tempView.frame = cell.frame;
    [self addSubview:_tempView];
    //隐藏cell
    cell.hidden = YES;
    [UIView animateWithDuration:kJXMovableCellAnimationTime animations:^{
        _tempView.center = CGPointMake(_tempView.center.x, point.y);
    }];
}

- (void)jx_gestureChanged:(UILongPressGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    NSIndexPath *currentIndexPath = [self indexPathForRowAtPoint:point];
    //让截图跟随手势
    _tempView.center = CGPointMake(_tempView.center.x, [self tempViewYToFitTargetY:point.y]);

    if (self.dataSource && [self.dataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
        if (![self.dataSource tableView:self canMoveRowAtIndexPath:currentIndexPath]) {
            return;
        }
    }

    if (currentIndexPath && ![_selectedIndexPath isEqual:currentIndexPath]) {
        //交换数据源和cell
        [self jx_updateDataSourceAndCellFromIndexPath:_selectedIndexPath toIndexPath:currentIndexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didMoveCellFromIndexPath:toIndexPath:)]) {
            [self.delegate tableView:self didMoveCellFromIndexPath:_selectedIndexPath toIndexPath:currentIndexPath];
        }
        _selectedIndexPath = currentIndexPath;
    }
}

- (void)jx_gestureEndedOrCancelled:(UILongPressGestureRecognizer *)gesture
{
    if (_canEdgeScroll) {
        [self jx_stopEdgeScroll];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:endMoveCellAtIndexPath:)]) {
        [self.delegate tableView:self endMoveCellAtIndexPath:_selectedIndexPath];
    }

    [self branchChange];
    UITableViewCell *cell = [self cellForRowAtIndexPath:_selectedIndexPath];
    [UIView animateWithDuration:kJXMovableCellAnimationTime animations:^{
        _tempView.frame = cell.frame;
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [_tempView removeFromSuperview];
        _tempView = nil;
    }];
}

-(void)branchChange
{
    DepartmentModel *toModel = _tempDataSource[_toScrollIndexPath.row];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:[NSString stringWithFormat:@"%ld", toModel.Index] privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:@(_toScrollIndexPath.row + 1) forKey:@"new_index"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:@(toModel.ID) forKey:@"bid"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/branch/change" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            
        }else{
            [ProgressHUD showErrorWithStatus:dict[@"message"] code:[dict[@"code"] integerValue]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark Private action

- (UIView *)jx_snapshotViewWithInputView:(UIView *)inputView
{
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    return snapshot;
}

- (void)jx_updateDataSourceAndCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if ([self numberOfSections] == 1) {
        _toScrollIndexPath = toIndexPath;
        //只有一组
        [_tempDataSource exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
        //交换cell
        [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }else {
        //有多组
        id fromData = _tempDataSource[fromIndexPath.section][fromIndexPath.row];
        id toData = _tempDataSource[toIndexPath.section][toIndexPath.row];
        NSMutableArray *fromArray = _tempDataSource[fromIndexPath.section];
        NSMutableArray *toArray = _tempDataSource[toIndexPath.section];
        [fromArray replaceObjectAtIndex:fromIndexPath.row withObject:toData];
        [toArray replaceObjectAtIndex:toIndexPath.row withObject:fromData];
        [_tempDataSource replaceObjectAtIndex:toIndexPath.section withObject:toArray];
        //交换cell
        [self beginUpdates];
        [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
        [self moveRowAtIndexPath:toIndexPath toIndexPath:fromIndexPath];
        [self endUpdates];
    }
}

- (CGFloat)tempViewYToFitTargetY:(CGFloat)targetY
{
    CGFloat minValue = _tempView.bounds.size.height/2.0;
    CGFloat maxValue = self.contentSize.height - minValue;
    return MIN(maxValue, MAX(minValue, targetY));
}

#pragma mark EdgeScroll

- (void)jx_startEdgeScroll
{
    _edgeScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(jx_processEdgeScroll)];
    [_edgeScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)jx_processEdgeScroll
{
    [self jx_gestureChanged:_gesture];
    CGFloat minOffsetY = self.contentOffset.y + _edgeScrollRange;
    CGFloat maxOffsetY = self.contentOffset.y + self.bounds.size.height - _edgeScrollRange;
    CGPoint touchPoint = _tempView.center;
    //处理上下达到极限之后不再滚动tableView，其中处理了滚动到最边缘的时候，当前处于edgeScrollRange内，但是tableView还未显示完，需要显示完tableView才停止滚动
    if (touchPoint.y < _edgeScrollRange) {
        if (self.contentOffset.y <= 0) {
            return;
        }else {
            if (self.contentOffset.y - 1 < 0) {
                return;
            }
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - 1) animated:NO];
            _tempView.center = CGPointMake(_tempView.center.x, [self tempViewYToFitTargetY:_tempView.center.y - 1]);
        }
    }
    if (touchPoint.y > self.contentSize.height - _edgeScrollRange) {
        if (self.contentOffset.y >= self.contentSize.height - self.bounds.size.height) {
            return;
        }else {
            if (self.contentOffset.y + 1 > self.contentSize.height - self.bounds.size.height) {
                return;
            }
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + 1) animated:NO];
            _tempView.center = CGPointMake(_tempView.center.x, [self tempViewYToFitTargetY:_tempView.center.y + 1]);
        }
    }
    //处理滚动
    CGFloat maxMoveDistance = 20;
    if (touchPoint.y < minOffsetY) {
        //cell在往上移动
        CGFloat moveDistance = (minOffsetY - touchPoint.y)/_edgeScrollRange*maxMoveDistance;
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y - moveDistance) animated:NO];
        _tempView.center = CGPointMake(_tempView.center.x, [self tempViewYToFitTargetY:_tempView.center.y - moveDistance]);
    }else if (touchPoint.y > maxOffsetY) {
        //cell在往下移动
        CGFloat moveDistance = (touchPoint.y - maxOffsetY)/_edgeScrollRange*maxMoveDistance;
        [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y + moveDistance) animated:NO];
        _tempView.center = CGPointMake(_tempView.center.x, [self tempViewYToFitTargetY:_tempView.center.y + moveDistance]);
    }
}

- (void)jx_stopEdgeScroll
{
    if (_edgeScrollTimer) {
        [_edgeScrollTimer invalidate];
        _edgeScrollTimer = nil;
    }
}

@end
