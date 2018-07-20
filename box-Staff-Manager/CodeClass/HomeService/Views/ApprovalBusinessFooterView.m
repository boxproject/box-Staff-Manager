//
//  ApprovalBusinessFooterView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessFooterView.h"

@interface ApprovalBusinessFooterView ()

@property (nonatomic,strong)UILabel *leftLab;
@property (nonatomic,strong)UIButton *button;

@end

@implementation ApprovalBusinessFooterView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"icon_viewLog"];
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
        make.width.offset(27);
        make.height.offset(27);
    }];
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    _leftLab.font = Font(14);
    _leftLab.text = viewLog;
    _leftLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:_leftLab];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.left.equalTo(img.mas_right).offset(8);
        make.width.offset(90);
        make.height.offset(20);
    }];
    
    UIImageView *rightImg = [[UIImageView alloc] init];
    rightImg.image = [UIImage imageNamed:@"right_icon"];
    [self addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-11);
        make.centerY.equalTo(_leftLab);
        make.width.offset(20);
        make.height.offset(22);
    }];
    
    UIButton *viewLogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewLogBtn addTarget:self action:@selector(viewLogBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewLogBtn];
    [viewLogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(40);
    }];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    //_button.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    _button.titleLabel.font = Font(15);
    _button.layer.cornerRadius = 2.0f;
    _button.layer.masksToBounds = YES;
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14);
        make.right.offset(-16);
        make.top.equalTo(viewLogBtn.mas_bottom).offset(20);
        make.height.offset(44);
    }];
}
 
-(void)buttonAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(cancelApprovalBusiness)]) {
        [self.delegate cancelApprovalBusiness];
    }
}

-(void)setValueWithStatus:(ApprovalFooterState)Status
{
    if (Status == ApprovalFooterFlow) {
        _button.hidden = YES;
    }else if (Status == ApprovalFooterFlowCancel){
        _button.hidden = NO;
        [_button setTitle:cancelApproval forState:(UIControlState)UIControlStateNormal];
    }else if (Status == ApprovalFooterTransfer){
        _button.hidden = YES;
    }else if (Status == ApprovalFooterTransferCancel){
        _button.hidden = NO;
        [_button setTitle:TransferCancel forState:(UIControlState)UIControlStateNormal];
    }
}

-(void)viewLogBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(enterViewLog)]) {
        [self.delegate enterViewLog];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
