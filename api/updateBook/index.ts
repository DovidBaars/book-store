import { APIGatewayProxyHandler } from 'aws-lambda';
import { DynamoDB } from 'aws-sdk';
import { Book } from '../interfaces/Book';

const dynamoDb = new DynamoDB.DocumentClient();

export const handler: APIGatewayProxyHandler = async (event) => {
  const bookData:  Omit<Book, 'isbn'> = event?.body && JSON.parse(event.body);
  const bookTable = process.env.BOOK_TABLE as string
  const isbn: Book["isbn"] = event.pathParameters?.isbn || '';

  
  if (!bookData || !isbn) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'No book, or ISBN provided' }),
    };
  }

  const params = {
    TableName: bookTable,
    Key: {
      "isbn": isbn
    },
    ExpressionAttributeNames: {
      '#title': 'title',
      '#author': 'author',
      '#publicationDate': 'publicationDate',
      '#description': 'description'
    },
    ExpressionAttributeValues: {
      ':title': bookData.title,
      ':author': bookData.author,
      ':publicationDate': bookData.publicationDate,
      ':description': bookData.description
    },
    UpdateExpression: 'SET #title = :title, #author = :author, #publicationDate = :publicationDate, #description = :description',
    ReturnValues: 'ALL_NEW',
  };

  try {
    const result = await dynamoDb.update(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Book updated successfully', book: result.Attributes }),
    };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Could not update book' }),
    };
  }
};