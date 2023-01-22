export enum Direction {
    NBFToExchange,
    ExchangeToNBF,
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
    orderID: string,
    direction: Direction,
    type: MessageType,
    timestamp: string,
    symbol: string;
    price: number
}