/*
 * TODO: - Rechnungen im sinne von kontofuehrung
 *       - datei umbenennen geht nur 1x
 *       - datepicker
 *       - enabled bindings
 */

/////////////////////////////////////////////////////////


@import <Foundation/CPObject.j>
@import <Renaissance/Renaissance.j>
@import "CalendarController.j"
@import "VisitValuesController.j"


/////////////////////////////////////////////////////////
@implementation _CPDatePickerMonthView(DisablingExtension)
- (void)reloadData
{
    if (!_date)
        return;

    var currentMonth = _date,
        startOfMonthDay = [self startOfWeekForDate:currentMonth],
        daysInPreviousMonth = [_previousMonth _daysInMonth],
        firstDayToShowInPreviousMonth = daysInPreviousMonth - startOfMonthDay,
        currentDate = new Date(_previousMonth.getFullYear(), _previousMonth.getMonth(), firstDayToShowInPreviousMonth),
        now = [CPDate date],
        dateValue = [_datePicker dateValue];

    // Update the tiles
    for (var i = 0; i < [_dayTiles count]; i++)
    {
        var dayTile = _dayTiles[i];

        // Increment to next day
        currentDate.setTime(currentDate.getTime() + 90000000);
        [currentDate _resetToMidnight];

        var isPresentMonth = (now.getMonth() == currentDate.getMonth()
                      && now.getFullYear() == currentDate.getFullYear());

        [dayTile setDate:[currentDate copy]];
        [dayTile setStringValue:currentDate.getDate()];
        [dayTile setDisabled:![self isEnabled] || currentDate.getMonth() !== currentMonth.getMonth() || currentDate < [_datePicker minDate] || currentDate > [_datePicker maxDate]];
        [dayTile setHighlighted:isPresentMonth && currentDate.getDate() == now.getDate()];
    }

    // Select the dates
    [self _selectDate:[_datePicker dateValue] timeInterval:[_datePicker timeInterval]];
}
@end


@implementation CPTableView(ColumnFinder)
-(unsigned) findColumnWithTitle:(CPString) aTitle
{   var l=[_tableColumns count];
    for(var i=0;i<l;i++)
    {   if(_tableColumns[i]._identifier === aTitle)
            return i;
    }
    return -1;
}
@end
@implementation CPTextField(Cancel)
-(void)cancelOperation:sender
{
     if(_delegate && [_delegate respondsToSelector:@selector(cancelOperation:)]) 
     [_delegate cancelOperation:self]
}
@end
@implementation CPDatePicker(StringSupport)
-(void) setObjectValue:aVal
{
    if([aVal isKindOfClass:CPString])
        aVal=[[CPDate alloc] initWithShortString:aVal];
    [self setDateValue:aVal];

}
-(id) objectValue
{
    return [_value stringValue];
}
-(void)cancelOperation:sender
{
     if(_delegate && [_delegate respondsToSelector:@selector(cancelOperation:)]) 
     [_delegate cancelOperation:self]
}

@end

@implementation OperationsController : CPObject
{
    id  trialsWindow;
    id  trialsTV;
    id  propsTV;
    id  addPropsWindow;
    id  addPropsTV;
    id  patsTV;
    id  patdatesTV;
    id  popover;
    id  bookingPopover;
    id  annotationPopover;
    id  annotationsTV;
    id  annotationsWindow;
    id  bookingText;
    id  bookingBox;
    id  bookingConnection;
    id  bookingOk;
    id  bookingCancel;
    id  bookingProgress;
    id  searchTerm @accessors;
    id  accountsWindow;
    id  travelWindow;
    id  mainButtonBar;
    id  visitsButtonBar;
    id  documentsButtonBar;
    id  editTextWindow;
    id  propsButtonBar;
    id  billingButtonBar;
    id  patientsButtonBar;
    id  travelButtonBar;
    id  graphicalPicker;
    id  datePickerPopover;
    id  timeTV;
    id  visitsTV;
    id  visitsBillingWindow;
    id  billingsTV;
    id  accountsProgress;

    id  distanceCalcConnection;
    id  serviceConnection;
    id  ibanConnection;
    id  accountsConnection;
}


-(void) newTrial: sender
{
    [self setSearchTerm: ""];
    var idgroup=[[[[CPApp delegate].personnelController valueForKeyPath:"selection.groups"] objectAtIndex:0] valueForKeyPath:"idgroup"];
// FIXME: is this deterministic if you are assigned to multiple groups?
    [[CPApp delegate].trialsController addObject:@{"name": "New trial", "idgroup":idgroup}];
    [trialsTV editColumn:[trialsTV findColumnWithTitle:"name"] row:[trialsTV selectedRow] withEvent:nil  select:YES];
}

- (void)deleteTrialWarningDidEnd:(CPAlert)anAlert code:(id)code context:(id)context
{   var trialsController=[CPApp delegate].trialsController;
    if(code)
    {   [trialsController remove:self];
    }
}

