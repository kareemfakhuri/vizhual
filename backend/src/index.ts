import * as dotenv from "dotenv";

// Load .env before running the app or importing any other files
dotenv.config();

const {
    PORT,
    MYSQL_HOST,
    MYSQL_PORT,
    MYSQL_DATABASE,
    MYSQL_USERNAME,
    MYSQL_PASSWORD,
    MYSQL_CONN_LIMIT
} = process.env;

if (
  !PORT ||
  isNaN(+PORT) ||
  !MYSQL_HOST ||
  !MYSQL_PORT ||
  isNaN(+MYSQL_PORT) ||
  !MYSQL_DATABASE ||
  !MYSQL_USERNAME ||
  !MYSQL_PASSWORD ||
  !MYSQL_CONN_LIMIT ||
  isNaN(+MYSQL_CONN_LIMIT)
) {
  throw new Error(
    "Some environment variables are not set properly. See .env.example"
  );
}

import { setupMySQL } from "./storage";
import { initMaster, streamMessages } from "./stream";
import { autoDeleteStaleMessages, loadMessages, processMessage } from "./registry";
import { startServer } from "./server";

async function main () {
    await setupMySQL(
        MYSQL_HOST!,
        +MYSQL_PORT!,
        MYSQL_DATABASE!,
        MYSQL_USERNAME!,
        MYSQL_PASSWORD!,
        +MYSQL_CONN_LIMIT!
    );

    // Must delete stale messages before loading them into memory (This effectively
    // does nothing but clear the database when dealing with the dummy data)
    await autoDeleteStaleMessages();
    await loadMessages();

    startServer();

    // Fake stream logic
    initMaster();
    streamMessages(processMessage);
}
main();