# Resource/function: IAM/role_v2

## Purpose
Generic code for generating IAM role including role policy.

## Description
Generates a IAM role based input variables assigning role to desired service and with desired policy, for use by a aws resource. NOTE: least priviledge policies shall be used.

## Terraform functions

### Data sources

### Resources
- `aws_iam_role`
    - provides a iam role
- `aws_iam_role_policy` 
    - defines and attaches the policy document to the role
- `aws_iam_policy_document`
    - generates policy input based on input variables

## Input variables
### Required
- `env`
    - environment (dev/prod)
- `permission_boundary`
    - arn of permission boundary required to generate roles. 
- `project_name`
    - name of project - used to create resource name
- `module_name`
    - name of child module - used to create resource name
- `service_to_assume_role`
    - identifier of service to use role - accepts alias given in default_identifiers variable
- `policy_statements`
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

### Optional (default values used unless specified)
- `resource_tags`
    - tags added to role - should be specified jointly with all other resources in the same module
    - default: `"tag" = "none given"`
- `description`
    - description of role
    - default: `No description given`
- `role_assumer_actions`
    - action controlled by the defined policy
    - default: `["sts:AssumeRole"]`
- `role_assumer_type`
    - type of principal to use role
    - default: `"Service"`

### Helper variable
- `default_identifiers`
    - map containing key:value pairs where key can be used as alias for connecting policy to service. 

## Output variables
- `arn`
    - `arn` of the generated role


## Example use
The below example generates a iam role as a module using the terraform scripts from `source`, giving `lambda` the permissions defined in `policy_statements`.
```sql
module "iam_role_for_lambda_test" {
    source                  = "git::https://github.com/reg-dataplatform/reg-aws-terraform-library//iam/role_v2?ref=0.44.dev"
    env                     = var.env
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

## Further work
