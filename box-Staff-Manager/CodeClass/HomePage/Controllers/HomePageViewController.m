//
//  HomePageViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/22.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomeBoxViewController.h"
#import "HomeDirectoryViewController.h"
#import "HomeMeViewController.h"
#import "HomeServiceViewController.h"

#define homeDirectoryVCTitle  @"地址簿"
#define HomeServiceVCTitle  @"服务"
#define HomeMeVCTitle  @"我"
#define homeBoxTitle  @"BOX"

#define PerfectInformationVCLaber  @"扫一扫完成授权"
#define PerfectInformationVCSubLaber  @"扫一扫私钥App完成账号授权"

@interface HomePageViewController ()<UITabBarDelegate,UITabBarControllerDelegate>

@property(nonatomic, strong)HomeBoxViewController *homeBoxVC;
@property(nonatomic, strong)HomeDirectoryViewController *homeDirectoryVC;
@property(nonatomic, strong)HomeMeViewController *HomeMeVC;
@property(nonatomic, strong)HomeServiceViewController *HomeServiceVC;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDirectoryInfo];
    [self initTabBarVC];
    // Do any additional setup after loading the view.
}

-(void)createDirectoryInfo
{
    NSInteger applyer_id = [[BoxDataManager sharedManager].applyer_id integerValue];
    NSString *path = [DeviceManager documentPathAppendingPathComponent:[NSString stringWithFormat:@"staffManager/%ld",(long)applyer_id]];
    NSString *dbPath = [path stringByAppendingPathComponent:@"message.db"];
    BOOL fileExist = [[NSFileManager defaultManager]fileExistsAtPath:path];
    if (!fileExist) {
        NSLog(@"没有发现数据库开始创建中。。。");
        NSError *error;
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            //创建数据库失败
            NSLog(@"------创建数据库失败");
        }else{
            NSString *dbPath = [path stringByAppendingPathComponent:@"message.db"];
            [DBHelp openDataBase:dbPath];
            //创建表结构
            [[DirectoryManager sharedManager] createDirectoryTable];
            [[MenberInfoManager sharedManager] createMenberInfoTable];
        }
    }else{
        NSLog(@"数据库存在 直接Open %@",dbPath);
        [DBHelp openDataBase:dbPath];
    }
}

-(void)initTabBarVC
{
    
#pragma mark ----- BOX -----
    self.homeBoxVC = [[HomeBoxViewController alloc]init];
    self.homeBoxVC.view.backgroundColor = [UIColor whiteColor];
    self.homeBoxVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"BOX" image:[UIImage imageNamed:@"homeBox_normal"] tag:0];
    //self.homeBoxVC.tabBarItem.image = [UIImage imageNamed:@"homeBox_normal"];
    self.homeBoxVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"homeBox_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.homeBoxVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]} forState:UIControlStateSelected];

#pragma mark ----- Directory -----
    self.homeDirectoryVC = [[HomeDirectoryViewController alloc]init];
    self.homeDirectoryVC.view.backgroundColor = [UIColor whiteColor];
    self.homeDirectoryVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:homeDirectoryVCTitle image:[UIImage imageNamed:@"homeDirectory_normal"] tag:1];
    //self.homeDirectoryVC.tabBarItem.image = [UIImage imageNamed:@"homeDirectory_normal"];
    self.homeDirectoryVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"homeDirectory_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.homeDirectoryVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]} forState:UIControlStateSelected];
    UINavigationController *homeDirectoryNV = [[UINavigationController alloc] initWithRootViewController:self.homeDirectoryVC];
    
    
#pragma mark ----- Service -----
    self.HomeServiceVC = [[HomeServiceViewController alloc]init];
    self.HomeServiceVC.view.backgroundColor = [UIColor whiteColor];
    self.HomeServiceVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:HomeServiceVCTitle image:[UIImage imageNamed:@"HomeService_normal"] tag:2];
    //self.HomeServiceVC.tabBarItem.image = [UIImage imageNamed:@"HomeService_normal"];
    self.HomeServiceVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"HomeService_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.HomeServiceVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]} forState:UIControlStateSelected];
    UINavigationController *HomeServiceNV = [[UINavigationController alloc] initWithRootViewController:self.HomeServiceVC];

#pragma mark ----- aboutMe -----
    self.HomeMeVC = [[HomeMeViewController alloc]init];
    self.HomeMeVC.view.backgroundColor = [UIColor whiteColor];
    self.HomeMeVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:HomeMeVCTitle image:[UIImage imageNamed:@"HomeMe_normal"] tag:3];
    //self.HomeMeVC.tabBarItem.image = [UIImage imageNamed:@"HomeMe_normal"];
    self.HomeMeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"HomeMe_click"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.HomeMeVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]} forState:UIControlStateSelected];
    self.HomeMeVC.title = HomeMeVCTitle;
    UINavigationController *HomeMeNC = [[UINavigationController alloc] initWithRootViewController:self.HomeMeVC];
    self.viewControllers = @[self.homeBoxVC, homeDirectoryNV, HomeServiceNV, HomeMeNC];
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
