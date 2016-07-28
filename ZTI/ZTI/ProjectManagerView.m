//
//  ProjectManagerView.m
//  ZTI
//
//  Created by Lukasz Matuszczak on 13/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import "ProjectManagerView.h"

@interface ProjectManagerView ()

@end

@implementation ProjectManagerView
-(void) addAI{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    [self.spinner setTag:123];
    self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    self.spinner.layer.cornerRadius = 0;
    self.spinner.opaque = NO;
    self.spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    self.spinner.center = self.view.center;
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.spinner setColor:[UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0]];
    [self.view addSubview:self.spinner]; // spinner is not visible until started
    [self.spinner startAnimating];
    
}

-(void) sideBarButtonAction2{
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/projects", [MyInfo getToken] ]]];
    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

    
     [self.projectTable removeAllObjects];
    [self.jsonArray removeAllObjects];
  

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jsonArray = [[NSMutableArray alloc] init];
    self.sidebarButton2=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_refresh"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(sideBarButtonAction2)];
    self.navigationItem.rightBarButtonItem=self.sidebarButton2;
    [self addAI];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:(231/255.0) green:(86/255.0) blue:(96/255.0) alpha:1];
    
    self.collectionViewMy.backgroundColor = [UIColor clearColor];
    self.collectionViewMy.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Georgia" size:15];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor colorWithRed:(231/255.0) green:(86/255.0) blue:(96/255.0) alpha:1]; // Your color here
    self.navigationItem.titleView = titleView;
    titleView.text =@"Z T I";
    [titleView sizeToFit];

    self.projectTable = [[NSMutableArray alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/projects", [MyInfo getToken] ]]];
    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
   
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        self.sidebarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"31353.png"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(revealToggle:)];
        [self.sidebarButton setTarget: self.revealViewController];
         self.navigationItem.leftBarButtonItem=self.sidebarButton;
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{NSLog(@"%@", [NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/projects", [MyInfo getToken] ]);
   NSString* newStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    if (newStr.length ==0) {
        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/projects", [MyInfo getToken] ]]];
        [request setHTTPMethod:@"GET"];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        return;
    }
   
    
     [self.jsonArray addObject:newStr];
[self.spinner removeFromSuperview];
    if ([newStr rangeOfString:@"}\n]"].location == NSNotFound) {
       
    }
    else{
        
       
        NSString * stmp = [[NSString alloc] init];
        for (NSString *s  in self.jsonArray) {
            stmp = [NSString stringWithFormat:@"%@%@", stmp, s];
        
        }
        NSLog(@"%@", stmp);
        self.projectTable = [self parseJSON:stmp];
    
    }
    [self.collectionViewMy reloadData];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    
    [self performSelector:@selector(refreshMethod)
               withObject:(self)
               afterDelay:(5)];
   
}

-(void) refreshMethod{
    [self showAlert:@"Sprawdź połączenie z internetem"];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/projects", [MyInfo getToken] ]]];
    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (NSMutableArray*)parseJSON: (NSString*) jsonText{
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSData *data =  [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    if([json valueForKey:@"status" ] !=nil)
    for( NSString *p in json){
        ProjectInfo * tmp = [[ProjectInfo alloc]init];
        [tmp setIdProject:[p valueForKey:@"_id"]];

        [tmp setColorProject:[p valueForKey:@"color"]];
                if ([[p valueForKey:@"color"] length] <2 ) {
                    [tmp setColorProject : @"#FFFFFF"];
                }
       
        [tmp setNameProject:[p valueForKey:@"name"]];
        [tmp setDescProject:[p valueForKey:@"description"]];
        [tmp setUsersProject:[p valueForKey:@"users"]];
        [retval addObject:tmp];
    }
    
    return  retval;
}
-(IBAction)showAlert:(NSString*) text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Ops!?"
                                                   message: text
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return self.projectTable.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cel" forIndexPath:indexPath];
    cell.name.text = [[self.projectTable objectAtIndex:indexPath.row] nameProject];
    if( [[self.projectTable objectAtIndex:indexPath.row] colorProject ].length  >0){
        
        CAGradientLayer* collectionRadient = [CAGradientLayer layer];
        collectionRadient.bounds = self.view.bounds;
        collectionRadient.anchorPoint = CGPointZero;
        collectionRadient.colors = [NSArray arrayWithObjects:(id)[[self colorFromHexString:[[self.projectTable objectAtIndex:indexPath.row] colorProject ]] CGColor],(id)[[UIColor blackColor] CGColor], nil];
        UIView *vv = [[UIView alloc] init];
        cell.backgroundView = vv;
        [cell.backgroundView.layer insertSublayer:collectionRadient atIndex:0];
    
    
    }
    else cell.backgroundColor = [UIColor whiteColor];

    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 6;
    cell.projectInfoObject = [self.projectTable objectAtIndex:indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectDirectViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectDirectViewController"];
    detail.projectInfoObject = [self.projectTable objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];

}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
-(void) chatRightButtonMethod{
    UserInfoViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
    detail.userId = [MyInfo getID];
    [self.navigationController pushViewController:detail animated:YES];
}
@end
