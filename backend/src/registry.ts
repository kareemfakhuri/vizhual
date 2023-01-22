import { DELETION_REST, SAVE_REST } from "./constants";
import { deleteStaleMessages, getAllMessages, saveMessages } from "./storage";
import { Message } from "./types";

const messages: Message[] = [];
let toSave: Message[] = [];

export async function registerMessage(message: Message): Promise<void> {
    messages.push(message);
    toSave.push(message);
}

export async function loadMessages(): Promise<void> {
    messages.push(...await getAllMessages());
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