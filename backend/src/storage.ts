import { VALIDITY_DURATION } from "./constants";
import { Direction, Message, MessageType } from "./types";
import { milliToNano } from "./utils/conversion-utils";
import { MySQLPool } from "./utils/mysql-utils";

const TABLE_NAME = "messages";
const TABLE_SIGNATURE = `order_id VARCHAR(255) NOT NULL,
direction VARCHAR(255) NOT NULL,
type VARCHAR(255) NOT NULL,
timestamp BIGINT NULL,
symbol VARCHAR(63),
price DOUBLE,
KEY idx_order_id (order_id),
KEY idx_symbol (symbol),
KEY idx_timestamp (timestamp) USING BTREE`;

let pool: MySQLPool;

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

async function setupTables(): Promise<void> {
    pool.query(`CREATE TABLE IF NOT EXISTS ${TABLE_NAME} (${TABLE_SIGNATURE});`);
}

export async function saveMessages(messages: Message[]): Promise<void> {
    const toSave: any[] = [];

    messages.forEach((message) => {
        toSave.push({
            order_id: message.orderID,
            direction: message.direction,
            type: message.type,
            timestamp: message.timestamp,
            symbol: message.symbol,
            price: message.price,
        });
    });

    await pool.writeValues(TABLE_NAME, toSave);
}

export async function getAllMessages(): Promise<Message[]> {
    const result = await pool.query(`SELECT * FROM ${TABLE_NAME};`);
    
    const messages: Message[] = [];

    if (result) {
        for (const message of result) {
            messages.push({
                orderID: message.order_id,
                direction: <Direction>message.direction,
                type: <MessageType>message.type,
                timestamp: BigInt(message.timestamp),
                symbol: message.symbol,
                price: message.price
            });
        }
    }
    
    return messages;
}

export async function deleteStaleMessages(): Promise<void> {
    const cutoff = Date.now() - VALIDITY_DURATION;    
    await pool.query(`DELETE FROM ${TABLE_NAME} WHERE timestamp < ${milliToNano(cutoff)};`);
}