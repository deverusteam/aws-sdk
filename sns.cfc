component accessors=true extends='aws' {

	property name='myClient' type='com.amazonaws.services.sns.AmazonSNSClient' getter='false' setter='false';		

	public sns function init(required string account, required string secret, string region='us-east-1')
	{

		super.init(argumentCollection = arguments);

		var builder = createAWSObject('services.sns.AmazonSNSClientBuilder').standard()
			.withCredentials( getCredentialsProvider() )
			.withRegion(arguments.region);
			
		variables.myClient = builder.build();

		return this;
	}

	public any function publish(required string message, string topicArn, string phoneNumber)
	{
		var publishRequest = CreateAWSObject( 'services.sns.model.PublishRequest' )
			.init()
			.withMessage(arguments.message);

		if ( !isNull(arguments.topicArn) )
			publishRequest.setTopicArn(arguments.topicArn);

		if ( !isNull(arguments.phoneNumber) )
			publishRequest.setPhoneNumber( "+1" & reReplaceNoCase(trim(arguments.phoneNumber), '[^0-9]', '', 'all') );

		return getMyClient().publish(publishRequest);
	}
}