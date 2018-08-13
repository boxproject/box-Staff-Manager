//
//  CreateApprovalFlowCollectionReusableView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/4.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CreateApprovalFlowCollectionReusableView.h"
 
@interface CreateApprovalFlowCollectionReusableView()
{
    NSString *language;
}
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) NSInteger menberIndex;

@end

@implementation CreateApprovalFlowCollectionReusableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createView];
        language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    }
    return self;
}

-(void)createView
{
    _img = [[UIImageView alloc] init];
    _img.image = [UIImage imageNamed:@""];
    _img.layer.cornerRadius = 12.0/2.0;
    _img.layer.masksToBounds = YES;
    [self addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self);
        make.height.offset(14);
        make.width.offset(14);
    }];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(24);
    }];
    
    _leftLable = [[UILabel alloc]init];
    _leftLable.font = Font(14);
    _leftLable.textColor = [UIColor colorWithHexString:@"#2b3350"];
    [self addSubview:_leftLable];
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img.mas_right).offset(11);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setTitleColor:[UIColor colorWithHexString:@"#4380fa"] forState:UIControlStateNormal];
    _addBtn.titleLabel.font = Font(20);
    _addBtn.layer.borderWidth = 1;
    _addBtn.layer.borderColor = [UIColor colorWithHexString:@"#e8e8e8"].CGColor;
    _addBtn.tag = 100;
    [_addBtn setImage:[UIImage imageNamed:@"icon_add employ"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(menberChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftLable);
        make.right.offset(-16);
        make.width.offset(25);
        make.height.offset(25);
    }];
    
    _rightLable = [[UILabel alloc]init];
    _rightLable.font = Font(13);
    _rightLable.textAlignment = NSTextAlignmentCenter;
    _rightLable.layer.borderWidth = 1;
    _rightLable.layer.borderColor = [UIColor colorWithHexString:@"#e8e8e8"].CGColor;
    _rightLable.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:_rightLable];
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_addBtn.mas_left).offset(1);
        make.centerY.equalTo(_leftLable);
        make.width.offset(40);
        make.height.offset(25);
    }];

    _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_minusBtn setTitleColor:[UIColor colorWithHexString:@"#4380fa"] forState:UIControlStateNormal];
    _minusBtn.titleLabel.font = Font(20);
    _minusBtn.layer.borderWidth = 1;
    _minusBtn.tag = 101;
    _minusBtn.layer.borderColor = [UIColor colorWithHexString:@"#e8e8e8"].CGColor;
    [_minusBtn setImage:[UIImage imageNamed:@"icon_minus"] forState:UIControlStateNormal];
    [_minusBtn addTarget:self action:@selector(menberChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_minusBtn];
    [_minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightLable.mas_left).offset(1);
        make.centerY.equalTo(_leftLable);
        make.width.offset(25);
        make.height.offset(25);
    }];
    
}

-(void)deleteBtnAction:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteSection" object:@(_index)];
}


-(void)menberChangeAction:(UIButton *)btn
{
    if (btn.tag == 100) {
        //add
        if (_menberIndex >= 0 && _menberIndex < _model.total) {
            _menberIndex ++;
            _rightLable.text = [NSString stringWithFormat:@"%ld/%ld",_menberIndex, _model.total];
            _model.require = _menberIndex;
        }
    }else if (btn.tag == 101){
        //minus
        if (_menberIndex > 0 && _menberIndex <= _model.total) {
            _menberIndex --;
            _rightLable.text = [NSString stringWithFormat:@"%ld/%ld",_menberIndex, _model.total];
            _model.require = _menberIndex;
        }
    }
}

- (void)setDataWithModel:(ApprovalBusinessDetailModel *)model index:(NSInteger)index
{
    _menberIndex = model.require;
    _index = index;
    _img.image = [UIImage imageNamed:@"icon_delete layer"];
    if ([language isEqualToString: @"en"]) {
        _leftLable.text = [NSString stringWithFormat:@"Level %ld Members(%ld)", index + 1, model.total];
    }else{
        _leftLable.text = [NSString stringWithFormat:@"第%ld层%@(%ld)", index + 1, ApprovalMenber, model.total];
    }
    _rightLable.text = [NSString stringWithFormat:@"%ld/%ld",model.require, model.total];
}



@end
