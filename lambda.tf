data "archive_file" "createBook" {
    type        = "zip"
    source_file = "${path.module}/api/dist/createBook/createBook.js"
    output_path = "${path.module}/api/dist/createBook/createBook.zip"
}

resource "aws_lambda_function" "create_book_function" {
    function_name = "createBook"
    role          = aws_iam_role.lambda_books_executor.arn
    handler       = "createBook.handler"
    runtime       = "nodejs20.x"
    filename      = data.archive_file.createBook.output_path
    source_code_hash = filebase64sha256(data.archive_file.createBook.output_path)
    environment {
        variables = {
        BOOK_TABLE = var.book_table_name
        }
    }
}

data "archive_file" "retrieveBook" {
    type        = "zip"
    source_file = "${path.module}/api/dist/retrieveBook/retrieveBook.js"
    output_path = "${path.module}/api/dist/retrieveBook/retrieveBook.zip"
}

resource "aws_lambda_function" "retrieve_book_function" {
    function_name = "retrieveBook"
    role          = aws_iam_role.lambda_books_executor.arn
    handler       = "retrieveBook.handler"
    runtime       = "nodejs20.x"
    filename      = data.archive_file.retrieveBook.output_path
    source_code_hash = filebase64sha256(data.archive_file.retrieveBook.output_path)
    environment {
        variables = {
        BOOK_TABLE = var.book_table_name
        }
    }
}

data "archive_file" "updateBook" {
    type        = "zip"
    source_file = "${path.module}/api/dist/updateBook/updateBook.js"
    output_path = "${path.module}/api/dist/updateBook/updateBook.zip"
}

resource "aws_lambda_function" "update_book_function" {
    function_name = "updateBook"
    role          = aws_iam_role.lambda_books_executor.arn
    handler       = "updateBook.handler"
    runtime       = "nodejs20.x"
    filename      = data.archive_file.updateBook.output_path
    source_code_hash = filebase64sha256(data.archive_file.updateBook.output_path)
    environment {
        variables = {
        BOOK_TABLE = var.book_table_name
        }
    }
}

data "archive_file" "deleteBook" {
    type        = "zip"
    source_file = "${path.module}/api/dist/deleteBook/deleteBook.js"
    output_path = "${path.module}/api/dist/deleteBook/deleteBook.zip"
}

resource "aws_lambda_function" "delete_book_function" {
    function_name = "deleteBook"
    role          = aws_iam_role.lambda_books_executor.arn
    handler       = "deleteBook.handler"
    runtime       = "nodejs20.x"
    filename      = data.archive_file.deleteBook.output_path
    source_code_hash = filebase64sha256(data.archive_file.deleteBook.output_path)
    environment {
        variables = {
        BOOK_TABLE = var.book_table_name
        }
    }
}