-(void) _performPostLoadInit
{
    [[CPApp delegate].dokusController2 addObserver:self forKeyPath:"selection" options: nil context: nil];
    [[CPApp delegate].dokusController addObserver:self forKeyPath:"selection.tag" options: nil context: nil];

    var button=[mainButtonBar addButtonWithImageName:"config.png" target:self action:@selector(runConfig:)];
    [button bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"trialsController.selection.@count" options:nil];
    [button setToolTip:"Configure trial and visits..."];
    button=[mainButtonBar addButtonWithImageName:"reload.png" target:self action:@selector(reloadTrialsList:)];
    [button setToolTip:"Reload trials"];
    button=[mainButtonBar addButtonWithImageName:"download.png" target:self action:@selector(downloadExcel:)];
    [button setToolTip:"Download trial list"];
    button=[mainButtonBar addButtonWithImageName:"play.png" target:self action:@selector(openOnsite:)];
    [button setToolTip:"Run data entry mode"];
    [mainButtonBar registerWithArrayController:[CPApp delegate].trialsController plusTooltip:"Create new trial" minusTooltip:"Delete selected trial..."];

    button=[visitsButtonBar addButtonWithImageName:"reload.png" target:self action:@selector(recalcVisits:)];
    [button setToolTip:"Reload and validate visits"];
    button=[visitsButtonBar addButtonWithImageName:"print.png" target:self action:@selector(printVisits:)];
    [button setToolTip:"Print visits overview"];
    [button bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"patientVisitsController.arrangedObjects.@count" options:nil];
    [visitsButtonBar registerWithArrayController:[CPApp delegate].patientVisitsController plusTooltip:"Insert visit" minusTooltip:"Delete selected visit"];


    var button=[documentsButtonBar addButtonWithImageName:"download.png" target:self action:@selector(doDownload:)];
    [button setToolTip:"Download/view document"];
    [button bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"dokusController.selection.@count" options:nil];
    [documentsButtonBar registerWithArrayController:[CPApp delegate].dokusController plusTooltip:"Upload document" minusTooltip:"Delete selected document..."];
    var button=[documentsButtonBar addButtonWithImageName:"reload.png" target:self action:@selector(_reloadDokus)];
    [button setToolTip:"Refresh lists"];

    button=[propsButtonBar addButtonWithImageName:"edit.png" target:editTextWindow action:@selector(makeKeyAndOrderFront:)];
    [button setToolTip:"Open multiline editor"];
    var button=[propsButtonBar addButtonWithImageName:"play.png" target:self action:@selector(openURL:)];
    [button setToolTip:"Open ressource"];
    [button bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"propertiesController.selection.value" options:nil];
    [propsButtonBar registerWithArrayController:[CPApp delegate].propertiesController plusTooltip:"Insert property" minusTooltip:"Delete selected property"];

    var button=[billingButtonBar addButtonWithImageName:"download.png" target:self action:@selector(printBill:)];
    [button setToolTip:"Download billing form"];
    [button bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"billingsController.selectedObjects.@count" options:nil];
    [billingButtonBar registerWithArrayController:[CPApp delegate].billingsController plusTooltip:"Create new billing" minusTooltip:"Delete selected billing..."];

    var button=[patientsButtonBar addButtonWithImageName:"download.png" target:self action:@selector(downloadPatients:)];
    [button setToolTip:"Download list of patients"];
    [button bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"patientsController.selection.@count" options:nil];
    [patientsButtonBar registerWithArrayController:[CPApp delegate].patientsController plusTooltip:"Add patient to trial" minusTooltip:"Remove patient..."];
    
    var button=[travelButtonBar addButtonWithImageName:"print.png" target:self action:@selector(fahrtkostenForm:)];
    [button bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"patientVisitsController2.selectedObjects.@count" options:nil];
}
-(void) reloadTrialsList:sender
{
    [[CPApp delegate].trialsController._entity _invalidatePKCache]
    [[CPApp delegate].trialsController setContent:[[CPApp delegate].trialsController._entity allObjects] ];
}

-(void) _reloadDokus
{
    [[CPApp delegate].dokusController reload];
    [[CPApp delegate].dokusController2 reload];

}

- (void)observeValueForKeyPath: keyPath ofObject: object change: change context: context
{   if(object == [CPApp delegate].dokusController2)
    {
        [[CPApp delegate].dokusController setFilterPredicate: [CPPredicate predicateWithFormat:"tag = %@", [object valueForKeyPath:"selection.tag"] ]];

    } else if(object == [CPApp delegate].dokusController)
    {   if([change objectForKey:"CPKeyValueChangeOldKey"] !== [change objectForKey:"CPKeyValueChangeNewKey"])
        {   [[CPRunLoop currentRunLoop] performSelector:@selector(_reloadDokus) target:self argument: nil order:0 modes:[CPDefaultRunLoopMode]];
        }
    }
}


-(void) removeTrial: sender
{
    var myalert = [CPAlert new];
    [myalert setMessageText: "Are you sure you want to delete the trial?"];
    [myalert addButtonWithTitle:"Cancel"];
    [myalert addButtonWithTitle:"Delete"];
    [myalert beginSheetModalForWindow: trialsWindow modalDelegate:self didEndSelector:@selector(deleteTrialWarningDidEnd:code:context:) contextInfo: nil];
}

-(void) addStep: sender
{   var processesController=[CPApp delegate].processesController;
    [processesController insert: self];
    [[processesController selectedObject] reload];    // because of default values from the database
}
-(void) removeStep: sender
{   var processesController=[CPApp delegate].processesController;
    [processesController remove: self];
}

