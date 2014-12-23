@import "WidgetCappusance.j"


@implementation WidgetTimestamp : WidgetCappusance 
{

}

- (void)takeTime:sender
{
    var timerDate=[CPDate new];
    var dateFormatter = [[CPDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SS"];
    [dateFormatter setTimeZone:[CPTimeZone timeZoneForSecondsFromGMT:0.0]];
    [self setValue1:[dateFormatter stringFromDate:timerDate]];
}


@end


@implementation WidgetStopwatch : WidgetTimestamp 
{
    BOOL _running;
    var   startDate;
    var   currentDate;
    var   oriTitle;
    var   stopWatchTimer;
    var   stopWatchLabel;
}

- (void)takeTime:sender
{
    if(!_running)
    {
        _running = YES;
        startDate=[CPDate new];
        var dateFormatter = [[CPDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SS"];
        [dateFormatter setTimeZone:[CPTimeZone timeZoneForSecondsFromGMT:0.0]];
        [self setValue1:[dateFormatter stringFromDate:startDate]];
        oriTitle=[sender title];
        stopWatchTimer = [CPTimer scheduledTimerWithTimeInterval:1/10 target:self selector:@selector(showActivity:) userInfo:nil repeats:YES];
        [sender setTitle:"Stop"];
    } else
    {
        _running = NO;
        [sender setTitle:oriTitle];
        [stopWatchTimer invalidate];
         stopWatchTimer = nil;

        startDate=[CPDate new];
        var dateFormatter = [[CPDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss.SS"];
        [dateFormatter setTimeZone:[CPTimeZone timeZoneForSecondsFromGMT:0.0]];

        var dateFormatter = [[CPDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm:ss.SS"];
        [dateFormatter setTimeZone:[CPTimeZone timeZoneForSecondsFromGMT:0.0]];
        [self setValue2:[dateFormatter stringFromDate:currentDate]];
    }
}

-(void)showActivity:(CPTimer)timer
{
    var timeInterval = [[CPDate new] timeIntervalSinceDate:startDate];
    currentDate = [CPDate dateWithTimeIntervalSince1970:timeInterval];
    var dateFormatter = [[CPDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.SS"];
    [dateFormatter setTimeZone:[CPTimeZone timeZoneForSecondsFromGMT:0.0]];
    [stopWatchLabel setStringValue:[dateFormatter stringFromDate:currentDate]];
} 


@end

