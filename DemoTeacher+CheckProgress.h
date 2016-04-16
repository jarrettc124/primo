//
//  DemoTeacher+CheckProgress.h
//  Primo
//
//  Created by Jarrett Chen on 9/2/14.
//  Copyright (c) 2014 Pixel and Processor. All rights reserved.
//

#import "DemoTeacher.h"




@interface DemoTeacher (CheckProgress)<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

+(DemoTeacher*)findTeacherProgress:(NSManagedObjectContext*)context;
-(CGFloat)getTotalProgress;

-(UIImageView*)demoProgressTotalFrame:(CGRect)frame;

@end
