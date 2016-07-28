//
//  ProjectDirectViewController.m
//  ZTI
//
//  Created by Lukasz Matuszczak on 15/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import "ProjectDirectViewController.h"

@interface ProjectDirectViewController ()

@end

@implementation ProjectDirectViewController

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

- (void)viewDidLoad {
     
    [self addAI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:(231/255.0) green:(86/255.0) blue:(96/255.0) alpha:1];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Georgia" size:15];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor colorWithRed:(231/255.0) green:(86/255.0) blue:(96/255.0) alpha:1]; // Your color here
    self.navigationItem.titleView = titleView;
    titleView.text =@"Z T I";
    [titleView sizeToFit];

    
    self.sidebarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"airbrush_add.png"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(sideBarButtonAction)];
    self.navigationItem.rightBarButtonItem=self.sidebarButton;
    self.projectDesc.layer.masksToBounds = YES;
    self.projectDesc.layer.cornerRadius = 15;
}
-(void)viewDidAppear:(BOOL)animated{
    self.tableViewMy.hidden = YES;
    self.segmentViewOutlet.hidden = YES;
    flag=0;
    CGRect frame= self.segmentViewOutlet.frame;
    [self.segmentViewOutlet setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 150)];
    
 
    self.tableViewMy.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.titleOfView.text = self.projectInfoObject.nameProject;
    self.projectDesc.text = self.projectInfoObject.descProject;
    if (self.projectInfoObject.colorProject.length>0){
        self.titleOfView.backgroundColor = [self colorFromHexString:self.projectInfoObject.colorProject];
       
        self.segmentViewOutlet.layer.cornerRadius=30;
        self.segmentViewOutlet.layer.backgroundColor =[[self colorFromHexString:self.projectInfoObject.colorProject] CGColor] ;
       
        self.listaZadanOutlet.backgroundColor=[self colorFromHexString:self.projectInfoObject.colorProject] ;
    
    }
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/tasks/%@", [MyInfo getToken], self.projectInfoObject.idProject ]]];
  
    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    

    [self.tableViewMy reloadData];}

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
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{[self.spinner removeFromSuperview];
       
    NSString* newStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([newStr rangeOfString:@"taskId"].location != NSNotFound) 
    self.tasksTable = [self parseJSON:newStr];
    self.tasksTableMY = [[NSMutableArray alloc] init];
    for (TaskInfo* t in self.tasksTable) {
        if ([t.userId isEqualToString:[MyInfo getID]]) {
            [self.tasksTableMY addObject:t];
        }
    }
    [self.tableViewMy reloadData];
    
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{[self showAlert:@"Sprawdź połączenie z internetem"];
    
    
}

- (NSMutableArray*)parseJSON: (NSString*) jsonText{
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSData *data =  [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    if([json valueForKey:@"status" ] != @"fail")
        for( NSString *p in json){
            TaskInfo * tmp = [[TaskInfo alloc]init];
           
            [tmp setTaskId: [p valueForKey:@"taskId"]];
            
             [tmp setTaskName:[p valueForKey:@"taskName"]];
             [tmp setTaskDesc:[p valueForKey:@"taskDesc"]];
        
             [tmp setTaskTerm:[p valueForKey:@"term"]];
             [tmp setTaskProgress:[p valueForKey:@"progress"]];
             [tmp setStatus:[p valueForKey:@"status"]];
            [tmp setUserId:[p valueForKey:@"userId"]];
            
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



- (IBAction)segmentView:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        self.segmentedFlag =0;
        [self.tableViewMy reloadData];
        
        
        
    }
    if (selectedSegment == 1) {
        self.segmentedFlag =1;
        [self.tableViewMy reloadData];
    }
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.segmentedFlag == 0)
        return self.tasksTableMY.count;
    else
        return self.tasksTable.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    taskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(self.segmentedFlag == 0){
        
        cell.nameLabel.text = [[self.tasksTableMY objectAtIndex:indexPath.row] taskName];
        cell.dateLabel.text = [[self.tasksTableMY objectAtIndex:indexPath.row] taskTerm];
        cell.progressView.progress = [[[self.tasksTableMY objectAtIndex:indexPath.row] taskProgress] floatValue]/100;}
    
    else{
        
        
        
        cell.nameLabel.text = [[self.tasksTable objectAtIndex:indexPath.row] taskName];
        cell.dateLabel.text = [[self.tasksTable objectAtIndex:indexPath.row] taskTerm];
        cell.progressView.progress = [[[self.tasksTable objectAtIndex:indexPath.row] taskProgress] floatValue]/100;}
    
    cell.backgroundLabel.layer.masksToBounds =YES;
    cell.backgroundLabel.layer.cornerRadius = 15;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskAddViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskAddViewController"];
    if(self.segmentedFlag == 0)
        detail.taskObject = [self.tasksTableMY objectAtIndex:indexPath.row];
    else
        detail.taskObject = [self.tasksTable objectAtIndex:indexPath.row];
    detail.projectObject = self.projectInfoObject;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if(self.segmentedFlag == 0)
        {
            
            NSMutableURLRequest *request = [NSMutableURLRequest
                                            requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/tasks/%@/%@", [MyInfo getToken],self.projectInfoObject.idProject, [[self.tasksTableMY objectAtIndex:indexPath.row] taskId] ]]];
            [request setHTTPMethod:@"DELETE"];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            
            [self.tasksTable removeObject:[self.tasksTableMY objectAtIndex:indexPath.row ]];
            [self.tasksTableMY removeObjectAtIndex:indexPath.row];}
        else{
            
            NSMutableURLRequest *request = [NSMutableURLRequest
                                            requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/tasks/%@/%@", [MyInfo getToken],self.projectInfoObject.idProject, [[self.tasksTable objectAtIndex:indexPath.row] taskId]   ]]];
            [request setHTTPMethod:@"DELETE"];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            if ([[[self.tasksTable objectAtIndex:indexPath.row ] userId] isEqualToString:[MyInfo getID]])
                [self.tasksTableMY removeObject:[self.tasksTable objectAtIndex:indexPath.row ]];
            [self.tasksTable removeObjectAtIndex:indexPath.row];
            
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
-(void)sideBarButtonAction{
    TaskAddViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskAddViewController"];
    detail.taskObject = nil;
    detail.projectObject = self.projectInfoObject;
    [self.navigationController pushViewController:detail animated:YES];
}
static int flag = 0;
- (IBAction)lisaZadanbutton:(id)sender {
    if (flag==0) {
        
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         self.listaZadanOutlet.center = CGPointMake( self.listaZadanOutlet.center.x,  self.listaZadanOutlet.center.y + 10.0f);
                          self.projectDesc.frame =CGRectMake(self.projectDesc.frame.origin.x, self.projectDesc.frame.origin.y, self.projectDesc.frame.size.width, 378);
                         
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.5f
                                          animations:^{
                                              
                                               self.listaZadanOutlet.center = CGPointMake( self.listaZadanOutlet.center.x,  self.listaZadanOutlet.center.y - 302.0f);
                                               self.projectDesc.frame =CGRectMake(self.projectDesc.frame.origin.x, self.projectDesc.frame.origin.y, self.projectDesc.frame.size.width, 90);
                                              
                                          } completion:^(BOOL finished) {
                                              self.tableViewMy.hidden = NO;
                                              self.segmentViewOutlet.hidden = NO;
                                              self.projectDesc.frame = CGRectMake(self.projectDesc.frame.origin.x, self.projectDesc.frame.origin.y, self.projectDesc.frame.size.width, 90);
                                              flag =1;
                                          }];
                     }];}
    else{
    
       
      
        
        
        [UIView animateWithDuration:0.5f
                         animations:^{
                             
                             self.listaZadanOutlet.center = CGPointMake( self.listaZadanOutlet.center.x,  self.listaZadanOutlet.center.y - 10.0f);
                              self.projectDesc.frame =CGRectMake(self.projectDesc.frame.origin.x, self.projectDesc.frame.origin.y, self.projectDesc.frame.size.width, 90);
                             
                         } completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.5f
                                              animations:^{
                                                  
                                                  self.listaZadanOutlet.center = CGPointMake( self.listaZadanOutlet.center.x,  546);
                                                     self.projectDesc.frame =CGRectMake(self.projectDesc.frame.origin.x, self.projectDesc.frame.origin.y, self.projectDesc.frame.size.width, 378);
                                                  
                                              } completion:^(BOOL finished) {
                                                  self.tableViewMy.hidden = YES;
                                                  self.segmentViewOutlet.hidden = YES;
                                                  
                                                  flag =0;
                                              }];
                         }];}
}


@end
