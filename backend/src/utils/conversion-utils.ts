export function convertTimestamp(nanoseconds: string) {
    return Math.floor(+nanoseconds / 1_000_000);
}