-(void) uploadDoku: sender
{
    [CPApp delegate]._uploadMode=0;

    [UploadManager sharedUploadManager];
}
-(void) cancelAddProperty: sender
{   [popover close];
}
-(void) performAddProperty: sender
{   [popover close];
    var pcController=[CPApp delegate].propertiesCatController;
    var pController= [CPApp delegate].propertiesController;
    var selected=[pcController selectedObjects];
    var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
    var l=[selected count];
    for(var i=0; i< l; i++)
    {   var pk= [[selected objectAtIndex:i] valueForKey:"id"];
        var val=[[selected objectAtIndex:i] valueForKey:"default_value"];
        [pController addObject:@{"idproperty": pk, "idtrial": idtrial, "value": val} ];
    }
}
-(void) addProperty: sender
{
    if( !popover)
    {    popover=[CPPopover new];
        [popover setDelegate:self];
        [popover setAnimates:NO];
        [popover setBehavior: CPPopoverBehaviorTransient ];
        [popover setAppearance: CPPopoverAppearanceMinimal];
        var myViewController=[CPViewController new];
        [popover setContentViewController:myViewController];
        [myViewController setView: [addPropsWindow contentView]];
    }
    [popover showRelativeToRect:NULL ofView: sender preferredEdge: nil];
    [[addPropsTV window] makeFirstResponder: addPropsTV]    
}
-(void) removeProperty: sender
{   var pController=[CPApp delegate].propertiesController;
    [pController remove: self];
}
-(void) openAnnotation: sender
{   if( !annotationPopover)
    {    annotationPopover =[CPPopover new];
        [annotationPopover setDelegate:self];
        [annotationPopover setAnimates:YES];
        [annotationPopover setBehavior: CPPopoverBehaviorTransient ];
        [annotationPopover setAppearance: CPPopoverAppearanceMinimal];
        var myViewController=[CPViewController new];
        [annotationPopover setContentViewController:myViewController];
        [myViewController setView: [annotationsWindow contentView]];
    }
    var sel=[[propsTV selectedRowIndexes] firstIndex];
    var rect= [propsTV _rectOfRow: sel checkRange:NO];
    [annotationPopover showRelativeToRect:rect ofView: propsTV preferredEdge: nil];
}
-(void) addAnnotation: sender
{   var trialPropAnnotationsController=[CPApp delegate].trialPropAnnotationsController;
    [trialPropAnnotationsController addObject:@{"ldap": window.G_USERNAME} ];

}
-(void) removeAnnotation: sender
{   var trialPropAnnotationsController=[CPApp delegate].trialPropAnnotationsController;
    [trialPropAnnotationsController remove: self];
}
-(void) removeCatProperty: sender
{   var pController=[CPApp delegate].propertiesCatController;
    [pController remove: self];
}
-(void) addCatProperty: sender
{   var pController=[CPApp delegate].propertiesCatController;
    [pController insert: self];
    [addPropsTV editColumn:0 row:[addPropsTV selectedRow] withEvent:nil  select:YES];
}

-(void) doDownload: sender
{   var trialsController=[CPApp delegate].trialsController;
    var idtrial=[trialsController valueForKeyPath:"selection.id"];
    var dokuController=[CPApp delegate].dokusController;
    var iddoku=[dokuController valueForKeyPath:"selection.name"];
    window.open("/CT/download/"+idtrial+"/"+iddoku , 'download_window');
}

- (void)deleteDocWarningDidEnd:(CPAlert)anAlert code:(id)code context:(id)context
{   var dokusController=[CPApp delegate].dokusController;
    if(code)
    {   [dokusController remove:self];
    }
}
-(void) deleteDoku: sender
{   var myalert = [CPAlert new];
    [myalert setMessageText: "Are you sure you want to delete this document?"];
    [myalert addButtonWithTitle:"Cancel"];
    [myalert addButtonWithTitle:"Delete"];
    [myalert beginSheetModalForWindow: trialsWindow modalDelegate:self didEndSelector:@selector(deleteDocWarningDidEnd:code:context:) contextInfo: nil];
}

-(void) makeAllFields: sender
{   var trialsController=[CPApp delegate].trialsController;
    var idtrial=[trialsController valueForKeyPath:"selection.id"];
    var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/make_properties/"+idtrial];
    [CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];
    [[CPApp delegate].propertiesController reload];
}


-(void) openURL: sender
{   var pController=[CPApp delegate].propertiesController;
    var myURL=[pController valueForKeyPath:"selection.value"];
    if([myURL hasPrefix:"http"]) window.open(myURL , 'open_urlwindow');
    else if([myURL hasPrefix:"NCT"]) window.open('http://clinicaltrials.gov/ct2/show/'+myURL , 'open_urlwindow');
    else if (myURL.indexOf("@") > 0) window.location='mailto:'+myURL;
    else if ([pController valueForKeyPath:"selection.property.name"] == 'Drittmittelnummer') [self openKontoauszuege:self];
    else if ([pController valueForKeyPath:"selection.property.name"] == 'Serienbrief') [self openSeriebriefe:self];
    else alert("Cannot open "+myURL);
}
-(void) openSeriebriefe: sender
{
    window.open("/CT/serienbrief_patienten/"+[[CPApp delegate].propertiesController valueForKeyPath:"selection.id"] +'?session='+ window.G_SESSION, 'download_window');
}

