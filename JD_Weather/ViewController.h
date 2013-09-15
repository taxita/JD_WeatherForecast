//
//  ViewController.h
//  JD_Weather
//
//  Created by Hieu on 9/12/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>{
    NSXMLParser * rssParser;
    NSMutableArray * articles;
    NSMutableDictionary * dic;
    NSString *currentElement;
    NSMutableString *ElementValue;
    BOOL errorParsing;
    NSString *pListPath;
    NSMutableDictionary * DataReadFromPList;
    NSString * woeid;
    NSXMLParser * wparser;
    NSMutableArray * forecast;
    NSData * xmlFile;
}
- (NSXMLParser *) parseXMLFileAtURL:(NSString *)URL;
- (IBAction)showWeather:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) NSMutableData * responseData;
@property (strong, nonatomic) NSURLConnection * conn;
@property (strong, nonatomic) NSMutableArray * arr;
@property (weak, nonatomic) IBOutlet UITextField *addrField;

@end
