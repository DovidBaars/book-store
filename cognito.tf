resource "aws_cognito_user_pool" "book_store_user_pool" {
  name = "book_store_user_pool"
}

resource "aws_api_gateway_authorizer" "book_store_authorizer" {
  name          = "book_store_authorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.book_store_rest_api.id
  provider_arns = [aws_cognito_user_pool.book_store_user_pool.arn]
}