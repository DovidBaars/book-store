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

resource "aws_iam_role" "lambda_books_executor" {
  name               = "lambda-books-executor"
  assume_role_policy = data.aws_iam_policy_document.trust_policy_document.json
}
