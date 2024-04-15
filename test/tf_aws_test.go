package test

import (
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/iam"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/hashicorp/hcl/v2/hclsimple"
)

type Config struct {
	Region        string `hcl:"region"`
	BookTableName string `hcl:"book_table_name"`
}

func getAWSRegion() (string, error) {
	var config Config
	err := hclsimple.DecodeFile("./vars.hcl", nil, &config)
	if err != nil {
		return "", err
	}
	return config.Region, nil
}

func TestTerraformAwsInfrastructure(t *testing.T) {
	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../",
	}

	terraform.InitAndApply(t, terraformOptions)

	defer terraform.Destroy(t, terraformOptions)

	// Validate your infrastructure works as expected
	// e.g., make API calls, check the status of AWS resources, etc.
	awsRegion, err := getAWSRegion()
	if err != nil {
		t.Fatal(err)
	}
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(awsRegion),
	})
	if err != nil {
		t.Fatalf("Failed to create session: %v", err)
	}

	iamSvc := iam.New(sess)
	_, err = iamSvc.ListUsers(&iam.ListUsersInput{})
	if err != nil {
		t.Fatalf("Failed to list IAM users: %v", err)
	}
}