- (void)deletePatientWarningDidEnd:(CPAlert)anAlert code:(id)code context:(id)context
{   var myController= [CPApp delegate].billingsController
    if(code)
    {   var pController=[CPApp delegate].patientsController;
        [pController remove: self];
    }
}

-(void) deletePatient: sender
{
    var myalert = [CPAlert new];
    [myalert setMessageText: "Are you sure you want to delete this patient?"];
    [myalert addButtonWithTitle:"Cancel"];
    [myalert addButtonWithTitle:"Delete"];
    [myalert beginSheetModalForWindow:trialsWindow modalDelegate:self didEndSelector:@selector(deletePatientWarningDidEnd:code:context:) contextInfo: nil];
}

-(void) addPatient: sender
{   var patientsController=[CPApp delegate].patientsController;
    [patientsController insert: self];
    [patientsController rearrangeObjects];
    [patsTV editColumn:[patsTV findColumnWithTitle:"piz"] row:[patsTV selectedRow] withEvent:nil select:YES];
    [self addDefaultVisits: self];
}

-(void) connection: someConnection didReceiveData: data
{

// async fetching of service-alerts (docscal is so slow)
    if(someConnection === serviceConnection)
    {
        serviceConnection = nil;
        var j = JSON.parse(data);
        if (j)
        {   var i,l=j.length;
            var entity=[CPApp delegate].patientVisitsController._entity;
            var store=entity._store;
            for(i=0;i<l;i++)
            {   var pk =j[i]["id"];
                var msg=j[i]["missing_service"];
                var o=[entity _registeredObjectForPK:pk];
                entity._store=nil;
                [o setValue:msg forKey:"missing_service"];
                entity._store=store;

            }
       }
    } else if(someConnection === distanceCalcConnection)
    {
       [distanceCalcConnection._patient setValue:data forKey:"travel_distance"];
        distanceCalcConnection._patient=nil;
        distanceCalcConnection = nil;
    } else if(someConnection === bookingConnection)
    {
        [bookingProgress stopAnimation: self];
        [bookingPopover close];

        // reload dc-termine to remove the allocated or invalid entry
        [[CPApp delegate].visitDatesController reload];

        if(data === '0')
        {
            [someConnection._bookingObject setValue: someConnection._bookingDate forKey:"visit_date"];
            someConnection._bookingDate=nil;
            someConnection._bookingObject=nil;
        } else
        {   alert("buchung nicht erfolgreich. nochmal versuchen");        // <!> fixme
        }
        bookingConnection=nil;
    } else if(someConnection === ibanConnection)
    {
        ibanConnection = nil;
        [[[CPApp delegate].patientsController selectedObject] reload];
        if(data === 'NOK')
        {
            alert("IBAN inkorrekt");
        }

    } else if(someConnection === accountsConnection)
    {
        accountsConnection=nil;
        [[CPApp delegate].transactionsController reload]
        [accountsProgress stopAnimation: self];
    }
}

-(void) doBookInDocscal: sender
{   var patController=[CPApp delegate].patientsController;
    var visitDatesController=[CPApp delegate].visitDatesController;

    var piz=[[patController selectedObject] valueForKeyPath:"piz"];
    if(!piz)
    {   alert("no piz given");    // <!> fixme
        return;
    }
    var dcid=[[visitDatesController selectedObject] valueForKey:"dcid"];
    var text=[bookingText stringValue];
    var idvisit= [[[CPApp delegate].patientVisitsController selectedObject] valueForKey:"idvisit"];
    var myreq=[CPURLRequest requestWithURL:"/CT/booking/"+piz+"/"+dcid+"/"+ idvisit ];
    [myreq setHTTPMethod:"POST"];
    [myreq setHTTPBody: text];
     bookingConnection=[CPURLConnection connectionWithRequest: myreq delegate: self];
     bookingConnection._bookingDate=[[visitDatesController selectedObject] valueForKey:"startdate"];
     bookingConnection._bookingObject= [[CPApp delegate].patientVisitsController selectedObject];
    [bookingProgress startAnimation: self];
    [bookingOk setEnabled:NO];
    [bookingCancel setEnabled:NO];
}

-(void) bookInDocscal: sender
{
// <!> fixme: alert if no PIZ is given
    if (!bookingPopover)
    {    bookingPopover=[CPPopover new];
        [bookingPopover setDelegate:self];
        [bookingPopover setAnimates:NO];
        [bookingPopover setBehavior: CPPopoverBehaviorTransient ];
        [bookingPopover setAppearance: CPPopoverAppearanceMinimal];
         var myViewController=[CPViewController new];
        [myViewController setView: bookingBox];
        [bookingPopover setContentViewController:myViewController];
    }
    var sel=[[patdatesTV selectedRowIndexes] firstIndex];
    var rect= [patdatesTV _rectOfRow: sel checkRange:NO];
    var mytext=[[[CPApp delegate].trialsController selectedObject] valueForKey:"name"]+" "+[[[CPApp delegate].patientVisitsController selectedObject] valueForKeyPath:"visit.name"]
    [bookingText setStringValue: mytext];
    [bookingOk setEnabled:YES];
    [bookingCancel setEnabled:YES];
    [bookingPopover showRelativeToRect:rect ofView: patdatesTV preferredEdge: nil];
    [[bookingText window] makeFirstResponder: bookingText]    

}

