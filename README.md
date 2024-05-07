# book-store

This is a book store backend using Terraform, AWS, and TS.

It allows store employees to:

- Add a book to the store db
- Remove a book
- Update a book
- Retrieve a book 

**Employees are authenticated, and authorized through AWS Cognito**
- This can be done manually at the moment through a js script
1. Add a .env file to the api dir with the following properties:
    BOOK_STORE_USER_NAME
    PASSWORD
    CLIENT_ID
2. cd api && npm run login
3. The returned credential IdToken is used as the Bearer token in requests

 
**Deploy**
1. cd api && npx webpack
2. cd ../ && terraform plan -out plan
3. terraform apply plan


Test Change