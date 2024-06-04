import "@stdlib/deploy";
import "./messages";

contract JettonWallet with Deployable {

    parent: Address;
    owner: Address;
    balance: Int as coins;

    init(parent: Address, owner: Address) {
        self.parent = parent;
        self.owner = owner;
        self.balance = 0;
    }

    // step1: transfer
    // transfer token to other
    receive(msg: Transfer) {
        receive(sender() == self.owner, "Access denied");
        require(self.balance >= msg.amount, "Insufficent balance"); 
        self.balance = self.balance - msg.amount;
        let init: StateInit = initOf JettonWallet(self.parent, msg.to); // got receiver's jetton wallet contract info 
        send(SendParamenters {
            to: contractAddress(init),
            body: InternalAdd(amount: msg.amount, origin: self.owner),
            value: ton(0.04),
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data
        })
        self.reply("transfer finished".asComment());
    }

    // step2: got
    // receive token from master or other jetton wallet
    receive(msg: InternalAdd) {
        if(msg.origin = self.parent) {
            // mint function - parent to child
            require(sender() == self.parent, "Master/Parent only");
        }else {
            let init: StateInit = initOf JettonWallet(self.parent, msg.origin);
            // child to child - other child to child
            require(sender() == contractAddress(), "Need JettonWallet only");
        }
        self.balance = self.balance + msg.amount;
    }   

}