-(void) _recalcService: sender
{
    var idpatient=[[CPApp delegate].patientsController valueForKeyPath: "selection.id"];
    var myreq=[CPURLRequest requestWithURL:"/DBI/patient_visits_service/idpatient/"+idpatient+'?session='+ window.G_SESSION];
    serviceConnection=[CPURLConnection connectionWithRequest: myreq delegate: self];
}
-(void) recalcVisits: sender
{
    [[CPApp delegate].patientVisitsController reload];
    [[CPApp delegate].visitDatesController reload];
    [[CPRunLoop currentRunLoop] performSelector:@selector(_recalcService:) target:self argument: self order:0 modes:[CPDefaultRunLoopMode]];
}

-(void) addDefaultVisits: sender
{   var idpatient=[[CPApp delegate].patientsController valueForKeyPath: "selection.id"];
    var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/new_patient/"+idpatient];
    [CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];
    [[CPApp delegate].patientVisitsController reload];

}

-(void) insertVisit: sender
{   [[CPApp delegate].patientVisitsController insert: sender];
}

-(void) removeVisit: sender
{   [[CPApp delegate].patientVisitsController remove: sender];
}

-(void) runConfig: sender
{
    [CPBundle loadRessourceNamed: "AdminTrial.gsmarkup" owner:[CPApp delegate] ];
    [[CPApp delegate].adminButtonBar addButtonWithImageName:"sort.png" target:[CPApp delegate] action:@selector(reorderVisits:)];
    [[CPApp delegate].adminButtonBar addButtonWithImageName:"reload.png" target:[CPApp delegate] action:@selector(reloadVisits:)];

    var plusbutton= [[CPApp delegate].visitprocBB buttons][0],
        minusbutton=[[CPApp delegate].visitprocBB buttons][1];
    [plusbutton bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"visitsController.selection.@count" options:nil];
    [minusbutton bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"proceduresVisitController.selection.@count" options:nil];

    var plusbutton= [[CPApp delegate].visitpersoBB buttons][0],
        minusbutton=[[CPApp delegate].visitpersoBB buttons][1];
    [plusbutton bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"proceduresVisitController.selection.@count" options:nil];
    [minusbutton bind:CPEnabledBinding toObject:[CPApp delegate] withKeyPath:"proceduresPersonnelController.selection.@count" options:nil];

}


-(void) printDocumentNamed: (CPString) aName withPIZ:(BOOL) withPIZFlag filter:(CPString) aFilter ownWindow:(BOOL) winflag
{   var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
    var myurl='/CT/pdfstamper/'+idtrial+'/'+aName+'?session='+ window.G_SESSION;
    if(withPIZFlag){
        var piz=[[CPApp delegate].patientsController valueForKeyPath:"selection.piz"];
        myurl += "&piz="+piz;
    }
    if(aFilter){
        myurl += "&filter="+aFilter;
    }
    winflag? window.open(myurl, 'download_window'): document.location=myurl;
}

-(void) printDocumentNamed: (CPString) aName withPIZ:(BOOL) withPIZFlag filter:(CPString) aFilter
{
    [self printDocumentNamed:aName withPIZ:withPIZFlag filter:aFilter ownWindow:YES];
}

-(void) printDocumentNamed: (CPString) aName withPIZ:(BOOL) withPIZFlag 
{
    [self printDocumentNamed:  aName withPIZ:withPIZFlag filter:""];
}

-(void) printDocumentNamed: (CPString) aName
{   [self printDocumentNamed:  aName withPIZ:NO];
}

-(void) printDrittmittelanzeige: sender
{   [self printDocumentNamed:"drittmittelanzeige"];
}
-(void) printAnschreibenVertrag: sender
{   [self printDocumentNamed:"anschreibenvertrag"];
}

-(void)downloadExcel: sender
{   document.location='/CT/download_list?session='+ window.G_SESSION+'&excel=1';
}
-(void)printVisits: sender
{
    [self printDocumentNamed: "visitenliste" withPIZ:YES filter:"" ownWindow:YES];
}



-(void)downloadPatients: sender
{   var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
    document.location='/CT/download_patients/'+idtrial+'?session='+ window.G_SESSION;
}
-(void)createTodoList: sender
{   var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
    document.location='/CT/todolist_trial/'+idtrial+'?session='+ window.G_SESSION;
}
-(void)downloadInkassoList: sender
{   document.location='/CT/duelist/'+'?session='+ window.G_SESSION;
}

-(void)createTodoListGlobal: sender
{   document.location='/CT/todolist?session='+ window.G_SESSION;
}

