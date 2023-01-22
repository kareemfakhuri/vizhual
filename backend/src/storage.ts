import { MySQLPool } from "./utils/mysql-utils";

let pool: MySQLPool;

const TABLE_SIGNATURE = `order_id VARCHAR(255) NOT NULL,
direction VARCHAR(255) NOT NULL,
type VARCHAR(255) NOT NULL,
timestamp BIGINT NULL,
symbol VARCHAR(63),
price DOUBLE NOT NULL,
KEY idx_order_id (order_id),
KEY idx_symbol (symbol)`;

export async function setupMySQL(
  host: string,
  port: number,
  database: string,
  username: string,
  password: string,
  connectionLimit: number,
): Promise<void> {
  pool = new MySQLPool(host, port, database, username, password, connectionLimit);
  await setupTables();
}

// TODO
async function setupTables(): Promise<void> {
}