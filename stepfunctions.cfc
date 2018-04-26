component accessors=true extends='aws' {

	property name='myClient' type='com.amazonaws.services.stepfunctions.AWSStepFunctionsClient' getter=false setter=false;		

	public stepfunctions function init(required string account, required string secret, string region = 'us-east-1')
	{

		super.init(argumentCollection = arguments);

		variables.myClient = CreateAWSObject( 'services.stepfunctions.AWSStepFunctionsClient' ).init( getCredentials() );

		if ( arguments.keyExists('region') ) 
			setRegion( region = arguments.region );

		return this;
	}

	public any function startExecution(required string stateMachineARN, string name, struct input={})
	{
		var startExecutionRequest = CreateAWSObject( 'services.stepfunctions.model.StartExecutionRequest' ).init()			
			.withStateMachineARN( arguments.stateMachineARN )
			.withInput( serializeJSON(arguments.input) );

		if ( arguments.keyExists('name') )
			startExecutionRequest.setName(arguments.name);

		return getMyClient().startExecution(startExecutionRequest);
	}
}