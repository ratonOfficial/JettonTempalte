import "@stdlib/deploy";
import "./messages";
import "./jetton_wallet";

struct Metadata {
    symbol: String,
    totalSupply: Int as coins;
}

contract JettonMaster with Deployable {

    symbol: String;
    totalSupplyL: Int as coins;

    init() {
        self.symbol = ""; // Our Token name
        self.totalSupply = ton(""); // total number of token
        self.mint(self.totalSupply, sender());
    }

    fun mint(amount: Int, to: Address) {
        let init: StateInit = initOf JettonWallet(myAddress(), to);
        send(SendParamenters{
           to: contractAddress(init),
           body: InternalAdd{amount: amount, origin: myAddress()}, // InternaAdd format
           value: ton("0.04"), // gas
           mode: SendIgnoreErrors,
           code: init.code,
           data: init.data
        });
    }

    // stander getter function
    get fun walletAddress(owner: Address): Address {
        let init: StateInit = initOf JettonWallet(myAddress(), owner);
        return contractAddress(init);
    }

    get fun metadata(): Metadata {

    }
}