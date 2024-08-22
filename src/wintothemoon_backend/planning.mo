import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";

actor {

    private let DEFAULT_CAP = 10;

    type Token = {
        name: Text;
        amount: Nat;
    };

    type NFT = {
        metadata: Text;
    };

    type WillPlan = {
        tokenList: [Token];
        nftList: [NFT];
        cost: Nat; // amount of tokens to be consumed for operational purposes
        description: Text;
    };

    private let userWillMap = HashMap.HashMap<
        Principal,
        HashMap.HashMap<Principal, WillPlan>
    >(DEFAULT_CAP, Principal.equal, Principal.hash);

    public shared ({ caller }) func addPlan(target: Principal, plan: WillPlan) {
        let currentWill = switch (userWillMap.get(caller)) {
            case (null) { HashMap.HashMap<Principal, WillPlan>(DEFAULT_CAP, Principal.equal, Principal.hash) };
            case (?HashMap) HashMap;
        };

        ignore currentWill.replace(target, plan);
    }

}