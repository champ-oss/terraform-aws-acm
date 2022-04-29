package test

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/acm"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"strings"
	"testing"
)

// TestExamplesComplete tests a typical deployment of this module
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/complete",
		EnvVars:      map[string]string{},
		Vars:         map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	logger.Log(t, "Checking if the certificate is validated and issued")
	arn := terraform.Output(t, terraformOptions, "arn")
	region := terraform.Output(t, terraformOptions, "region")
	cert := getCertificate(arn, region)
	assert.Equal(t, "ISSUED", *cert.Certificate.Status)
	assert.Equal(t, "SUCCESS", *cert.Certificate.DomainValidationOptions[0].ValidationStatus)

	logger.Log(t, "Checking if the certificate is wildcard")
	assert.True(t, strings.HasPrefix(*cert.Certificate.DomainName, "*."))
}

// getCertificate logs in to AWS and gets the details of an ACM certificate
func getCertificate(arn string, region string) *acm.DescribeCertificateOutput {
	sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	})
	if err != nil {
		panic(err)
	}

	svc := acm.New(sess, aws.NewConfig().WithRegion(region))
	cert, err := svc.DescribeCertificate(&acm.DescribeCertificateInput{
		CertificateArn: aws.String(arn),
	})
	if err != nil {
		panic(err)
	}
	return cert
}
