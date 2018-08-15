//
//  SetApprovalAmountTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SetApprovalAmountTableViewCell.h"

@interface SetApprovalAmountTableViewCell() <UITextFieldDelegate>
{
    NSIndexPath *addIndexPath;
}
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) LimitAmountTextField *textField;

@end

@implementation SetApprovalAmountTableViewCell

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
    _titleLab.textAlignment = NSTextAlignmentLeft;
    _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.width.offset(60);
        make.bottom.offset(0);
    }];
  
    _textField = [[LimitAmountTextField alloc]init];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.font = Font(14);
    _textField.textColor = [UIColor colorWithHexString:@"#333333"];
    _textField.delegate = self;
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_textField addTarget:self action:@selector(textViewEditChanged) forControlEvents:UIControlEventEditingChanged];
    _textField.placeholder = LimitCurrencyPlaceholder;
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLab.mas_right).offset(10);
        make.top.offset(0);
        make.right.offset(-16);
        make.bottom.offset(0);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.bottom.offset(-1);
    }];
}

-(void)textViewEditChanged
{
    
    if ([self.delegate respondsToSelector:@selector(textViewEdit:indexPath:)]) {
        [self.delegate textViewEdit:_textField.text indexPath:addIndexPath];
    }
    
}

//限制小数位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField ==_textField) {
        //判断小数点的位数
        NSRange ran=[textField.text rangeOfString:@"."];
        NSInteger tt=range.location-ran.location;
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            if (![string isEqualToString:@"."]) {
                if (range.location >= 11) {
                    return NO;
                }
            }
            return YES;
        }else{
            if (tt <= 2){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return YES;
}

- (void)setDataWithModel:(CurrencyModel *)model indexPath:(NSIndexPath *)indexPath
{
    addIndexPath = indexPath;
    _titleLab.text = model.currency;
    if (model.limit != nil) {
        _textField.text = model.limit;
    }else{
        _textField.text = @"";
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
