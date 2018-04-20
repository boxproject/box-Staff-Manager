//
//  HomeMeTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomeMeTableViewCell.h"

@interface HomeMeTableViewCell()

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UILabel *subTitleLab;

@property (nonatomic,strong) UIImageView *rightIcon;

@end

@implementation HomeMeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

- (void)createView{
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.font = Font(14);
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(16);
    }];
    
    _subTitleLab = [[UILabel alloc]init];
    _subTitleLab.font = Font(14);
    _subTitleLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:_subTitleLab];
    [_subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.right.offset(-16);
    }];
    _subTitleLab.hidden = YES;
    
    _rightIcon = [[UIImageView alloc] init];
    _rightIcon.image = [UIImage imageNamed:@"right_icon"];
    [self.contentView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
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



- (void)setDataWithModel:(HomeMeModel *)model row:(NSInteger)row
{
    if (row == 0) {
        _titleLab.text = model.titleName;
        _subTitleLab.text = model.subTitle;
        _subTitleLab.hidden = NO;
        _rightIcon.hidden = YES;
    }else{
        _titleLab.text = model.titleName;
        _subTitleLab.hidden = YES;
        _rightIcon.hidden = NO;
    }
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
