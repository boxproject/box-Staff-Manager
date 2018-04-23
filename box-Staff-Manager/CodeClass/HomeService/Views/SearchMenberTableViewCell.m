//
//  SearchMenberTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SearchMenberTableViewCell.h"

@interface SearchMenberTableViewCell()

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *subTitleLab;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIImageView *rightIcon;

@end

@implementation SearchMenberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

-(void)createView
{
    _titleLab = [[UILabel alloc]init];
    _titleLab.font = Font(14);
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(0);
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
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
}

- (void)setDataWithModel:(SearchMenberModel *)model indexPath:(NSIndexPath *)indexPath;
{
    if (model.employee_num > 0) {
        _titleLab.text = [NSString stringWithFormat:@"%@ (%ld)", model.account, model.employee_num];
        if (indexPath.section == 0) {
            _rightIcon.hidden = NO;
        }else{
            _rightIcon.hidden = YES;
        }
    }else{
        _titleLab.text = model.account;
        _rightIcon.hidden = YES;
    }
    
    if ([model.app_account_id isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
        _titleLab.text = [NSString stringWithFormat:@"%@ (%@)", model.account, @"我"];
        _rightIcon.hidden = YES;
    }
    if (indexPath.section == 1) {
        for (ApprovalBusApproversModel *approvalBusModel in _array) {
            if ([approvalBusModel.app_account_id  isEqualToString:model.app_account_id]) {
                _rightIcon.hidden = NO;
                _rightIcon.image = [UIImage imageNamed:@"icon_check1"];
                
            }
        }
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
