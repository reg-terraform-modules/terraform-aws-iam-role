# iam-role

This module generates an IAM role, which can be attached to various services in AWS. 

## Module description
Generates an IAM role by creating a role policy document and a role assumer document, and attaching these to a role. 

## Requires
For all required inputs, see details on Terraform Cloud. Below are inputs that require further description

- permission_boundary
    - The REG AWS account has a permission boundary connected to it. The arn of this permission boundary must be given as input to the module.
- service_to_assume_role
    - the role assumer document needs to know which service to be allowed to attach the role. This is passed in as service_to_assume_role, either:
        - using the service identifier: "apigateway.amazonaws.com"
        - or using an alias: "apigateway"
    - a full list of available aliases is given in the `variables.tf` file of the module itself. This is also where new services may be added. 
- policy_statements
    - list of maps including statements. each map in list creates a statement in policy.
    - syntax:
```
    [
        {
            sid                 = string - optional - accepts letters and number (no special characters) - defaults to ""
            effect              = string - optional - accepts "Allow"|"Deny" - defaults to "Allow"
            actions             = list(string) - required - multiple values accepted
            resources           = list(string) - required - accepts resource arn - multiple values accepted
            condition_test      = string - optional
            condition_variable  = string - optional
            condition_values    = list(string) - optional - multiple values accepted
        },
        {
            new map in list - included in same policy
        }

    ]
```
    - an example is given below.

## Usage

The below example generates a iam role as a module using the terraform scripts from `source`, giving `lambda` the permissions defined in `policy_statements`.
```sql
module "iam_role_for_lambda_test" {
    source                  = "app.terraform.io/renovasjonsetaten/iam-role/aws"
    version                 = "0.0.2"
    permission_boundary     = local.permission_boundary
    project_name            = var.project_name
    module_name             = "iam_role_for_lambda_test"
    service_to_assume_role  = "lambda"
    resource_tags           = local.resource_tags
    policy_statements       = [
            {
                sid = "AllowGetPutInS3Key"
                actions = ["s3:GetObject",
                           "s3:PutObject"]
                resources = [join("",[local.bucket_arn,"/sources/opening_hours/raw/facts/version=1/*"])]
            },
            {
                sid = "AllowInteractionWithCloudwatchLogs"
                actions = ["logs:CreateLogGroup",
                           "logs:CreateLogStream",
                           "logs:PutLogEvents"]
                resources = ["*"]
            },
            {
                sid = "AllowGetFromSystemsManagerParameterStore"
                actions = ["ssm:Get*"]
                resources = ["*"]
            }
        ]
}
```