//
//  MainWindowController.m
//  Monkey
//
//  Created by coderyi on 15/8/12.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "MainWindowController.h"
#import "UserRankViewModel.h"

#import "UserModel.h"
#import "RepositoryModel.h"
@interface MainWindowController ()<NSTableViewDataSource,NSTableViewDelegate,NSComboBoxDelegate,NSComboBoxDataSource>{
    NSArray *countrys;
    NSArray *cityArray;
    NSArray *languages;
    NSArray *repLanguages;
 
    UserRankViewModel *userRankViewModel;
}
@property (strong) IBOutlet NSTableView *userTableView;
@property (strong) IBOutlet NSTableView *repTableView;
@property (strong) IBOutlet NSComboBox *countryBox;
@property (strong) IBOutlet NSComboBox *cityBox;
@property (strong) IBOutlet NSComboBox *languageBox;
@property (strong) IBOutlet NSSegmentedControl *scopeSegment;
@property(nonatomic,strong)DataSourceModel *DsOfPageListObject1;
@property(nonatomic,strong)DataSourceModel *DsOfPageListObject;
@property (strong, nonatomic) MKNetworkOperation *apiOperation;
@property (strong) IBOutlet NSComboBox *repLanguageBox;
@property (strong) IBOutlet NSButton *pullButton;

@end

@implementation MainWindowController
#pragma mark - Lifecycle
- (instancetype)initWithWindowNibName:(NSString *)windowNibName{

    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        // Custom initialization
        self.DsOfPageListObject1 = [[DataSourceModel alloc]init];
        self.DsOfPageListObject = [[DataSourceModel alloc]init];

    
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.title=@"Monkey for GitHub-user and repository rank";
    userRankViewModel=[[UserRankViewModel alloc] init];
    
    _scopeSegment.selectedSegment=0;

    countrys=@[@"USA",@"UK",@"Germany",@"China",@"Canada",@"India",@"France",@"Australia",@"Other"];
    cityArray= @[@"San Francisco",@"New York",@"Seattle",@"Chicago",@"Los Angeles",@"Boston",@"Washington",@"San Diego",@"San Jose",@"Philadelphia"];
    languages=@[@"JavaScript",@"Java",@"PHP",@"Ruby",@"Python",@"CSS",@"C",@"Objective-C",@"Shell",@"R",@"Perl",@"Lua",@"HTML",@"Scala",@"Go"];
    
    repLanguages=@[@"JavaScript",@"Java",@"PHP",@"Ruby",@"Python",@"CSS",@"C",@"Objective-C",@"Shell",@"R",@"Perl",@"Lua",@"HTML",@"Scala",@"Go"];
    
    _countryBox.stringValue=[countrys objectAtIndex:0];
    _cityBox.stringValue=@"San Francisco";
    _languageBox.stringValue=[languages objectAtIndex:0];
    _repLanguageBox.stringValue=[repLanguages objectAtIndex:0];

    
    
    
    [_userTableView setDoubleAction:@selector(doubleClickAction:)];
    [_userTableView setTarget:self];
    [_repTableView setDoubleAction:@selector(doubleClickAction:)];
    [_repTableView setTarget:self];
    [_scopeSegment setTarget:self];
    [_scopeSegment setAction:@selector(segmentSelectionChanged)];
    
    
    [self loadDataFromApiWithIsFirst:YES];
    [self loadRepDataFromApiWithIsFirst:YES];
    
    
}
#pragma mark - Actions

- (IBAction)pullAction:(id)sender {
    NSButton *sender1=(NSButton *)sender;
    
    if (sender1.tag==131) {
        [self loadDataFromApiWithIsFirst:NO];
    }else if (sender1.tag==231){
        [self loadRepDataFromApiWithIsFirst:NO];

    }
}


- (IBAction)refreshAction:(id)sender {
    NSButton *sender1=(NSButton *)sender;
    
    if (sender1.tag==121) {
        [self loadDataFromApiWithIsFirst:YES];
    }else if (sender1.tag==221){
        [self loadRepDataFromApiWithIsFirst:YES];

    }
    
}





