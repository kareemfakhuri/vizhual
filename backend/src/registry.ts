import { BLOCK_COUNT, BLOCK_LENGTH, DELETION_REST, SAVE_REST } from "./constants";
import { deleteStaleMessages, saveMessages } from "./storage";
import { AbnormailityType, Block, Message, MessageType, Order, OrderStatus } from "./types";
import { milliToNano, nanoToMilli } from "./utils/conversion-utils";

const blocks: Block[] = [];
const unresolvedOrders: Map<string, Order> = new Map();
const executedOrders: Map<string, Order> = new Map();
let currentBlockOrders: Order[] = [];

let toSave: Message[] = [];

export function getLastBlock(): Block | null {
    if (blocks.length > 0) {
        return blocks[blocks.length - 1];
    }

    return null;
}

export async function processMessage(message: Message): Promise<void> {
    const { orderID } = message;

    switch (message.type) {
        case MessageType.NewOrderRequest: {
            unresolvedOrders.set(orderID, {
                orderID,
                status: OrderStatus.Unresolved,
                abnormailityType: AbnormailityType.None,
                timestamp: milliToNano(Date.now()),
                life: 0,
            });

            break;
        } case MessageType.Cancelled: {
            // If no matching unresolved order exists
            if (!unresolvedOrders.get(orderID)) {
                currentBlockOrders.push({
                    orderID,
                    status: OrderStatus.Cancelled,
                    abnormailityType: AbnormailityType.NoNewOrderRequest,
                    timestamp: milliToNano(Date.now()),
                    life: 0,
                });
            } else if (executedOrders.has(orderID)) {
                const order = executedOrders.get(orderID)!;

                currentBlockOrders.push({
                    orderID,
                    status: OrderStatus.Cancelled,
                    abnormailityType: AbnormailityType.CancelledAfterExecution,
                    timestamp: order.timestamp,
                    life: Date.now() - nanoToMilli(order.timestamp),
                });

                executedOrders.delete(orderID);
            } else {
                const order = unresolvedOrders.get(orderID)!;

                currentBlockOrders.push({
                    orderID,
                    status: OrderStatus.Cancelled,
                    abnormailityType: AbnormailityType.None,
                    timestamp: order.timestamp,
                    life: Date.now() - nanoToMilli(order.timestamp),
                });

                unresolvedOrders.delete(orderID);
            }

            break;
        } case MessageType.Trade: {
            // If no matching unresolved order exists
            if (!unresolvedOrders.get(orderID)) {
                currentBlockOrders.push({
                    orderID,
                    status: OrderStatus.Executed,
                    abnormailityType: AbnormailityType.NoNewOrderRequest,
                    timestamp: milliToNano(Date.now()),
                    life: 0,
                });
            } else if (executedOrders.has(orderID)) {
                const order = executedOrders.get(orderID)!;

                currentBlockOrders.push({
                    orderID,
                    status: OrderStatus.Cancelled,
                    abnormailityType: AbnormailityType.MultipleExecutions,
                    timestamp: order.timestamp,
                    life: Date.now() - nanoToMilli(order.timestamp),
                });

                executedOrders.delete(orderID);
            } else {
                const order = unresolvedOrders.get(orderID)!;

                currentBlockOrders.push({
                    orderID,
                    status: OrderStatus.Executed,
                    abnormailityType: AbnormailityType.None,
                    timestamp: order.timestamp,
                    life: Date.now() - nanoToMilli(order.timestamp),
                });

                unresolvedOrders.delete(orderID);
            }

            break;
        }
    }

    toSave.push(message);
}

// TODO
export async function loadMessages(): Promise<void> {
    // messages.push(...await getAllMessages());
}

async function flush() {
    const pointer = toSave;
    toSave = [];

    if (pointer.length > 0) {
        await saveMessages(pointer);
    }

    setTimeout(flush, SAVE_REST);
}
flush();

export async function autoDeleteStaleMessages() {
    await deleteStaleMessages();
    setTimeout(autoDeleteStaleMessages, DELETION_REST);
}

function tick() {
    // Step 1: Construct and push block
    const pointer = currentBlockOrders;
    currentBlockOrders = [];

    let executions = 0;
    let cancellations = 0;
    let totalOrderLife = BigInt(0);
    let abnormalities: Order[] = [];

    if (pointer.length > 0) {
        pointer.forEach((order) => {
            if (order.status === OrderStatus.Executed) {
                executions++;
            } else if (order.status === OrderStatus.Cancelled) {
                cancellations++;
            }

            totalOrderLife += BigInt(order.life);
            
            if (order.abnormailityType !== AbnormailityType.None) {
                abnormalities.push(order);
            }
        });

        blocks.push({
            timestamp: milliToNano(Date.now()),
            executions,
            cancellations,
            abnormalities,
            averageOrderLife: +(totalOrderLife / BigInt(pointer.length)).toString()
        });

        // Remove first block if block cap is reached
        if (blocks.length > BLOCK_COUNT) {
            blocks.shift();
        }
    }

    // Step 2: Clear executed orders after enough time has passed
    Array.from(executedOrders.values()).forEach((order) => {
        const timeElapsed = Date.now() - nanoToMilli(order.timestamp);
        if (timeElapsed > BLOCK_LENGTH) {
            executedOrders.delete(order.orderID);
        }
    });

    setTimeout(tick, BLOCK_LENGTH);
}
tick();