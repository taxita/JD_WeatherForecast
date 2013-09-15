//
//  ViewController.m
//  JD_Weather
//
//  Created by Hieu on 9/12/13.
//  Copyright (c) 2013 Hieu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize address, responseData, conn, arr, addrField;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    arr = [[NSMutableArray alloc]init];
    addrField.delegate = self;
    dic = [[NSMutableDictionary alloc]init];
    forecast = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showWeather:(id)sender {
    NSString * toAddress = [address text];
    NSString * URL = [NSString stringWithFormat:@"http://where.yahooapis.com/v1/places.q('%@')?appid=VF3_4l_V34EILscSYmLtMGL.plKYocWJDe6I7cabmyg7dgBx7l63JckYEVnAZEI6", toAddress];
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    rssParser = [self parseXMLFileAtURL:URL];
    [rssParser parse];
    
}



- (void) textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"File found and parsing started");
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    ElementValue = [[NSMutableString alloc]init];
    if ([elementName isEqualToString:@"yweather:forecast"]) {
        [forecast addObject:attributeDict];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [ElementValue appendString:string];
    NSCharacterSet * charToTrim = [NSCharacterSet characterSetWithCharactersInString:@" \n"];
    
    NSString *trimmedString = [ElementValue stringByTrimmingCharactersInSet:charToTrim];
    [ElementValue setString:trimmedString];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"item"]) {
        [articles addObject:[dic copy]];
    }
    else{
        [dic setObject:ElementValue forKey:elementName];
        if([elementName isEqualToString:@"woeid"]){
            woeid = ElementValue;
        }
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if(parser == rssParser){
        NSString * URL = [self prepareURLWithWOEID:woeid];
        wparser = [self parseXMLFileAtURL:URL];
        [wparser parse];
    }
    else if (parser == wparser){
        NSLog(@"%@", forecast);
    }
    
}

- (NSXMLParser *) parseXMLFileAtURL:(NSString *)URL{
    NSString *agentString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    [request setValue:agentString forHTTPHeaderField:@"User-Agent"];
    xmlFile = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    articles = [[NSMutableArray alloc]init];
    errorParsing = NO;
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:xmlFile];
    [parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    return parser;
}

- (NSString *) prepareURLWithWOEID: (NSString *) theWOEID{
    NSString * URL = [NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@", theWOEID];
    return URL;
}

@end