- (void)segmentSelectionChanged{
    NSInteger selectedSegment = [_scopeSegment selectedSegment];
    if (selectedSegment==0) {
        if (languages.count!=15) {
            languages=@[@"JavaScript",@"Java",@"PHP",@"Ruby",@"Python",@"CSS",@"C",@"Objective-C",@"Shell",@"R",@"Perl",@"Lua",@"HTML",@"Scala",@"Go"];
//            _languageBox.stringValue=languages[0];
        }
        
    }else{
        if (languages.count!=16) {
            languages=@[@"all languages",@"JavaScript",@"Java",@"PHP",@"Ruby",@"Python",@"CSS",@"C",@"Objective-C",@"Shell",@"R",@"Perl",@"Lua",@"HTML",@"Scala",@"Go"];
//            _languageBox.stringValue=languages[0];
        }
        
        
    }
    
     [_languageBox reloadData];
}
- (void)doubleClickAction:(NSTableView *)tableView{
    if (tableView.tag==101) {
        NSInteger rowNumber = [_userTableView clickedRow];
        NSString *s=((UserModel *)(self.DsOfPageListObject1.dsArray[rowNumber])).html_url;
        
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:s]];
    }else if (tableView.tag==201){
        
        NSInteger rowNumber = [_repTableView clickedRow];
        NSString *s=((RepositoryModel *)(self.DsOfPageListObject.dsArray[rowNumber])).html_url;
        
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:s]];
    }
   

}
#pragma mark - NSComboBoxDataSource  &NSComboBoxDelegate

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox{
    if (aComboBox.tag==111) {
        return countrys.count;
    }else if (aComboBox.tag==112){
        return cityArray.count;

    }else if (aComboBox.tag==113){
        return languages.count;
        
    }else if (aComboBox.tag==211){
        return repLanguages.count;

    }
    return 0;
    
}
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index{
    if (aComboBox.tag==111) {
        return countrys[index];
    }else if (aComboBox.tag==112){
        return cityArray[index];
        
    }else if (aComboBox.tag==113){
        return languages[index];
        
    }else if (aComboBox.tag==211){
        return repLanguages[index];
        
    }
    return @"";
}
- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    
  
    NSInteger row=_countryBox.indexOfSelectedItem;
    
    
    if (row==0) {
        //美国
        cityArray= @[@"San Francisco",@"New York",@"Seattle",@"Chicago",@"Los Angeles",@"Boston",@"Washington",@"San Diego",@"San Jose",@"Philadelphia"];
        
    }else if (row==1){
        //        uk
        cityArray= @[@"London",@"Cambridge",@"Manchester",@"Edinburgh",@"Bristol",@"Birmingham",@"Glasgow",@"Oxford",@"Newcastle",@"Leeds"];
    }else if (row==2){
        //germany
        cityArray= @[@"Berlin",@"Munich",@"Hamburg",@"Cologne",@"Stuttgart",@"Dresden",@"Leipzig"];
    }else if (row==3){
        cityArray= @[@"beijing",@"shanghai",@"shenzhen",@"hangzhou",@"guangzhou",@"chengdu",@"nanjing",@"wuhan",@"suzhou",@"xiamen",@"tianjin",@"chongqing",@"changsha"];
        
    }else if (row==4){
        //        canada
        cityArray= @[@"Toronto",@"Vancouver",@"Montreal",@"ottawa",@"Calgary",@"Quebec"];
    }else if (row==5){
        //        india
        cityArray= @[@"Chennai",@"Pune",@"Hyderabad",@"Mumbai",@"New Delhi",@"Noida",@"Ahmedabad",@"Gurgaon",@"Kolkata"];
    }else if (row==6){
        //        france
        cityArray= @[@"paris",@"Lyon",@"Toulouse",@"Nantes"];
    }else if (row==7){
        //        澳大利亚
        cityArray= @[@"sydney",@"Melbourne",@"Brisbane",@"Perth"];
    }else if (row==8){
        //        other
        cityArray= @[@"Tokyo",@"Moscow",@"Singapore",@"Seoul"];
    }
    _cityBox.stringValue=[cityArray objectAtIndex:0];
    [_cityBox reloadData];

}
#pragma mark - NSTableViewDataSource  &NSTableViewDelegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView.tag==101) {
        return self.DsOfPageListObject1.dsArray.count;
    }else if (tableView.tag==201){
        return self.DsOfPageListObject.dsArray.count;
    }
    return 10;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 50;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView.tag==101) {
        
   
    NSString *identifier = [tableColumn identifier];
        if ([identifier isEqualToString:@"user0"]) {
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
         
            cellView.textField.stringValue = [NSString stringWithFormat:@"%ld",row+1] ;
            
            
            return cellView;
        } else if ([identifier isEqualToString:@"user1"]){
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
            NSString *string=((UserModel *)(self.DsOfPageListObject1.dsArray[row])).login;
            cellView.textField.stringValue = string ;
              [cellView.imageView setImageURL:[NSURL URLWithString:((UserModel *)(self.DsOfPageListObject1.dsArray[row])).avatar_url]];

            return cellView;
        }

    
    }else if (tableView.tag==201) {
    
        NSString *identifier = [tableColumn identifier];

        if ([identifier isEqualToString:@"rep0"]) {
            
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
            cellView.textField.stringValue = [NSString stringWithFormat:@"%ld",row+1] ;
            
            return cellView;
            
        }else if ([identifier isEqualToString:@"rep1"]){
            
            NSImageView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
            [cellView setImageURL:[NSURL URLWithString:((RepositoryModel *)(self.DsOfPageListObject.dsArray[row])).user.avatar_url]];
            
            return cellView;
        }else if ([identifier isEqualToString:@"rep2"]){
            
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
            NSString *string=((RepositoryModel *)(self.DsOfPageListObject.dsArray[row])).full_name;
            cellView.textField.stringValue = string ;
            
            return cellView;
        }else if ([identifier isEqualToString:@"rep3"]){
            
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
            NSString *string=[NSString stringWithFormat:@"star:%d",((RepositoryModel *)(self.DsOfPageListObject.dsArray[row])).stargazers_count];
            cellView.textField.stringValue = string ;
            
            return cellView;
        }else if ([identifier isEqualToString:@"rep4"]){
            
            NSTableCellView *cellView = [tableView makeViewWithIdentifier:identifier owner:self];
            NSString *string=((RepositoryModel *)(self.DsOfPageListObject.dsArray[row])).repositoryDescription;
            cellView.textField.stringValue = string ;
            cellView.textField.textColor=YiTextGray;
            
            return cellView;
        }
      
     
    }
    return nil;
}


