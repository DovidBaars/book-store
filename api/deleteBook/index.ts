import { APIGatewayProxyHandler } from 'aws-lambda';
import { DynamoDB } from 'aws-sdk';
import { Book } from './../interfaces/Book';

const dynamoDb = new DynamoDB.DocumentClient();

export const handler: APIGatewayProxyHandler = async (event) => {
  const isbn: Book["isbn"] = event.pathParameters?.isbn || '';
  const bookTable = process.env.BOOK_TABLE as string
  
  if (!isbn) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'No isbn provided' }),
    };
  }

  const params = {
    TableName: bookTable,
    Key: {
      "isbn": isbn
    },
  };

  try {
    await dynamoDb.delete(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Book deleted successfully' }),
    };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Could not delete book' }),
    };
  }
};