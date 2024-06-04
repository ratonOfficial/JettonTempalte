message InternalComplete {
    excess: Address;
}

message InternalAdd {
    amount: Int as coins;
    origin: Address; // address of message sender
}

message Transfer {
    amount: Int as coins;
    to: Address;
}
