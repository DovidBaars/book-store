resource "aws_dynamodb_table" "book_table" {
    name           = var.book_table_name
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "ISBN"

    attribute {
        name = "ISBN"
        type = "S"
    }
}