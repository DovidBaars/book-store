resource "aws_lambda_function" "create_book_function" {
    function_name = "createBook"
    role          = aws_iam_role.lambda_books_executor.arn
    handler       = "index.handler"
    runtime       = "nodejs20.x"
    filename      = "./api/dist/createBook/createBook.zip"
    environment {
        variables = {
        BOOK_TABLE = var.book_table_name
        }
    }
}

resource "aws_lambda_function" "retrieve_book_function" {
    function_name = "retrieveBook"
    role          = aws_iam_role.lambda_books_executor.arn
    handler       = "index.handler"
    runtime       = "nodejs20.x"
    filename      = "./api/dist/retrieveBook/retrieveBook.zip"
    environment {
        variables = {
        BOOK_TABLE = var.book_table_name
        }
    }
}

resource "aws_lambda_function" "update_book_function" {
    function_name = "updateBook"
    role          = aws_iam_role.lambda_books_executor.arn
    handler       = "index.handler"
    runtime       = "nodejs20.x"
    filename      = "./api/dist/updateBook/updateBook.zip"
    environment {
        variables = {
        BOOK_TABLE = var.book_table_name
        }
    }
}

resource "aws_lambda_function" "delete_book_function" {
    function_name = "deleteBook"
    role          = aws_iam_role.lambda_books_executor.arn
    handler       = "index.handler"
    runtime       = "nodejs20.x"
    filename      = "./api/dist/deleteBook/deleteBook.zip"
    environment {
        variables = {
        BOOK_TABLE = var.book_table_name
        }
    }
}