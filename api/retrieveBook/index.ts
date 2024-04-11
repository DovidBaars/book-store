import { APIGatewayProxyHandler } from 'aws-lambda';
import { DynamoDB } from 'aws-sdk';
import { Book } from '../interfaces/Book';

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
    const result = await dynamoDb.get(params).promise();
    if (result.Item) {
      return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Book retrieved successfully', book: result.Item }),
      };
    } else {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: 'Book not found' }),
      };
    }
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Could not retrieve book' }),
    };
  }
};