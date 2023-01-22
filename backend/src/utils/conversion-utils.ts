export function nanoToMilli(nano: string): number {
    return Math.floor(+nano / 1_000_000);
}

export function milliToNano(milli: number): string {
    return (BigInt(milli) * BigInt(1_000_000)).toString();
}