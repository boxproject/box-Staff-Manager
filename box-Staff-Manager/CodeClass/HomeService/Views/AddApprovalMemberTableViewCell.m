//
//  AddApprovalMemberTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/23.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AddApprovalMemberTableViewCell.h"

@interface AddApprovalMemberTableViewCell()

@end

@implementation AddApprovalMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

-(void)createView
{
    _title = [[UILabel alloc]init];
    _title.font = Font(14);
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(-0);
        make.bottom.offset(0);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.left.right.offset(0);
        make.height.offset(0.5);
    }];
}

- (void)setDataWithModel:(DepartmentModel *)model
{
    _title.text = model.Name;
    if (_OneCell == 1) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    _title.textColor = [UIColor colorWithHexString:@"#666666"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
