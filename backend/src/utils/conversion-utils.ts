export function nanoToMilli(nano: BigInt): number {
    return Math.floor(+nano / 1_000_000);
}

export function milliToNano(milli: number): BigInt {
    return BigInt(milli) * BigInt(1_000_000);
}