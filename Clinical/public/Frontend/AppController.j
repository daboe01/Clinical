/*
 * Cappuccino frontend for augclinical
 *
 * Created by daboe01 on Sep, 2013.
 * Copyright 2013, All rights reserved.
 *
 *
 */

/////////////////////////////////////////////////////////

HostURL=""
BaseURL=HostURL+"/";

/////////////////////////////////////////////////////////

@import <Foundation/CPObject.j>
@import <Renaissance/Renaissance.j>
@import "OperationsController.j"
@import "UploadManager.j"
@import "TableViewControl.j"
@import "CalendarController.j"


@implementation SessionStore : FSStore 


-(CPURLRequest) requestForAddressingObjectsWithKey: aKey equallingValue: (id) someval inEntity:(FSEntity) someEntity
{	var request = [CPURLRequest requestWithURL: [self baseURL]+"/"+[someEntity name]+"/"+aKey+"/"+someval+"?session="+ window.G_SESSION];
	return request;
}
-(CPURLRequest) requestForFuzzilyAddressingObjectsWithKey: aKey equallingValue: (id) someval inEntity:(FSEntity) someEntity
{	var request = [CPURLRequest requestWithURL: [self baseURL]+"/"+[someEntity name]+"/"+aKey+"/like/"+someval+"?session="+ window.G_SESSION];
	return request;
}
-(CPURLRequest) requestForAddressingAllObjectsInEntity:(FSEntity) someEntity
{	return [CPURLRequest requestWithURL: [self baseURL]+"/"+[someEntity name]+"?session="+ window.G_SESSION ];
}


@end

@implementation CPNull(length)
-(unsigned) length {return 0;}
@end

@implementation AppController : CPObject
{	id	store @accessors;	

	id	trialsController;
	id	propertiesController;
	id	processesController;
	id	dokusController;
	id	personnelController;
	id	trialpersonnelController;
	id	groupsController;
	id	rolesController;
	id	statesController;
	id	doctagsController;
	id	propertiesCatController;
	id	groupassignmentController;
	id	personnelPropCatController;
	id	personnelPropController;
	id	patientsController;
	id	patientVisitsController;
	id	visitsController;
	id	visitDatesController;
	id	statusController;
	id	tagesinfosController;
	id  trialPropAnnotationsController;
	id	billingsController;
	id	accountsController;
	id	transactionsController;

	id mainController @accessors;
}

-(CPString) uploadURL
{
	return HostURL+"/upload/"+[trialsController valueForKeyPath: "selection.id"];
}

// this is to make the currently GUI controller globally available (to get access to e.g. scale)
- mainController
{	return [[CPApp mainWindow] delegate] || mainController;
}

- (void) applicationDidFinishLaunching:(CPNotification)aNotification
{	store=[[SessionStore alloc] initWithBaseURL: HostURL+"/DBI"];
	[CPBundle loadRessourceNamed: "model.gsmarkup" owner:self];
	var mainFile="Operations.gsmarkup";
	var re = new RegExp("t=([^&#]+)");
	var m = re.exec(document.location);
	if(m) mainFile=m[1];
	[CPBundle loadRessourceNamed: mainFile owner: self ];
}

-(void) delete:sender
{	[[[CPApp keyWindow] delegate] delete:sender];
}

-(void) unsetReferenceVisit:sender
{	[[visitsController selectedObject] setValue: [CPNull null] forKey:"idreference_visit"];
}
-(void) insertTransaction: sender
{	[transactionsController insert:sender];
   [[transactionsController selectedObject] reload]
}
-(void) deleteTransaction: sender
{	[transactionsController remove:sender];
}
@end

