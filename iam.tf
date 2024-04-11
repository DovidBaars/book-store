data "aws_iam_policy_document" "trust_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_dynamodb_policy_document" {
  statement {
    actions = [
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:InvokeFunction",
      "lambda:UpdateFunctionConfiguration",
      "dynamodb:PutItem",  
      "dynamodb:GetItem",  
      "dynamodb:UpdateItem",  
      "dynamodb:DeleteItem"  
    ]
    effect = "Allow"
    resources = [
      "arn:aws:lambda:us-east-1:492267186702:function:*",
      "arn:aws:dynamodb:us-east-1:492267186702:table/*"
    ]
  }
}


resource "aws_iam_policy" "lambda_crud_policy" {
  name        = "lambda-crud-policy"
  description = "Allows create, delete, retrieve, and update operations on Lambda functions"
  policy      = data.aws_iam_policy_document.lambda_dynamodb_policy_document.json
}

data "aws_iam_policy_document" "apigw_invoke_lambda_policy_document" {
  statement {
    actions = ["lambda:InvokeFunction"]
    effect  = "Allow"
    resources = ["arn:aws:lambda:us-east-1:492267186702:function:*"]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_crud_policy_attachment" {
  role       = aws_iam_role.lambda_books_executor.name
  policy_arn = aws_iam_policy.lambda_crud_policy.arn
}

resource "aws_iam_policy" "apigw_invoke_lambda_policy" {
  name        = "apigw_invoke_lambda_policy"
  description = "Allows API Gateway to invoke Lambda functions"
  policy      = data.aws_iam_policy_document.apigw_invoke_lambda_policy_document.json
}

resource "aws_iam_role_policy_attachment" "apigw_invoke_lambda_policy_attachment" {
  role       = aws_iam_role.lambda_books_executor.name
  policy_arn = aws_iam_policy.apigw_invoke_lambda_policy.arn
}

resource "aws_iam_role" "lambda_books_executor" {
  name               = "lambda-books-executor"
  assume_role_policy = data.aws_iam_policy_document.trust_policy_document.json
}
