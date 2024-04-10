variable "region" {
    default = "us-east-1"
}

variable "book_table_name" {
    description = "The name of the books DynamoDB table"
    type = string
    default = "book_table"
}