-(void)createUnbilledList: sender
{   document.location='/CT/unbilledlist?session='+ window.G_SESSION;
}
-(void)createConflictList: sender
{   document.location='/CT/conflictlist?session='+ window.G_SESSION;
}
-(void) runDCV: sender
{
    window.open("http://augimageserver/Viewer/?"+ [[[CPApp delegate].patientsController selectedObject] valueForKeyPath:"piz"], 'docscal_window');
}
-(void) hausarztBrief:sender
{   [self printDocumentNamed:"hausarztbrief" withPIZ:"YES"];
}
-(void) fahrtkostenForm:sender
{
    var filter="";
    var selected=[[CPApp delegate].patientVisitsController2 selectedObjects];
    var l=[selected count];
    for(var i=0; i< l; i++)
    {   var pk=[[selected objectAtIndex:i] valueForKey:"id"];
        filter+=pk+',';
    }
   [self printDocumentNamed:"reisekosten" withPIZ:"YES" filter:filter];
}
-(void) markTravelReimbursed:sender
{
    var filter="";
    var selected=[[CPApp delegate].patientVisitsController2 selectedObjects];
    var l=[selected count];
    for(var i=0; i< l; i++)
    {   [[selected objectAtIndex:i] setValue:[[CPDate new] shortDescription] forKey:"date_reimbursed"];
    }
}


-(void) fahrtkostenPanel:sender
{   if(! parseInt([[CPApp delegate].patientsController valueForKeyPath: "selection.travel_distance"],10) ) 
    {   var idpatient=[[CPApp delegate].patientsController valueForKeyPath: "selection.id"];
        var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/travel_distance/"+idpatient];
        distanceCalcConnection=    [CPURLConnection connectionWithRequest: myreq delegate: self];
        distanceCalcConnection._patient=[[CPApp delegate].patientsController selectedObject];
    }
    [travelWindow makeKeyAndOrderFront:self];
}

-(void) createBillFilteredVisits:sender
{
    [visitsBillingWindow makeKeyAndOrderFront:self];
}

