/*
 * TODO: - Rechnungen im sinne von kontofuehrung
 *		 - datei umbenennen geht nur 1x
 *		 - show uploaddatum
 */

/////////////////////////////////////////////////////////


@import <Foundation/CPObject.j>
@import <Renaissance/Renaissance.j>
@import "DocsCalController.j"
@import "CalendarController.j"


/////////////////////////////////////////////////////////

@implementation OperationsController : CPObject
{
	id	trialsWindow;
	id	trialsTV;
	id  propsTV;
	id	addPropsWindow;
	id	addPropsTV;
	id	patsTV;
	id	patdatesTV;
	id	popover;
	id	bookingPopover;
	id	annotationPopover;
	id  annotationsTV;
	id	annotationsWindow;
	id	bookingText;
	id	bookingBox;
	id	bookingConnection;
	id	bookingOk;
	id	bookingCancel;
	id	bookingProgress;
	id	searchTerm @accessors;
    id  accountsWindow;
}


-(void) newTrial: sender
{	var newObject=[[CPApp delegate].trialsController addObject:@{"name": "New trial", "idgroup": [[CPApp delegate].groupsController valueForKeyPath:"selection.id"] } ];
	[trialsTV editColumn:0 row:[trialsTV selectedRow] withEvent:nil  select:YES];
}

