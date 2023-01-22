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
import * as stream from "./stream";

async function main () {
    stream.initMaster();
    await setupMySQL(
        MYSQL_HOST!,
        +MYSQL_PORT!,
        MYSQL_DATABASE!,
        MYSQL_USERNAME!,
        MYSQL_PASSWORD!,
        +MYSQL_CONN_LIMIT!
    );

    let i = 1;
    stream.streamMessages((message) => {
        console.log(i++);
    });
}
main();