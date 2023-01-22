export enum Direction {
    NBFToExchange = "NBFToExchange",
    ExchangeToNBF = "ExchangeToNBF",
}

export enum MessageType {
    NewOrderRequest = "NewOrderRequest",
    NewOrderAcknowledged = "NewOrderAcknowledged",
    CancelRequest = "CancelRequest",
    CancelAcknowledged = "CancelAcknowledged",
    Cancelled = "Cancelled",
    Trade = "Trade"
}

export type Message = {
    orderID: string;
    direction: Direction;
    type: MessageType;
    timestamp: bigint;
    symbol: string;
    price: number;
}

export enum OrderStatus {
    Unresolved = "Unresolved",
    Cancelled = "Cancelled",
    Executed = "Executed",
    ExecutedAndCancelled = "ExecutedAndCancelled",
}

export enum Abnormaility {
    None = "None",
    NoNewOrderRequest = "NoNewOrderRequest",
    MultipleExecutions = "MultipleExecutions",
}

export type Order = {
    orderID: string;
    status: OrderStatus;
    abnormaility: Abnormaility;
    life: number;
}

export type Block = {
    executions: number;
    cancellations: number;
    abnormalities: {
        NoNewOrderRequest: number;
        MultipleExecutions: number;
    };
    averageRequestLife: number;
}