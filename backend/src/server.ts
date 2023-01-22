import express from "express";

const app = express();

export function startServer() {
  app.listen(process.env.PORT);
}

app.get("/tokens", async (req, res) => {
  const { contractAddress, tokenID } = req.query;
});