//
//  CurrentcyListCollectionViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CurrentcyListCollectionViewCell.h"

@interface CurrentcyListCollectionViewCell()

@property (nonatomic,strong) UILabel *laber;

@end

@implementation CurrentcyListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    _laber = [[UILabel alloc]init];
    _laber.font = Font(15);
    _laber.textColor = [UIColor colorWithHexString:@"#666666"];
    _laber.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_laber];
    [_laber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
}

- (void)setDataWithModel:(CurrencyModel *)model
{
    _laber.text = model.currency;
}

@end
