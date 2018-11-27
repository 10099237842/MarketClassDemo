//
//  CategoryViewController.m
//  GLProject
//
//  Created by cendi on 2018/11/6.
//  Copyright © 2018 cendi. All rights reserved.
//

#import "CategoryViewController.h"
//cell
#import "CateTableViewCell.h"
#import "CateCollectionCell.h"
#import "CateCollectionHeaderView.h"

#define S_WIDTH [UIScreen mainScreen].bounds.size.width
#define S_HEIGHT [UIScreen mainScreen].bounds.size.height
#define S_NAVHEIGHT 64
#define TABLEVIEW_WIDTH 100
#define TABLEVIEW_HEIGHT S_HEIGHT - S_NAVHEIGHT
#define TABLEVIEW_CELLHEIGHT 53
#define COLLECTION_WIDTH (S_WIDTH - TABLEVIEW_WIDTH)
#define COLLECTION_HEIGHT S_HEIGHT - S_NAVHEIGHT
#define COLLECTION_HEADERVIEW_HEIGTH 33
#define COLLECTION_MARGIN 10
#define COLLECTION_ITEM_SIZE CGSizeMake ((COLLECTION_WIDTH - (COLLECTION_MARGIN * 3)) / 2 ,45)

@interface CategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
   
}
/// 左边大分类
@property (nonatomic,strong)UITableView *tableView;
/// 右边 小分类
@property (nonatomic,strong)UICollectionView *collectionView;
/// 所有数据数组
@property (nonatomic,strong)NSMutableArray *dataArray;
/// collection 数组
@property (nonatomic,strong)NSMutableArray *collectionArray;
///tableView 默认选中
@property (nonatomic,assign)NSInteger defaultSelet;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self configNAV];
    [self configeView];
    _defaultSelet = 0;
    [self getDataSourceFromeServe];
}

#pragma mark - 导航栏
- (void)configNAV
{
    self.title = @"e暖通";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blueColor]];
}
#pragma mark - 页面
- (void)configeView
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
}

#pragma mark - 数据
- (void)getDataSourceFromeServe
{
    NSString * urlStr = @"http://ceapp.1nuantong.com/api/index.php";
    NSString * parameter = @"user_id=175&act=catls";
    //1.创建会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    NSURL *url=[NSURL URLWithString:urlStr];
    
    //3.创建可变的请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod=@"POST";
    
    //5.设置请求体
    request.HTTPBody = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        //8.解析数据
       NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"请求结果: %@",dict);
        NSArray * resultArr = dict[@"typels"];
        for (NSDictionary * resultDic in resultArr) {
            [self.dataArray addObject:resultDic];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            //collection 默认数据
            [self updateCollectionViewDataWithSelectIndex:self.defaultSelet];
        });
    }];
    
    //7.执行任务
    [dataTask resume];
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLEVIEW_CELLHEIGHT;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CateTableViewCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CateTableViewCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = _dataArray[indexPath.row][@"name"];
    cell.select = _defaultSelet == indexPath.row ? YES : NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    if (_defaultSelet != indexPath.row) {
        [self updateCollectionViewDataWithSelectIndex:indexPath.row];
    }
    _defaultSelet = indexPath.row;
    [self.tableView reloadData];
}

#pragma mark - collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _collectionArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * arr = _collectionArray[section][@"zi"];
    return arr.count;
}

- (CGSize)collectionView:(UICollectionView * )collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(S_WIDTH, COLLECTION_HEADERVIEW_HEIGTH);
}

- (CGSize)collection:(UICollectionView * )collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  COLLECTION_ITEM_SIZE;
}

- (UICollectionReusableView * )collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CateCollectionHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CateCollectionHeaderView" forIndexPath:indexPath];
    view.backgroundColor = [UIColor whiteColor];
    view.titleLabel.text = _collectionArray[indexPath.section][@"name"];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CateCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CateCollectionCell" forIndexPath:indexPath];
    //数据
    NSArray * arr = _collectionArray[indexPath.section][@"zi"];
    NSString * title = arr[indexPath.item][@"name"];
    cell.titleLabel.text = title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arr = _collectionArray[indexPath.section][@"zi"];
    NSString * title = arr[indexPath.item][@"name"];
    NSLog(@"%@",title);
}



#pragma mark - lazyLoad
- (UITableView * )tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, S_NAVHEIGHT, TABLEVIEW_WIDTH, TABLEVIEW_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:(248/255.0f) green:(248/255.0f) blue:(248/255.0f) alpha:1.0f];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.tableView.separatorStyle = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"CateTableViewCell" bundle:nil] forCellReuseIdentifier:@"CateTableViewCell"];
    }
    return _tableView;
}

- (UICollectionView * )collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = COLLECTION_ITEM_SIZE;
        layout.minimumLineSpacing = COLLECTION_MARGIN;
        layout.minimumInteritemSpacing = COLLECTION_MARGIN;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tableView.frame), S_NAVHEIGHT, COLLECTION_WIDTH, COLLECTION_HEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithRed:(248/255.0f) green:(248/255.0f) blue:(248/255.0f) alpha:1.0f];;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"CateCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CateCollectionHeaderView"];
        [_collectionView registerNib:[UINib nibWithNibName:@"CateCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CateCollectionCell"];
    }
    return _collectionView;
}

- (NSMutableArray * )dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray * )collectionArray
{
    if (!_collectionArray) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}

#pragma mark - colltionView 刷新数据
- (void)updateCollectionViewDataWithSelectIndex:(NSInteger)select
{
    [self.collectionArray removeAllObjects];
    for (NSDictionary * collectDic in self.dataArray[select][@"zi"]) {
        [self.collectionArray addObject:collectDic];
    }
    [self.collectionView reloadData];
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
