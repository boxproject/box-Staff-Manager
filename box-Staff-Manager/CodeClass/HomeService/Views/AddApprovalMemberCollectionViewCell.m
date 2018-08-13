//
//  AddApprovalMemberCollectionViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AddApprovalMemberCollectionViewCell.h"

@interface AddApprovalMemberCollectionViewCell()

@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *nameLab;

@end

@implementation AddApprovalMemberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    _img = [[UIImageView alloc] init];
    _img.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _img.layer.cornerRadius = 3.f;
    _img.layer.masksToBounds = YES;
    [self.contentView addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
   
    _nameLab = [[UILabel alloc]init];
    _nameLab.font = Font(13);
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.right.bottom.offset(0);
    }];
}

-(void)setDataWithModel:(DepartmemtInfoModel *)model
{
    _nameLab.text = model.Account;
    if (model.select) {
        if (model.state == 1) {
            _img.image = [UIImage imageNamed:@""];
            _img.layer.borderWidth = 0.5;
            _img.layer.borderColor = [UIColor colorWithHexString:@"#5d70ff"].CGColor;
            _img.backgroundColor = [UIColor colorWithHexString:@"#e9f0ff"];
            _nameLab.textColor = [UIColor colorWithHexString:@"#4c7afd"];
            
        }else if (model.state == 2){
            _img.image = [UIImage imageNamed:@"bg_choose"];
            _img.layer.borderWidth = 0.5;
            _img.layer.borderColor = [UIColor colorWithHexString:@"#5d70ff"].CGColor;
            _nameLab.textColor = [UIColor colorWithHexString:@"#4c7afd"];
            
        }else{
            [self defaultColor];
        }
    }else{
        [self defaultColor];
    }
}

-(void)defaultColor
{
    _img.image = [UIImage imageNamed:@""];
    _img.layer.borderWidth = 0;
    _img.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    _img.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _nameLab.textColor = [UIColor colorWithHexString:@"#666666"];
}


@end
