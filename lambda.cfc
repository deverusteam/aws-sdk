component accessors=true extends='aws' {

	property name='myClient' type='com.amazonaws.services.lambda.AWSLambdaClient' getter='true' setter='false';	

	public lambda function init(required string account, required string secret, string region='us-east-1')
	{
		super.init(argumentCollection = arguments);

		var builder = createAWSObject('services.lambda.AWSLambdaClientBuilder').standard()
			.withCredentials( getCredentialsProvider() )
			.withRegion(arguments.region);
			
		variables.myClient = builder.build();

		return this;
	}

	public any function invoke(required string method, required struct payload, string invocationType = 'RequestResponse')
	{
		var invoke_request = CreateAWSObject( 'services.lambda.model.InvokeRequest' )
			.init()
			.withFunctionName( arguments.method )
			.withInvocationType( arguments.invocationType )
			.withPayload( 
				SerializeJSON(
					arguments.payload
				)
			);

		return 
			DeserializeJSON(
				ToString( 
					getMyClient()
						.invoke( invoke_request )
						.getPayload()
						.array() 
				) 
			);
	}

}