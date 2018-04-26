# aws-sdk

Package to provide simpler access to common AWS commands through the AWS SDK.

## Installation

The easiest way to install this at present is to use CommandBox.  To install with CommandBox 2.1+ simply do the following.

`box install mso-net/lucee-aws --production`

The contents of /aws-java-sdk are just the jar files from [http://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip](http://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip).  I am looking for a better way of handling this dependency but for now I'm concentrating on other tasks. 

**Important** There are currently some conflicts between the AWS Java SDK and Lucee.  At present I would advise replacing the Lucee/CommandBox version of joda-time.jar with the version within the AWS Java SDK.  If you don't do this you will see issues especially with S3.  Additionally the javax-mailer jar conflicts with the one in Lucee, in this case you can delete the one from the AWS Java SDK - I don't think I'm actually making use of that yet.

## Running unit tests

The unit tests within lucee-aws may be run using Docker.  To do so you will need to configure various environment variables with your own values - setting up this environment is not something I have scripts for at present though.

It can be built and run by executing the following commands (the `docker run` command is broken across multiple lines for easier reading).

```
docker build -t mso-net/lucee-aws .
docker run 
  -e "aws_accountid=$aws_accountid" 
  -e "aws_secretkey=$aws_secretkey" 
  -e "dynamodb_table=$dynamodb_table" 
  -e "elb_name=$elb_name" 
  -e "elb_region=$elb_region" 
  -e "lambda_method=$lambda_method" 
  -e "route53_tld=$route53_tld" 
  -e "s3_bucket=$s3_bucket" 
  -e "ses_from=$ses_from" 
  -e "ses_to=$ses_to" mso-net/lucee-aws
```


## Usage

### S3
Example for S3

```
s3 = new aws.s3();

s3.getObject( 'path/to/something.ext' );
s3.putObject( 'path/to/something.ext' , 'data:image/png;base64,data_base64_encoded_here' );
s3.deleteObject( 'path/to/something.ext' );
```

## Additional reading

- [Strayegg lucee-aws blog](http://www.strayegg.com/tag/lucee-aws/)
- [AWS SDK for Java API documentation](http://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/index.html)
