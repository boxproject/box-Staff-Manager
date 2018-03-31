//
//  HomeSeviceTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeSeviceTableViewCell.h"

@interface HomeSeviceTableViewCell()

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic, strong)UIImageView *imgView;

@property (nonatomic,strong) UIImageView *rightIcon;

@end

@implementation HomeSeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

- (void)createView{
    
    _imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.offset(22);
        make.height.offset(22);
        
    }];
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.font = Font(15);
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.equalTo(_imgView.mas_right).offset(9);
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


- (void)setDataWithModel:(HomeServiceModel *)model
{
    _titleLab.text = model.titleName;
    _imgView.image = [UIImage imageNamed:model.imgTitle];
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
