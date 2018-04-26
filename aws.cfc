component accessors=true {

	property name='credentials' type='com.amazonaws.auth.BasicAWSCredentials' getter='false' setter='false';
	property name='credentialsProvider' type='com.amazonaws.auth.AWSStaticCredentialsProvider' getter='false' setter='false';
	property name='regions' type='com.amazonaws.regions.Regions' getter='false' setter='false';
	property name='region' type='string' getter='false' setter='false';

	public aws function init(required string account, required string secret, string region='us-east-1')
	{
		variables.credentials = createAWSObject('auth.BasicAWSCredentials').init(arguments.account, arguments.secret);
		variables.credentialsProvider = createAWSObject('auth.AWSStaticCredentialsProvider').init(variables.credentials);
		variables.regions = createAWSObject('regions.Regions');
		variables.region = arguments.region;

		return this;
	}

	private function createAWSObject(required string name)
	{
		return CreateObject(
			'java',
			'com.amazonaws.' & arguments.name,
			[
				'aws-java-sdk-1.11.155/aspectjrt-1.8.2.jar',
				'aws-java-sdk-1.11.155/aspectjweaver.jar',
				'aws-java-sdk-1.11.155/aws-java-sdk-1.11.155.jar',
				'aws-java-sdk-1.11.155/commons-codec-1.9.jar',
				'aws-java-sdk-1.11.155/commons-logging-1.1.3.jar',
				'aws-java-sdk-1.11.155/freemarker-2.3.9.jar',
				'aws-java-sdk-1.11.155/httpclient-4.5.2.jar',
				'aws-java-sdk-1.11.155/httpcore-4.4.4.jar',
				'aws-java-sdk-1.11.155/ion-java-1.0.2.jar',
				'aws-java-sdk-1.11.155/jackson-annotations-2.6.0.jar',
				'aws-java-sdk-1.11.155/jackson-core-2.6.6.jar',
				'aws-java-sdk-1.11.155/jackson-databind-2.6.6.jar',
				'aws-java-sdk-1.11.155/jackson-dataformat-cbor-2.6.6.jar',
				'aws-java-sdk-1.11.155/javax.mail-api-1.4.6.jar',
				'aws-java-sdk-1.11.155/jmespath-java-1.11.155.jar',
				'aws-java-sdk-1.11.155/joda-time-2.8.1.jar',
				// 'aws-java-sdk-1.11.155/json-path-2.2.0.jar',
				// 'aws-java-sdk-1.11.155/slf4j-api-1.7.16.jar',
				'aws-java-sdk-1.11.155/spring-beans-3.0.7.RELEASE.jar',
				'aws-java-sdk-1.11.155/spring-context-3.0.7.RELEASE.jar',
				'aws-java-sdk-1.11.155/spring-core-3.0.7.RELEASE.jar',
				'aws-java-sdk-1.11.155/spring-test-3.0.7.RELEASE.jar'
			]
		);
	}

	private function getCredentials()
	{
		return variables.credentials;
	}

	private function getCredentialsProvider()
	{
		return variables.credentialsProvider;
	}

	private function getRegions()
	{
		return variables.regions;
	}

	public function getRegion()
	{
		return variables.region;
	}

	private any function getMyClient()
	{
		return variables.myClient;
	}

	public function setRegion(required string region)
	{
		getMyClient().configureRegion( getRegion(arguments.region) );

		return this;
	}

}