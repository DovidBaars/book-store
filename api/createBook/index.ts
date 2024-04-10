import { APIGatewayProxyHandler } from 'aws-lambda';
import { DynamoDB } from 'aws-sdk';
import { Book } from './../interfaces/Book';

const dynamoDb = new DynamoDB.DocumentClient();

export const handler: APIGatewayProxyHandler = async (event) => {
  const bookData: Book = event?.body && JSON.parse(event.body);
  const bookTable = process.env.BOOK_TABLE as string
  
  if (!bookData) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'No book provided' }),
    };
  }

  const params = {
    TableName: bookTable,
    Item: bookData,
  };

  try {
    await dynamoDb.put(params).promise();
    return {
      statusCode: 200,
      body: JSON.stringify(params.Item),
    };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Could not create book' }),
    };
  }
};