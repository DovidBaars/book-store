import { APIGatewayProxyHandler } from 'aws-lambda';
import { DynamoDB } from 'aws-sdk';
import { Book } from './../interfaces/Book';

const dynamoDb = new DynamoDB.DocumentClient();

export const handler: APIGatewayProxyHandler = async (event) => {
  let bookData: Book;

 
  try {
    bookData = event?.body ? JSON.parse(event.body) : undefined;
  } catch (error) {
    console.error('Failed to parse event body:', error);
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Invalid book data' }),
    };
  }

  if (!bookData) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'No book data provided' }),
    };
  }

  const bookTable = process.env.BOOK_TABLE as string

  const params = {
    TableName: bookTable,
    Item: bookData,
  };

  if (!params.Item) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'No book data to store in DynamoDB' }),
    };
  }

  try {
    await dynamoDb.put(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify(params.Item),
    };
  } catch (error) {
    console.error('DynamoDB error:', error);
    return {
      statusCode: 500,
      //TODO: Do not return error details in production 
      body: JSON.stringify({ message: 'Could not create book ' + error}),
    };
  }
};