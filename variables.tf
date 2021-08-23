# Required variables:
variable "env" {
  description = "Environment (dev/prod)"
  type        = string
}

variable "permission_boundary" {
  type = string
}

variable "project_name" {
  description = "Name of project - used to create resource name"
  type        = string
}

variable "module_name" {
  description = "Name of child module - used to create resource name"
  type        = string
}

variable "service_to_assume_role" {
  description = "identifier of service to use role - accepts alias given in default_identifiers variable"
  type      = string
}

variable "policy_statements" {
  description = "list of maps including statements - see README for details" 
}


#Optional variables - default values used unless others specified:

variable "resource_tags" {
  description = "Defaults to no tags. If needed, env vars can be given in parent module variables.tf, and assigned in child module call"
  type        = map(string)
  default = {
    "tag" = "none given"
  }
}

variable "description" {
  description = "Description of what lambda function does"
  type        = string
  default     = "No description given"
}

variable "role_assumer_actions" {
  description = "action controlled by the defined policy - defaults to sts:AssumeRole"
  type      = list(string)
  default   = ["sts:AssumeRole"]  
}

variable "role_assumer_type" {
  description = "type of principal to use role - defaults to Service"
  type      = string
  default   = "Service"
}

# Helper variable used to generate aliases for service identifiers

variable "default_identifiers" {
  description = "map of default identifiers available to use by specifying alias (key) in service_to_assume_role variable"
  type = map(string)
  default = {
    apigateway          = "apigateway.amazonaws.com"
    athena              = "athena.amazonaws.com"
    billingconsole      = "billingconsole.amazonaws.com"
    cost_explorer       = "ce.amazonaws.com"
    cloudtrail          = "cloudtrail.amazonaws.com"
    dynamodb            = "dynamodb.amazonaws.com"
    ec2                 = "ec2.amazonaws.com"
    ecr                 = "ecr.amazonaws.com"
    ecs                 = "ecs.amazonaws.com"
    cloudwatch_events   = "events.amazonaws.com"
    glacier             = "glacier.amazonaws.com"
    glue                = "glue.amazonaws.com"
    iam                 = "iam.amazonaws.com"
    kms                 = "kms.amazonaws.com"
    lambda              = "lambda.amazonaws.com"
    cloudwatch_logs     = "logs.amazonaws.com"
    rds                 = "rds.amazonaws.com"
    redshift            = "redshift.amazonaws.com"
    s3                  = "s3.amazonaws.com"
    sagemaker           = "sagemaker.amazonaws.com"
    secretsmanager      = "secretsmanager.amazonaws.com"
    ses                 = "ses.amazonaws.com"
    sns                 = "sns.amazonaws.com"
    sqs                 = "sqs.amazonaws.com"
    ssm                 = "ssm.amazonaws.com"
    step_function       = "states.amazonaws.com"
  }
}