package test

import (
	"github.com/gruntwork-io/terratest/modules/opa"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

func TestOPA(t *testing.T) {
	t.Parallel()

	// Test the Terraform code in the examples/opa folder
	tfOpts := &terraform.Options{
		TerraformDir: "../examples/opa",
	}

	// Run the Terraform code against the OPA policy in enforce_source.rego
	opaOpts := &opa.EvalOptions{
		RulePath: "../examples/opa/enforce_tagging.rego",
		FailMode: opa.FailUndefined,
	}

	// Fail the test if the OPA policy fails
	terraform.OPAEval(t, tfOpts, opaOpts, "data.terraform.allow")
}