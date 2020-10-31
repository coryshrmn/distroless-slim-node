import express, { Request, Response } from 'express';

const app = express();
const port = 3000;

const handler = (req: Request, res: Response) => {
  res.send('Hello Typescript!');
};

app.get('/', handler);

app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});