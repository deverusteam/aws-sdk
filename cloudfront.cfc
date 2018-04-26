component accessors=true extends='aws' {

	property name='myClient' type='com.amazonaws.services.s3.AmazonS3Client' getter=false setter=false;
	property name='bucketACL' type='com.amazonaws.services.s3.model.AccessControlList' getter=false setter=false;
	property name='bucket' type='string' getter=true setter=false;
	property name='basepath' type='string' getter=true setter=false;
	property name='keyPairID' type='string' getter=true setter=false;
	property name='privateKeyFile' type='string' getting=true setter=true;

	public cloudfront function init(required string bucket, string basepath = '') {

		super.init(argumentCollection=arguments);
		keyPairID = 'APKAIYEK64AX572IE2UQ';
		privateKeyFile = ExpandPath( '/keys/pk-APKAIYEK64AX572IE2UQ.pem');

		variables.myClient = CreateAWSObject( 'services.cloudfront.AmazonCloudFrontClientBuilder' ).defaultClient();

		variables.bucket = arguments.bucket;
		variables.basepath = arguments.basepath;

		return this;
	}

	public string function getKeyFromPath(required string key) {
		return variables.basepath&arguments.key;
	}

	/**
	* @hint Returns a new URL signer. This is used for generating presigned URLs
	* @output false
	*/
	public any function getCloudFrontUrlSigner(){
		if( !StructKeyExists( variables, 'URLSigner' ) ){
			variables.URLSigner = CreateAWSObject( 'services.cloudfront.CloudFrontUrlSigner' );
		}
		return variables.URLSigner;
	}

	/**
	* @hint Provide a presigned expiring URL for a request.
	* @output false
	* @key The S3 key for which you want to request a URL
	* @expiration The date and time that you want the URL to expire. The default is 15 minutes, which matches the default value for the AWS JAVA SDK
	*/
	public string function generatePresignedUrl(
		required string key,
		date expiration = DateAdd( 'm', 15, Now() )
	) {

		// Method signature:
		// String resourceUrlOrPath,
		// String keyPairId,
		// PrivateKey privateKey,
		// Date dateLessThan

		return getCloudFrontUrlSigner().getSignedURLWithCannedPolicy(
			CreateAWSObject( 'services.cloudfront.util.SignerUtils$Protocol' ).https,
			'files.stage.screening.services',
			CreateObject( 'java', 'java.io.File' ).init( privateKeyFile ),
			ARGUMENTS.key,
			keyPairID,
			javacast( 'java.util.Date', LSParseDateTime( date: ARGUMENTS.Expiration, timezone: 'UTC' ) )
		).toString();

	}
}