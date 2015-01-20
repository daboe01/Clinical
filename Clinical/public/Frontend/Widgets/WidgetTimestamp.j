@import "WidgetCappusance.j"


@implementation WidgetTimestamp : WidgetCappusance 
{

}
- (void)_takeTimeForValue:(CPString) aVal
{
    var timerDate=[CPDate new];
    var dateFormatter = [[CPDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SS"];
    [dateFormatter setTimeZone:[CPTimeZone timeZoneWithAbbreviation:"CET"]];
    [self setValue:[dateFormatter stringFromDate:timerDate] forKey:aVal];
}

- (void)takeTime:sender
{
    [self _takeTimeForValue:"value1"];
}
- (void)takeTime2:sender
{
    [self _takeTimeForValue:"value2"];
}
- (void)takeTime3:sender
{
    [self _takeTimeForValue:"value3"];
}
- (void)takeTime4:sender
{
    [self _takeTimeForValue:"value4"];
}
- (void)takeTime5:sender
{
    [self _takeTimeForValue:"value5"];
}
- (void)takeTime6:sender
{
    [self _takeTimeForValue:"value6"];
}
- (void)takeTime7:sender
{
    [self _takeTimeForValue:"value7"];
}
- (void)takeTime8:sender
{
    [self _takeTimeForValue:"value8"];
}
- (void)takeTime9:sender
{
    [self _takeTimeForValue:"value9"];
}
- (void)takeTime10:sender
{
    [self _takeTimeForValue:"value10"];
}


@end

@implementation CPButton(LabelStorage)
-(void)setStopwatchLabel:(id) aLabel
{
    self._stopwatchLabel=aLabel;
}
-(id)stopwatchLabel
{
    return self._stopwatchLabel;
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
    var   stopWatchValueKey;
    var   stopWatchValueKey2;
}

- (void)_startTimer:sender
{
   stopWatchLabel=sender._stopwatchLabel;
   if(!_running)
    {
        _running = YES;
        startDate=[CPDate new];
        var dateFormatter = [[CPDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SS"];
        [dateFormatter setTimeZone:[CPTimeZone timeZoneWithAbbreviation:"CET"]];
        [self setValue:[dateFormatter stringFromDate:startDate] forKey:stopWatchValueKey];
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
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SS"];
        [dateFormatter setTimeZone:[CPTimeZone timeZoneWithAbbreviation:"CET"]];

        var dateFormatter = [[CPDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm:ss.SS"];
        [dateFormatter setTimeZone:[CPTimeZone timeZoneWithAbbreviation:"CET"]];
        [self setValue:[dateFormatter stringFromDate:currentDate] forKey:stopWatchValueKey2];
    }
}
- (void)startTimer:sender
{   stopWatchValueKey="value1";
    stopWatchValueKey2="value2";
    [self _startTimer:sender];
}
- (void)startTimer1:sender
{   [self startTimer:sender];
}
- (void)startTimer2:sender
{   stopWatchValueKey="value3";
    stopWatchValueKey2="value4";
    [self _startTimer:sender];
}
- (void)startTimer3:sender
{   stopWatchValueKey="value5";
    stopWatchValueKey2="value6";
    [self _startTimer:sender];
}
- (void)startTimer4:sender
{   stopWatchValueKey="value7";
    stopWatchValueKey2="value8";
    [self _startTimer:sender];
}
- (void)startTimer5:sender
{   stopWatchValueKey="value9";
    stopWatchValueKey2="value10";
    [self _startTimer:sender];
}

-(void)showActivity:(CPTimer)timer
{
    var timeInterval = [[CPDate new] timeIntervalSinceDate:startDate];
    currentDate = [CPDate dateWithTimeIntervalSince1970:timeInterval];
    var dateFormatter = [[CPDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.SS"];
    [dateFormatter setTimeZone:[CPTimeZone timeZoneWithAbbreviation:"CET"]];
    [stopWatchLabel setStringValue:[dateFormatter stringFromDate:currentDate]];
} 


@end

