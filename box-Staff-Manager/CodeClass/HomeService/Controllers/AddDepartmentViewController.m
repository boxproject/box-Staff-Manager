//
//  AddDepartmentViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/6/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AddDepartmentViewController.h"
#import "DepartmentViewController.h"

@interface AddDepartmentViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
@property (nonatomic,strong)UITextField *addDepartmentTf;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;

@end

@implementation AddDepartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = AddDepartmentVCTitle;
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createView];
}

-(void)createView
{
    [self createBarItem];
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kTopHeight - 64))];
    _contentView.delegate = self;
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - 60);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];

    UIView *departmentView = [[UIView alloc] init];
    departmentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:departmentView];
    [departmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(50);
    }];
   
    _addDepartmentTf = [[UITextField alloc] init];
    _addDepartmentTf.font = Font(14);
    _addDepartmentTf.text = _model.Name;
    _addDepartmentTf.placeholder = AddDepartmentVCPlaceholder;
    _addDepartmentTf.delegate = self;
    _addDepartmentTf.keyboardType = UIKeyboardTypeDefault;
    _addDepartmentTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [departmentView addSubview:_addDepartmentTf];
    [_addDepartmentTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.bottom.offset(0);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(departmentView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
}

-(void)textViewEditChanged:(NSNotification *)notification{
    UITextField *textField = (UITextField *)notification.object;
    // 需要限制的长度
    NSUInteger maxLength = 0;
    maxLength = 20;
    if (maxLength == 0) return;
    // text field 的内容
    NSString *contentText = textField.text;
    // 获取高亮内容的范围
    UITextRange *selectedRange = [textField markedTextRange];
    // 这行代码 可以认为是 获取高亮内容的长度
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    // 没有高亮内容时,对已输入的文字进行操作
    if (markedTextLength == 0) {
        // 如果 text field 的内容长度大于我们限制的内容长度
        if (contentText.length > maxLength) {
            // 截取从前面开始maxLength长度的字符串
            // textField.text = [contentText substringToIndex:maxLength];
            // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
            NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
            textField.text = [contentText substringWithRange:rangeRange];
        }
    }
}

#pragma mark ------ createBarItem -----
- (void)createBarItem{
     UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithTitle:Cancel style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:AddDepartmentVCComplete style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonRight;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

-(void)setValueWithModel:(DepartmentModel *)model
{
    _addDepartmentTf.text = model.Name;
}

#pragma mark ----- complete add/edit department -----
- (void)rightButtonAction:(UIBarButtonItem *)buttonItem{
    if (_type == DepartmentAddType) {
        if ( [_addDepartmentTf.text isEqualToString:@""]) {
            [WSProgressHUD showErrorWithStatus:AddDepartmentVCPlaceholder];
            return;
        }
        [self addDepartment];
    }else{
        [self editDepartment];
    }
}

#pragma mark ----- add department -----
-(void)addDepartment
{
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:_addDepartmentTf.text privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:_addDepartmentTf.text forKey:@"name"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/branch/add" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            if ([self.delegate respondsToSelector:@selector(addDepartmentReflesh)]) {
                [WSProgressHUD showSuccessWithStatus:dict[@"message"]];
                [self.delegate addDepartmentReflesh];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [self showProgressWithMessage:dict[@"message"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark ----- edit department -----
-(void)editDepartment
{
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:_addDepartmentTf.text privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"appid"];
    [paramsDic setObject:_addDepartmentTf.text forKey:@"new_name"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:@(_model.ID) forKey:@"bid"];
    [paramsDic setObject:[BoxDataManager sharedManager].token forKey:@"token"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/branch/change" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0) {
            NSArray *listArray = dict[@"data"][@"list"];
            if ([self.delegate respondsToSelector:@selector(editDepartmentWithModel:)]) {
                for (NSDictionary *listDic in listArray) {
                    DepartmentModel *model = [[DepartmentModel alloc] initWithDict:listDic];
                    if (model.ID == _model.ID) {
                        [self.delegate editDepartmentWithModel:model];
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshBranchList" object:nil];
                        [WSProgressHUD showSuccessWithStatus:dict[@"message"]];
                        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
                    }
                }
            }
        }else{
            [self showProgressWithMessage:dict[@"message"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}


-(void)showProgressWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:Affirm style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ----- cancel add department -----
-(void)cancelAction:(UIBarButtonItem *)barButtonItem
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
