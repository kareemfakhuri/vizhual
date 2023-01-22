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
    timestamp: string;
    symbol: string;
    price: number;
}

export enum OrderStatus {
    Unresolved = "Unresolved",
    Cancelled = "Cancelled",
    Executed = "Executed",
}

export enum AbnormailityType {
    None = "None",
    NoNewOrderRequest = "NoNewOrderRequest",
    MultipleExecutions = "MultipleExecutions",
    CancelledAfterExecution = "CancelledAfterExecution",
}

export type Order = {
    orderID: string;
    status: OrderStatus;
    abnormailityType: AbnormailityType;
    timestamp: string;
    life: number;
}

export type Block = {
    timestamp: string;
    executions: number;
    cancellations: number;
    abnormalities: Order[];
    averageOrderLife: number;
}