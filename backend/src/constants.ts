import * as path from "path";

const BASE_DIR = process.cwd();
export const DUMMY_DATA_DIR = path.normalize(`${BASE_DIR}/dummy_data`);

export const VALIDITY_DURATION = 24 * 60 * 60 * 1_000; // Milliseconds
export const DELETION_REST = 1 * 60 * 60 * 1_0000; // Milliseconds
export const SAVE_REST =  1_000; // Milliseconds