//
//  DepartmentTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/26.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "DepartmentTableViewCell.h"

@interface DepartmentTableViewCell()

@property (nonatomic,strong) UILabel *departmentLab;

@end

@implementation DepartmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

-(void)createView
{
    if ([[BoxDataManager sharedManager].depth isEqualToString:@"0"]) {
        [self createViewForOneDepth];
    }else{
        _departmentLab = [[UILabel alloc]init];
        _departmentLab.font = Font(15);
        _departmentLab.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_departmentLab];
        [_departmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            make.left.offset(15);
            make.right.offset(-50);
        }];
    }
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
}

-(void)createViewForOneDepth
{
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"icon_move"];
    [self.contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(15);
        make.height.offset(8);
        make.width.offset(20);
    }];
    
    _dragImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_dragImage];
    [_dragImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.top.bottom.offset(0);
        make.width.offset(35);
    }];
    
    _departmentLab = [[UILabel alloc]init];
    _departmentLab.font = Font(15);
    _departmentLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_departmentLab];
    [_departmentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(50);
        make.right.offset(-50);
    }];
}

- (void)setDataWithModel:(DepartmentModel *)model
{
    if (model.Employees > 0) {
        _departmentLab.text = [NSString stringWithFormat:@"%@ (%ld)", model.Name, model.Employees];
    }else{
        _departmentLab.text = model.Name;
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
