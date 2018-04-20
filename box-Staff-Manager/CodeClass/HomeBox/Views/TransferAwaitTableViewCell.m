//
//  TransferAwaitTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferAwaitTableViewCell.h"

@interface TransferAwaitTableViewCell()

@property (nonatomic,strong) UILabel *approvalTitleLab;

@property (nonatomic,strong) UIView *lineView;

//@property (nonatomic,strong) UILabel *approvalStateLab;

@property (nonatomic,strong) UIImageView *rightIcon;

@end

@implementation TransferAwaitTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}



- (void)createView{
    
    UIImageView *leftImg = [[UIImageView alloc] init];
    leftImg.image = [UIImage imageNamed:@"taskLeft_icon"];
    [self.contentView addSubview:leftImg];
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.offset(20);
        make.height.offset(20);
        
    }];
    
    _approvalTitleLab = [[UILabel alloc]init];
    _approvalTitleLab.font = Font(14);
    _approvalTitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_approvalTitleLab];
    [_approvalTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.equalTo(leftImg.mas_right).offset(9);
        make.right.offset(-130);
    }];
    
    _rightIcon = [[UIImageView alloc] init];
    _rightIcon.image = [UIImage imageNamed:@"right_icon"];
    [self.contentView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.equalTo(self.contentView);
        make.width.offset(20);
        make.height.offset(22);
        
    }];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
}

- (void)setDataWithModel:(TransferAwaitModel *)model
{
    _approvalTitleLab.text = model.tx_info;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