- (void)deleteTrialWarningDidEnd:(CPAlert)anAlert code:(id)code context:(id)context
{	var trialsController=[CPApp delegate].trialsController;
    if(code)
	{	[trialsController removeObjectsAtArrangedObjectIndexes: [trialsController selectionIndexes] ];
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
{	var processesController=[CPApp delegate].processesController;
	[processesController insert: self];
	[[processesController selectedObject] reload];	// because of default values from the database
}
-(void) removeStep: sender
{	var processesController=[CPApp delegate].processesController;
	[processesController remove: self];
}

-(void) uploadDoku: sender
{	[UploadManager sharedUploadManager];
}
-(void) cancelAddProperty: sender
{	[popover close];
}
-(void) performAddProperty: sender
{	[popover close];
	var pcController=[CPApp delegate].propertiesCatController;
	var pController= [CPApp delegate].propertiesController;
	var selected=[pcController selectedObjects];
	var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
	var l=[selected count];
	for(var i=0; i< l; i++)
	{	var pk=[[selected objectAtIndex:i] valueForKey:"id"];
		[pController addObject:@{"idproperty": pk, "idtrial": idtrial} ];
	}
}
-(void) addProperty: sender
{
	if( !popover)
	{	 popover=[CPPopover new];
		[popover setDelegate:self];
		[popover setAnimates:YES];
		[popover setBehavior: CPPopoverBehaviorTransient ];
		[popover setAppearance: CPPopoverAppearanceMinimal];
		var myViewController=[CPViewController new];
		[popover setContentViewController: myViewController];
		[myViewController setView: [addPropsWindow contentView]];
	}
	[popover showRelativeToRect:NULL ofView: sender preferredEdge: nil];
	[[addPropsTV window] makeFirstResponder: addPropsTV]	
}
-(void) removeProperty: sender
{	var pController=[CPApp delegate].propertiesController;
	[pController remove: self];
}
-(void) openAnnotation: sender
{	if( !annotationPopover)
	{	 annotationPopover =[CPPopover new];
		[annotationPopover setDelegate:self];
		[annotationPopover setAnimates:YES];
		[annotationPopover setBehavior: CPPopoverBehaviorTransient ];
		[annotationPopover setAppearance: CPPopoverAppearanceMinimal];
		var myViewController=[CPViewController new];
		[annotationPopover setContentViewController: myViewController];
		[myViewController setView: [annotationsWindow contentView]];
	}
	var sel=[[propsTV selectedRowIndexes] firstIndex];
	var rect= [propsTV _rectOfRow: sel checkRange:NO];
	[annotationPopover showRelativeToRect:rect ofView: propsTV preferredEdge: nil];
}
-(void) addAnnotation: sender
{	var trialPropAnnotationsController=[CPApp delegate].trialPropAnnotationsController;
	[trialPropAnnotationsController addObject:@{"ldap": window.G_USERNAME} ];

}
-(void) removeAnnotation: sender
{	var trialPropAnnotationsController=[CPApp delegate].trialPropAnnotationsController;
	[trialPropAnnotationsController remove: self];
}
-(void) removeCatProperty: sender
{	var pController=[CPApp delegate].propertiesCatController;
	[pController remove: self];
}
-(void) addCatProperty: sender
{	var pController=[CPApp delegate].propertiesCatController;
	[pController insert: self];
	[addPropsTV editColumn:0 row:[addPropsTV selectedRow] withEvent:nil  select:YES];
}


-(void) doDownload: sender
{	var trialsController=[CPApp delegate].trialsController;
	var idtrial=[trialsController valueForKeyPath:"selection.id"];
	var dokuController=[CPApp delegate].dokusController;
	var iddoku=[dokuController valueForKeyPath:"selection.name"];
	window.open("/CT/download/"+idtrial+"/"+iddoku , 'download_window');
}

- (void)deleteDocWarningDidEnd:(CPAlert)anAlert code:(id)code context:(id)context
{	var dokusController=[CPApp delegate].dokusController;
    if(code)
	{	[dokusController removeObjectsAtArrangedObjectIndexes: [dokusController selectionIndexes] ];
	}
}
-(void) deleteDoku: sender
{	var myalert = [CPAlert new];
	[myalert setMessageText: "Are you sure you want to delete this document?"];
	[myalert addButtonWithTitle:"Cancel"];
	[myalert addButtonWithTitle:"Delete"];
	[myalert beginSheetModalForWindow: trialsWindow modalDelegate:self didEndSelector:@selector(deleteDocWarningDidEnd:code:context:) contextInfo: nil];
}

-(void) makeAllFields: sender
{	var trialsController=[CPApp delegate].trialsController;
	var idtrial=[trialsController valueForKeyPath:"selection.id"];
	var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/make_properties/"+idtrial];
	[CPURLConnection sendSynchronousRequest: myreq returningResponse: nil];
// fixme:  use [[CPApp delegate].SOMECONTROLLER reload];
	[[trialsController selectedObject] willChangeValueForKey:"props"];
	 [trialsController._entity._relations makeObjectsPerformSelector:@selector(_invalidateCache)];
	[[trialsController selectedObject] didChangeValueForKey:"props"];
}


-(void) sendEmail: sender
{	var pController=[CPApp delegate].propertiesController;
	var myURL=[pController valueForKeyPath:"selection.value"];
	window.location='mailto:'+myURL;

}

-(void) openURL: sender
{	var pController=[CPApp delegate].propertiesController;
	var myURL=[pController valueForKeyPath:"selection.value"];
	window.open(myURL , 'open_urlwindow');
}


-(void) deletePatient: sender
{	var pController=[CPApp delegate].patientsController;
	[pController remove: self];
}
-(void) addPatient: sender
{	var trialsController=[CPApp delegate].trialsController;
	var idtrial=[trialsController valueForKeyPath:"selection.id"];
	var patientsController=[CPApp delegate].patientsController;
	[patientsController insert: self];
    [patientsController rearrangeObjects];
	var idpatient=[patientsController valueForKeyPath: "selection.id"];
	var myreq=[CPURLRequest requestWithURL: BaseURL+"CT/new_patient/"+idpatient];
	[[CPURLConnection sendSynchronousRequest: myreq returningResponse: nil] rawString];

    [[CPApp delegate].patientVisitsController reload];
}

-(void) connection: someConnection didReceiveData: data
{
	[bookingProgress stopAnimation: self];
	[bookingPopover close];
	if(data === '0')
	{	var pvController=[CPApp delegate].patientVisitsController;
		[someConnection._bookingObject setValue: someConnection._bookingDate forKey:"visit_date"];
		someConnection._bookingDate=nil;
        someConnection._bookingObject=nil;
	} else if(data === 'NOK')
	{	alert("termin war schon vergeben. nochmal buchen");		// <!> fixme
	}
	// reload dc-termine to remove the allocated entry
	var pvController=[CPApp delegate].patientVisitsController;
// fixme:  use [[CPApp delegate].SOMECONTROLLER reload];
	[[pvController selectedObject] willChangeValueForKey:"date_proposals"];
	 [pvController._entity._relations makeObjectsPerformSelector:@selector(_invalidateCache)];
	[[pvController selectedObject] didChangeValueForKey:"date_proposals"];
}

-(void) doBookInDocscal: sender
{	var patController=[CPApp delegate].patientsController;
	var visitDatesController=[CPApp delegate].visitDatesController;

	var piz=[[patController selectedObject] valueForKeyPath:"piz"];
	if(!piz)
	{	alert("no piz given");	// <!> fixme
		return;
	}
	var dcid=[[visitDatesController selectedObject] valueForKey:"dcid"];
	var text=[bookingText stringValue];
	var idvisit= [[[CPApp delegate].patientVisitsController selectedObject] valueForKey:"idvisit"];
	var myreq=[CPURLRequest requestWithURL:"/CT/booking/"+piz+"/"+dcid+"/"+ idvisit ];
	[myreq setHTTPMethod:"POST"];
	[myreq setHTTPBody: text];
	 bookingConnection=[CPURLConnection connectionWithRequest: myreq delegate: self];
	 bookingConnection._bookingDate=[[visitDatesController selectedObject] valueForKey:"caldate"];
     bookingConnection._bookingObject= [[CPApp delegate].patientVisitsController selectedObject];
	[bookingProgress startAnimation: self];
	[bookingOk setEnabled: NO];
	[bookingCancel setEnabled: NO];
}

-(void) bookInDocscal: sender
{
// <!> fixme: alert if no PIZ is given
	if (!bookingPopover)
	{	 bookingPopover=[CPPopover new];
		[bookingPopover setDelegate:self];
		[bookingPopover setAnimates:YES];
		[bookingPopover setBehavior: CPPopoverBehaviorTransient ];
		[bookingPopover setAppearance: CPPopoverAppearanceMinimal];
		 var myViewController=[CPViewController new];
		[myViewController setView: bookingBox];
		[bookingPopover setContentViewController: myViewController];
	}
	var sel=[[patdatesTV selectedRowIndexes] firstIndex];
	var rect= [patdatesTV _rectOfRow: sel checkRange:NO];
	var mytext=[[[CPApp delegate].trialsController selectedObject] valueForKey:"name"]+" "+[[[CPApp delegate].patientVisitsController selectedObject] valueForKeyPath:"visit.name"]
	[bookingText setStringValue: mytext];
	[bookingOk setEnabled: YES];
	[bookingCancel setEnabled: YES];
	[bookingPopover showRelativeToRect:rect ofView: patdatesTV preferredEdge: nil];
	[[bookingText window] makeFirstResponder: bookingText]	

}

-(void) recalcVisits: sender
{	var pController=[CPApp delegate].patientsController;
// fixme:  use [[CPApp delegate].SOMECONTROLLER reload];
	[[pController selectedObject] willChangeValueForKey:"visits"];
	 [pController._entity._relations  makeObjectsPerformSelector:@selector(_invalidateCache)];
	[[pController selectedObject] didChangeValueForKey:"visits"];
}

-(void) insertVisit: sender
{	[[CPApp delegate].patientVisitsController insert: sender];
}

-(void) removeVisit: sender
{	[[CPApp delegate].patientVisitsController remove: sender];
}

-(void) runConfig: sender
{
	[CPBundle loadRessourceNamed: "AdminTrial.gsmarkup" owner: [CPApp delegate] ];
}

-(void) printDocumentNamed: (CPString) aName
{	var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
	window.open('/CT/pdfstamper/'+idtrial+'/'+aName+'?session='+ window.G_SESSION, 'download_window');

}

-(void) printDrittmittelanzeige: sender
{	[self printDocumentNamed:"drittmittelanzeige"];
}
-(void) printAnschreibenVertrag: sender
{	[self printDocumentNamed:"anschreibenvertrag"];
}

-(void)downloadExcel: sender
{	document.location='/CT/download_list?session='+ window.G_SESSION+'&excel=1';
}


-(void)downloadPatients: sender
{	var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
	document.location='/CT/download_patients/'+idtrial+'?session='+ window.G_SESSION;
}
-(void)createTodoList: sender
{	var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
	document.location='/CT/todolist_trial/'+idtrial+'?session='+ window.G_SESSION;
}
-(void)downloadKoKa: sender
{	var idtrial=[[CPApp delegate].trialsController valueForKeyPath:"selection.id"];
	document.location='/CT/download_koka/'+idtrial+'?session='+ window.G_SESSION;
}

-(void)createTodoListGlobal: sender
{	document.location='/CT/todolist?session='+ window.G_SESSION;
}

-(void) runDCV: sender
{	var patController=[CPApp delegate].patientsController;
	var dcv=[[DocsCalController alloc] initWithPIZ:[[patController selectedObject] valueForKeyPath:"piz"]];
}

-(void) runCalendar: sender
{	[CalendarController new]
}


-(void) reloadBillings: sender
{	var trialsController=[CPApp delegate].trialsController;
// fixme:  use [[CPApp delegate].SOMECONTROLLER reload];
	[[trialsController selectedObject] willChangeValueForKey:"billings"];
	 [trialsController._entity._relations makeObjectsPerformSelector:@selector(_invalidateCache)];
	[[trialsController selectedObject] didChangeValueForKey:"billings"];
}

-(void) addBill: sender
{	var billingsController=[CPApp delegate].billingsController;
	[billingsController insert: sender];
	[[billingsController selectedObject] reload];
}
-(void) removeBill: sender
{	var billingsController=[CPApp delegate].billingsController;
	[billingsController remove: sender];
}



-(void) createBill: sender
{	var trialsController=[CPApp delegate].trialsController;
	var idtrial=[trialsController valueForKeyPath:"selection.id"];
	[[CPRunLoop currentRunLoop] performSelector:@selector(reloadBillings:) target:self argument: self order:0 modes:[CPDefaultRunLoopMode]];
	window.open('/CT/print_bill/'+idtrial+'?session='+ window.G_SESSION, 'download_window');
}
-(void) setSearchTerm: aTerm
{
searchTerm=aTerm
	if(aTerm && aTerm.length)
	{	[[CPApp delegate].trialsController setFilterPredicate: [CPPredicate predicateWithFormat:"fulltext CONTAINS %@", aTerm.toLowerCase()]];
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