#pragma mark - Private


- (void)loadDataFromApiWithIsFirst:(BOOL)isFirst{
    
    NSInteger currentIndex=3-_scopeSegment.selectedSegment;
    NSString *language=_languageBox.stringValue;
    NSString *location=@"";
    if (currentIndex==1) {
        location=_cityBox.stringValue;

    }else if (currentIndex==2) {
        location=_countryBox.stringValue;
    }else if (currentIndex==3) {
    }
    
    [userRankViewModel loadDataFromApiWithIsFirst:isFirst
                                     currentIndex:currentIndex
                                         location:location
                                         language:language
                                   firstTableData:^(DataSourceModel* DsOfPageListObject){
                                       self.DsOfPageListObject1=DsOfPageListObject;
                                       [self.userTableView reloadData];
                                   }
                                  secondTableData:^(DataSourceModel* DsOfPageListObject){
                                      self.DsOfPageListObject1=DsOfPageListObject;
                                      [self.userTableView reloadData];
                                  }
                                   thirdTableData:^(DataSourceModel* DsOfPageListObject){
                                       self.DsOfPageListObject1=DsOfPageListObject;
                                       [self.userTableView reloadData];
                                   }];

}


- (BOOL)loadRepDataFromApiWithIsFirst:(BOOL)isFirst
{
    
    NSString *language=_repLanguageBox.stringValue;
    NSInteger page = 0;
    if (isFirst) {
        page = 1;
    }else{
        page = self.DsOfPageListObject.page+1;
    }
    NSMutableDictionary *header=[NSMutableDictionary dictionaryWithObject:@"application/vnd.github.v3+json" forKey:@"Accept"];
    YiNetworkEngine *apiEngine = [[YiNetworkEngine alloc] initWithHostName:@"api.github.com" customHeaderFields:header];
    [apiEngine searchRepositoriesWithPage:page
                                        q:[NSString stringWithFormat:@"language:%@",language] sort:@"stars"
                        completoinHandler:^(NSArray* modelArray,NSInteger page,NSInteger totalCount){
        
        if (page<=1) {
            [self.DsOfPageListObject.dsArray removeAllObjects];
        }
        [self.DsOfPageListObject.dsArray addObjectsFromArray:modelArray];
        self.DsOfPageListObject.page=page;
        [_repTableView reloadData];

        
    }
                              errorHandel:^(NSError* error){
                                                    
                                                      
                                                  }];
    
    
    
    
    return YES;
    
}

@end
