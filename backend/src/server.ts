import express from "express";
import { getLastBlock } from "./registry";
import { getTrades } from "./storage";

const PORT = process.env.PORT;

const app = express();

export function startServer() {
  app.listen(PORT);
  console.log(`Server started on port ${PORT}`);
  
}

app.get("/last-block", (_req, res) => {
  const block = getLastBlock();
  const result = block ? JSON.stringify(block, null, 2) : JSON.stringify({});
  res.send(result);
});

app.get("/symbols/:symbol", async (req, res) => {
    const { symbol } = req.params;

    const trades = await getTrades(symbol);
    res.send(JSON.stringify(trades, null, 2));
});