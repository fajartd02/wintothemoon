import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

actor {

    private let DEFAULT_CAP = 10;

    type Token = {
        name : Text;
        amount : Nat;
    };

    type NFT = {
        metadata : Text;
    };

    type WillPlan = {
        tokenList : [Token];
        nftList : [NFT];
        cost : Nat; // amount of tokens to be consumed for operational purposes
        description : Text;
    };

    private let userWillMap = HashMap.HashMap<Principal, HashMap.HashMap<Principal, WillPlan>>(DEFAULT_CAP, Principal.equal, Principal.hash);

    public query func getWillPlans(principalId : Principal) : async [(Principal, WillPlan)] {
        switch (userWillMap.get(principalId)) {
            case (?willPlans) {
                // Convert the HashMap to a list of tuples
                return Iter.toArray(willPlans.entries());
            };
            case (null) {
                // Return an empty list if no WillPlans are found for the principalId
                return [];
            };
        };
    };

    public shared ({ caller }) func addPlan(target : Principal, plan : WillPlan) : async Text {
        let currentWill = switch (userWillMap.get(caller)) {
            case (null) {
                HashMap.HashMap<Principal, WillPlan>(DEFAULT_CAP, Principal.equal, Principal.hash);
            };
            case (?HashMap) HashMap;
        };

        currentWill.put(target, plan);
        userWillMap.put(caller, currentWill);

        return "success";
    };

    // Function to retrieve all keys from the userWillMap
    public query func getAllUserKeys() : async [Principal] {
        return Iter.toArray(userWillMap.keys());
    };

};
