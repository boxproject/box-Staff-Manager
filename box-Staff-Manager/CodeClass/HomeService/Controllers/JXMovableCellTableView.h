//
//  JXMovableCellTableView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JXMovableCellTableView;

@protocol JXMovableCellTableViewDataSource <UITableViewDataSource>

@required
/**
 *  获取tableView的数据源数组，每次开始移动的调用，以获取最新的数据源。
 *  数据源中的数组必须是可变数组，不然不能交换
 *  数据源的格式：@[@[sectionOneArray].mutableCopy, @[sectionTwoArray].mutableCopy, ....].mutableCopy
 *  即使只有一个section，最外层也需要用一个数组包裹，比如：@[@[sectionOneArray].mutableCopy].mutableCopy
 */
- (NSMutableArray *)dataSourceArrayInTableView:(JXMovableCellTableView *)tableView;

@end

@protocol JXMovableCellTableViewDelegate <UITableViewDelegate>
@optional
/**
 *  将要开始移动indexPath位置的cell
 */
- (void)tableView:(JXMovableCellTableView *)tableView willMoveCellAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  完成一次从fromIndexPath cell到toIndexPath cell的移动
 */
- (void)tableView:(JXMovableCellTableView *)tableView didMoveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
/**
 *  结束移动cell在indexPath
 */
- (void)tableView:(JXMovableCellTableView *)tableView endMoveCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  用户尝试移动一个不允许移动的cell，你可以做一些提示框告知用户
 */
- (void)tableView:(JXMovableCellTableView *)tableView tryMoveUnmovableCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JXMovableCellTableView : UITableView

@property (nonatomic, weak) id<JXMovableCellTableViewDataSource> dataSource;
@property (nonatomic, weak) id<JXMovableCellTableViewDelegate> delegate;
/**
 *  长按手势最小触发时间，默认1.0，最小0.2
 */
@property (nonatomic, assign) CGFloat gestureMinimumPressDuration;
/**
 *  自定义可移动cell的截图样式
 */
@property (nonatomic, copy) void(^drawMovalbeCellBlock)(UIView *movableCell);
/**
 *  是否允许拖动到屏幕边缘后，开启边缘滚动，默认YES
 */
@property (nonatomic, assign) BOOL canEdgeScroll;
/**
 *  是否可以长按拖动
 */
@property (nonatomic, assign) BOOL canScroll;
/**
 *  边缘滚动触发范围，默认150，越靠近边缘速度越快
 */
@property (nonatomic, assign) CGFloat edgeScrollRange;

@end