-(void) addVisitsToBill:sender
{
    var filter="";
    var selected=[[CPApp delegate].patientVisitsController2 selectedObjects];
    var l=[selected count];
    for(var i=0; i< l; i++)
    {   var pk=[[selected objectAtIndex:i] valueForKey:"id"];
        filter+=pk+',';
    }
    var idtrial= [[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
    var idbill = [[CPApp delegate].billingsController valueForKeyPath:"selection.id"]
    var myreq=[CPURLRequest requestWithURL:"/CT/make_bill/"+idtrial+'?session='+ window.G_SESSION+'&idammendbill='+idbill];
    [myreq setHTTPMethod:"POST"];
    [myreq setHTTPBody: filter];
    [CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];
    [[[CPApp delegate].billingsController selectedObject] reload];
}

-(void) validateIBAN:sender
{   var idpatient=[[CPApp delegate].patientsController valueForKeyPath: "selection.id"];
    var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/validate_iban/"+idpatient];
    ibanConnection=    [CPURLConnection connectionWithRequest:myreq delegate: self];
}

-(void) runCalendar: sender
{   [CalendarController new]
}


-(void) reloadBillings: sender
{   [[CPApp delegate].billingsController reload];
}

-(void) addBill: sender
{   var billingsController=[CPApp delegate].billingsController;
    [billingsController insert: sender];
    [[billingsController selectedObject] reload];
}


-(void) createBillWithFilter:(CPString) filter postfix:(CPString) aPostfix
{   var trialsController=[CPApp delegate].trialsController;
    var idtrial=[trialsController valueForKeyPath:"selection.id"];
    var myreq=[CPURLRequest requestWithURL:"/CT/make_bill/"+idtrial+'?session='+ window.G_SESSION+ aPostfix];
    [myreq setHTTPMethod:"POST"];
    [myreq setHTTPBody: filter];
    [CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];
    [[CPRunLoop currentRunLoop] performSelector:@selector(reloadBillings:) target:self argument: self order:0 modes:[CPDefaultRunLoopMode]];
}
-(void) createBillWithFilter:(CPString) filter
{   [self createBillWithFilter:filter postfix:""];
}
-(void) createBillFiltered: sender
{   var filter="";
    var selected=[[CPApp delegate].patientsController selectedObjects];
    var l=[selected count];
    for(var i=0; i< l; i++)
    {   var pk=[[selected objectAtIndex:i] valueForKey:"id"];
        filter+=pk+',';
    }
   [self createBillWithFilter:filter];
}
-(void) createBill: sender
{   [self createBillWithFilter:""];
}

-(void) createTravelBill:sender
{   [self createBillWithFilter:"" postfix:"&travelbill=1"];
}

- (void)deleteBillWarningDidEnd:(CPAlert)anAlert code:(id)code context:(id)context
{   var myController= [CPApp delegate].billingsController
    if(code)
    {   [myController remove:self];
    }
}

-(void) removeBill: sender
{
    var myalert = [CPAlert new];
    [myalert setMessageText: "Are you sure you want to delete the bill?"];
    [myalert addButtonWithTitle:"Cancel"];
    [myalert addButtonWithTitle:"Delete"];
    [myalert beginSheetModalForWindow: trialsWindow modalDelegate:self didEndSelector:@selector(deleteBillWarningDidEnd:code:context:) contextInfo: nil];
}


-(void) printBill: sender
{   var idtrial=[[CPApp delegate].billingsController valueForKeyPath:"selection.id"];
    window.open('/CT/print_bill/'+idtrial+'?session='+ window.G_SESSION, 'download_window');
}

-(void) setSearchTerm: aTerm
{   if(aTerm && aTerm.length)
    {   [[CPApp delegate].trialsController setFilterPredicate: [CPPredicate predicateWithFormat:"fulltext CONTAINS %@", aTerm.toLowerCase()]];
    } else [[CPApp delegate].trialsController setFilterPredicate: nil];
}

-(void) openKontoauszuege: sender
{
    var trialsController=[CPApp delegate].trialsController;
    var idtrial=[trialsController valueForKeyPath:"selection.id"];
    var accountsController=[CPApp delegate].accountsController;
    var myreq=[CPURLRequest requestWithURL: '/CT/trial_properties/'+idtrial];
    var mpackage=[[CPURLConnection sendSynchronousRequest: myreq returningResponse: nil]  rawString];
    var o  = JSON.parse( mpackage );
    if(o['Drittmittelnummer']);
    {   var myoptions=[CPDictionary dictionaryWithObject: "1" forKey: "FSSynchronous"];
        var a=[accountsController._entity._store fetchObjectsWithKey:"account_number" equallingValue: o['Drittmittelnummer'] inEntity: accountsController._entity options: myoptions];
        if([a count]==1)
        {   a=[a objectAtIndex: 0];
            [accountsWindow setTitle: [a valueForKey:"name"]];
            [accountsController selectObjectWithPK:[a valueForKey:"id"]]
            [accountsWindow makeKeyAndOrderFront:self];
        }
    }
}
-(void) reloadAccount:sender
{
    var idaccount=[[CPApp delegate].accountsController valueForKeyPath:"selection.id"];
    var myreq=[CPURLRequest requestWithURL:"/CT/reload_account/"+idaccount+"?session="+ window.G_SESSION];
    [myreq setHTTPMethod:"GET"];
    accountsConnection=[CPURLConnection connectionWithRequest: myreq delegate:self];
    [accountsProgress startAnimation: self];
}

- (BOOL)tableView:(CPTableView)tableView shouldEditTableColumn:(CPTableColumn)column row:(int)row {
    if(tableView === propsTV){
        if([column identifier] === 'property.name')
        {   [self openAnnotation:self];
             return NO;
        }
        var frame = [tableView frameOfDataViewAtColumn:[[tableView tableColumns] indexOfObject:column] row:row];
        var scrollView=[tableView enclosingScrollView];
        frame=[tableView convertRect:frame toView: scrollView]
        frame.origin.y-=2;
        frame.size.height=30
        frame.size.width+=8;
        var combobox=[[CPComboBox alloc] initWithFrame:frame];
         combobox.tableViewEditedRowIndex = row;
         combobox.tableViewEditedColumnObj = column;
        [combobox setCompletes:YES];
        [combobox setAutoresizingMask: CPViewWidthSizable];
        [combobox setTarget:tableView];
        [combobox setAction:@selector(_commitDataViewObjectValue:)];
        var i, l=[[[CPApp delegate].autocompletionController arrangedObjects] count];
        var arr=[], objects=[[CPApp delegate].autocompletionController arrangedObjects];
        for(i=0;i<l;i++)
        {   var val= [[objects objectAtIndex:i] valueForKey:"value"];
            if(val) arr.push( val );
        }
        [combobox setContentValues:arr];
        [tableView _setObjectValueForTableColumn:column row:row forView:combobox];
        [scrollView addSubview:combobox]; // positioned:CPWindowAbove relativeTo:tableView
       [[tableView window] makeFirstResponder:combobox];
        [combobox setDelegate:self];
       return NO;
   } else if (tableView === timeTV || tableView === visitsTV || tableView === billingsTV)
   {
       var identifier= [column identifier];
       if(identifier === 'title' || identifier === 'comment' || identifier === 'amount' || identifier === 'visit_ids')
       {   return YES;
       }
       datePickerPopover =[CPPopover new];
       [datePickerPopover setDelegate:self];
       [datePickerPopover setAnimates:NO];
       [datePickerPopover setBehavior: CPPopoverBehaviorTransient];
       [datePickerPopover setAppearance: CPPopoverAppearanceMinimal];
       var myViewController=[CPViewController new];
       [datePickerPopover setContentViewController:myViewController];
       [myViewController setView:graphicalPicker];
       [graphicalPicker setLocale: [[CPLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
       graphicalPicker.tableViewEditedRowIndex = row;
       graphicalPicker.tableViewEditedColumnObj = column;
       graphicalPicker._table = tableView;
       [tableView _setObjectValueForTableColumn:column row:row forView:graphicalPicker];
       [graphicalPicker setTarget:self];
       [graphicalPicker setAction:@selector(_commitDateValue:)];
       [graphicalPicker setMinDate:[CPDate distantPast]];
       [graphicalPicker setMaxDate:[CPDate distantFuture]];
       if (tableView === visitsTV && identifier === 'visit_date') 
       {
           var lower=[[CPApp delegate].patientVisitsController valueForKeyPath:"selection.lower_margin"];
           var upper=[[CPApp delegate].patientVisitsController valueForKeyPath:"selection.upper_margin"];

           if (lower !== CPNullMarker && upper !== CPNullMarker) {
               [graphicalPicker setMinDate: [CPDate dateWithShortString:lower]];
               [graphicalPicker setMaxDate: [CPDate dateWithShortString:upper]];
           }
       }
       var frame = [tableView frameOfDataViewAtColumn:[[tableView tableColumns] indexOfObject:column] row:row];
       [datePickerPopover showRelativeToRect:frame ofView:tableView preferredEdge:nil];
       [[tableView window] makeKeyAndOrderFront:self];
       return YES;
   }
   return NO;
}

-(void) _commitDateValue:(id)sender
{
    [[sender._table window] makeKeyAndOrderFront:self];  // this has to come first (otherwise FF breaks)
    [datePickerPopover close];
    [sender._table _commitDataViewObjectValue:sender];
    [sender._table setNeedsDisplay:YES];
}

// for combobox
- (void)_controlTextDidEndEditing:(CPTextField) object
{
    [object setDelegate:nil];
    if(object) [[object target] _commitDataViewObjectValue:object]
    var win=[object window];
    [win makeFirstResponder:propsTV]
    [object removeFromSuperview];
}

- (void)controlTextDidEndEditing:(CPNotification)aNotification
{
    [self _controlTextDidEndEditing:[aNotification object]];
}
- (void) controlTextDidBlur:(CPNotification)aNotification
{
    [self _controlTextDidEndEditing:[aNotification object]];
}

-(void)cancelOperation:sender
{
    if([sender isKindOfClass:CPComboBox])
    {
        [sender setDelegate:nil];
        var win=[sender window];
        [win makeFirstResponder:propsTV]
        [sender removeFromSuperview];
    }
}

-(void) openECRF:sender
{
    var vvc= [[VisitValuesController alloc] initWithParentSize:[visitsTV frame].size];
    var visit= [[CPApp delegate].patientVisitsController selectedObject];
    [vvc setRepresentedObject:visit];

    var visitValuesPopover =[CPPopover new];
    [visitValuesPopover setDelegate:self];
    [visitValuesPopover setAnimates:NO];
    [visitValuesPopover setBehavior: CPPopoverBehaviorTransient];
    [visitValuesPopover setAppearance: CPPopoverAppearanceMinimal];
    [visitValuesPopover setContentViewController:vvc];
    [visitValuesPopover setDelegate:vvc]
    var frame = [visitsTV frameOfDataViewAtColumn:0 row:[[visitsTV selectedRowIndexes] firstIndex]];
    [visitValuesPopover showRelativeToRect:frame ofView:visitsTV preferredEdge:nil];
}

-(void) printECRF:sender
{
    var idvisit= [[CPApp delegate].patientVisitsController valueForKeyPath:"selection.id"];
    var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/new_ecrf/"+ idvisit];
    [myreq setHTTPMethod:"POST"];
    [CPURLConnection sendSynchronousRequest:myreq returningResponse: nil];
    var myurl='/CT/print_visit_ecrf/'+ idvisit +'?session='+ window.G_SESSION;
    window.open(myurl, 'download_window');
}

-(void) openOnsite:sender
{
// <!> fixme iterate over selection and open each one in a separate tab
    var trialname=[[CPApp delegate].trialsController valueForKeyPath:"selection.name"];
    window.open("/Frontend/index_deep.html?t=Onsite.gsmarkup&session="+window.G_SESSION+"&trial="+ trialname, 'onsite_window');
}

@end

@implementation CPObject(AnonymizedTrialSubjectID)
-(CPString) anonymizedTrialSubjectID
{
    var  name=[[self valueForKey:"name"] stringByPaddingToLength:1 withString:"" startingAtIndex:0];
    var  vname=[[self valueForKey:"givenname"] stringByPaddingToLength:1 withString:"" startingAtIndex:0];
    var  gebjahr=[[self valueForKey:"birthdate"] stringByPaddingToLength:4 withString:"" startingAtIndex:0];
    return [CPString stringWithFormat:"%s.%s %s", vname || '?', name || '?', gebjahr || '????'];
}
@end


@implementation OnsiteController: OperationsController
{
}
-(void) _performPostLoadInit
{
    [super _performPostLoadInit];
// select correct trial as parsed from url
    var re = new RegExp("trial=([^&#]+)");
    var m = re.exec(document.location);
    var trialName, trialObjects;
    if (m)
    {   trialName = decodeURIComponent(m[1]);
        document.title=trialName;
        var trialsController=[CPApp delegate].trialsController;
        trialObjects=[trialsController._entity._store  fetchObjectsWithKey:"name" equallingValue:trialName inEntity: trialsController._entity options:@{"FSSynchronous": 1}];
	    [trialsController setSelectedObjects:trialObjects];
    }
    if(!trialObjects || ![trialObjects count])
    {   alert("Unknown trial "+ trialName);
    }
}
@end


@implementation GSMarkupTagOperationsController:GSMarkupTagObject
+ (CPString) tagName
{
  return @"operationsController";
}

+ (Class) platformObjectClass
{
    return [OperationsController class];
}
@end

@implementation GSMarkupTagOnsiteController:GSMarkupTagOperationsController
+ (CPString) tagName
{
  return @"operationsController";
}

+ (Class) platformObjectClass
{
    return [OnsiteController class];
}
@end
