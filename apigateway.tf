resource "aws_api_gateway_rest_api" "book_store_rest_api" {
  name   = "book_store"
}

resource "aws_api_gateway_resource" "book_store_rest_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.book_store_rest_api.id
  parent_id   = aws_api_gateway_rest_api.book_store_rest_api.root_resource_id
  path_part   = "book_store"
}

resource "aws_api_gateway_resource" "book_isbn_resource" {
  rest_api_id = aws_api_gateway_rest_api.book_store_rest_api.id
  parent_id   = aws_api_gateway_resource.book_store_rest_api_resource.id
  path_part   = "{isbn}"
}

// Create

resource "aws_api_gateway_method" "create_book_rest_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.book_store_rest_api.id
  resource_id   = aws_api_gateway_resource.book_store_rest_api_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.book_store_authorizer.id
}

resource "aws_api_gateway_integration" "create_book_rest_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.book_store_rest_api.id
  resource_id             = aws_api_gateway_resource.book_store_rest_api_resource.id
  http_method             = aws_api_gateway_method.create_book_rest_api_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.create_book_function.invoke_arn
}

resource "aws_lambda_permission" "create_book_rest_api_integration" {
  statement_id  = "AllowCreateBookInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_book_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.book_store_rest_api.execution_arn}/*/POST/book_store"
}

// Delete

resource "aws_api_gateway_method" "delete_book_rest_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.book_store_rest_api.id
  resource_id   = aws_api_gateway_resource.book_isbn_resource.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.book_store_authorizer.id
}

resource "aws_api_gateway_integration" "delete_book_rest_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.book_store_rest_api.id
  resource_id             = aws_api_gateway_resource.book_isbn_resource.id
  http_method             = aws_api_gateway_method.delete_book_rest_api_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.delete_book_function.invoke_arn
}

resource "aws_lambda_permission" "delete_book_rest_api_integration" {
  statement_id  = "AllowDeleteBookInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_book_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.book_store_rest_api.execution_arn}/*/DELETE/book_store"
}

// Retrieve

resource "aws_api_gateway_method" "retrieve_book_rest_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.book_store_rest_api.id
  resource_id   = aws_api_gateway_resource.book_isbn_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.book_store_authorizer.id
}

resource "aws_api_gateway_integration" "retrieve_book_rest_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.book_store_rest_api.id
  resource_id             = aws_api_gateway_resource.book_isbn_resource.id
  http_method             = aws_api_gateway_method.retrieve_book_rest_api_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.retrieve_book_function.invoke_arn
}

resource "aws_lambda_permission" "retrieve_book_rest_api_integration" {
  statement_id  = "AllowRetrieveBookInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.retrieve_book_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.book_store_rest_api.execution_arn}/*/GET/book_store"
}

// Update

resource "aws_api_gateway_method" "update_book_rest_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.book_store_rest_api.id
  resource_id   = aws_api_gateway_resource.book_isbn_resource.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.book_store_authorizer.id
}

resource "aws_api_gateway_integration" "update_book_rest_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.book_store_rest_api.id
  resource_id             = aws_api_gateway_resource.book_isbn_resource.id
  http_method             = aws_api_gateway_method.update_book_rest_api_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.update_book_function.invoke_arn
}

resource "aws_lambda_permission" "update_book_rest_api_integration" {
  statement_id  = "AllowUpdateBookInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_book_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.book_store_rest_api.execution_arn}/*/UPDATE/book_store"
}

resource "aws_api_gateway_stage" "staging" {
  stage_name    = "staging"
  rest_api_id   = aws_api_gateway_rest_api.book_store_rest_api.id
  deployment_id = aws_api_gateway_deployment.book_store_rest_api_deployment.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_log_group.arn
    format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.resourcePath $context.protocol\" $context.status $context.responseLength $context.requestId"
  }
}

resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name = "/aws/apigateway/${aws_api_gateway_rest_api.book_store_rest_api.name}"
  retention_in_days = 14
}


resource "aws_api_gateway_deployment" "book_store_rest_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.create_book_rest_api_integration,
    aws_api_gateway_integration.delete_book_rest_api_integration,
    aws_api_gateway_integration.retrieve_book_rest_api_integration,
    aws_api_gateway_integration.update_book_rest_api_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.book_store_rest_api.id
  stage_name  = "staging"
}

resource "aws_api_gateway_account" "account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_logs.arn
}