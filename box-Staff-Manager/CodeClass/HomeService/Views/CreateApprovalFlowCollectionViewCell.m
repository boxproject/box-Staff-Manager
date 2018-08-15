//
//  CreateApprovalFlowCollectionViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/4.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CreateApprovalFlowCollectionViewCell.h"

@interface CreateApprovalFlowCollectionViewCell()
{
    NSIndexPath *addIndexPath;
}

@property (nonatomic,strong) UIView *view;

@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UIImageView *img;

@end

@implementation CreateApprovalFlowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}


-(void)createView
{
    _view = [[UIView alloc] init];
    _view.backgroundColor = [UIColor colorWithHexString:@"#e3ecff"];
    _view.layer.cornerRadius = 3.f;
    _view.layer.masksToBounds = YES;
    [self.contentView addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(3);
        make.left.offset(3);
        make.right.offset(-3);
        make.bottom.offset(-3);
    }];
    
    _img = [[UIImageView alloc] init];
    _img.image = [UIImage imageNamed:@"icon_delete employ"];
    [self.contentView addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.width.height.offset(13);
    }];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton addTarget:self action:@selector(deleteItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.width.offset(25);
        make.height.offset(30);
    }];
    
    _nameLab = [[UILabel alloc]init];
    _nameLab.font = Font(13);
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.textColor = [UIColor colorWithHexString:@"#4380fa"];
    [_view addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(3);
        make.right.bottom.offset(-3);
    }];
    
    UITapGestureRecognizer *addMenberTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addMenberAction:)];
    [_nameLab addGestureRecognizer:addMenberTap];
}

-(void)deleteItemAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(deleteMenberAction:)]) {
        [self.delegate deleteMenberAction:addIndexPath];
    }
}

-(void)addMenberAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(addMenberAction:)]) {
        [self.delegate addMenberAction:addIndexPath];
    }
}

- (void)setDataWithModel:(ApprovalBusApproversModel *)model indexPath:(NSIndexPath *)indexPath
{
    addIndexPath = indexPath;
    if (model.itemType == ItemTypeAdd) {
        _nameLab.attributedText = [self attributedStringWithImage];
        _deleteButton.hidden = YES;
        _img.hidden = YES;
        _nameLab.userInteractionEnabled = YES;
    }else{
        _nameLab.text = model.account;
        _deleteButton.hidden = NO;
        _img.hidden = NO;
        _nameLab.userInteractionEnabled = NO;
    }
}

-(NSMutableAttributedString *)attributedStringWithImage
{
    NSString *str = [NSString stringWithFormat:@"%@", Add];
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", str]];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4380fa"] range:NSMakeRange(0, str.length + 1)];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    attch.image = [UIImage imageNamed:@"icon_add employ"];
    attch.bounds = CGRectMake(0, -1.5, 13, 13);
    //创建带有图片的富文本
    NSAttributedString *stringAt = [NSAttributedString attributedStringWithAttachment:attch];
    //将图片放在最后一位
    //[attri appendAttributedString:string];
    //将图片放在第一位
    [attri insertAttributedString:stringAt atIndex:0];
    return attri;
}



@end
