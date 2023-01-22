// This is a hardcoded script for converting the dummy data into a real-time stream

import * as fs from "fs";
import { DUMMY_DATA_DIR } from "./constants";
import { Message } from "./types";
import { wait } from "./utils/async-utils";
import { convertTimestamp } from "./utils/conversion-utils";

const master: Message[] = [];

export function initMaster() {
    for (const fileName of ["AequitasData.json", "AlphaData.json", "TSXData.json"]) {
        const file = fs.readFileSync(`${DUMMY_DATA_DIR}/${fileName}`);
        const parsed = JSON.parse(file.toString());
        
        parsed.forEach((message: any) => {
            master.push({
                orderID: message.OrderID,
                direction: message.Direction,
                type: message.MessageType,
                timestamp: message.TimeStampEpoch,
                symbol: message.Symbol,
                price: message.OrderPrice
            });
        });
    }

    // Sort ascending. Expensive cast to BigInt but acceptable because we would
    // not need to do any sorting in a real-time environment
    master.sort((a, b) => {
        return +(BigInt(a.timestamp) - BigInt(b.timestamp)).toString();
    });
}

export async function streamMessages(callback: (message: Message) => void | Promise<void>, speedFactor: number = 1) {
    // All stream processes in microseconds because setTimeout does not support nanoseconds
    let index = 0;
    let nextMessage = master[index];
    let pointer = convertTimestamp(nextMessage.timestamp);

    while (index !== master.length) {
        const startTime = Date.now();

        while (nextMessage !== undefined && convertTimestamp(nextMessage.timestamp) < pointer) {
            callback(nextMessage);
            index++;
            nextMessage = master[index];
        }

        await wait(1);

        // Because time elapsed might be (likely is) longer than 1ms due to execution time
        pointer = pointer + ((Date.now() - startTime) * speedFactor);
    }
}