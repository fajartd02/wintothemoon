import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import List "mo:base/List";
import NFTActorClass "./nft";

actor Operational {

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
        executed : Bool;
    };

    var mapOfNFT = HashMap.HashMap<Principal, NFTActorClass.NFT>(DEFAULT_CAP, Principal.equal, Principal.hash);
    var mapOfOwners = HashMap.HashMap<Principal, List.List<Principal>>(DEFAULT_CAP, Principal.equal, Principal.hash);

    //function to add nft to a particular owner
    private func addToOwnershipMap(owner : Principal, nftId : Principal) {
        //switch statement of question return
        var ownedNfts : List.List<Principal> = switch (mapOfOwners.get(owner)) {
            case null List.nil<Principal>();
            case (?result) result;
        };

        //update
        ownedNfts := List.push(nftId, ownedNfts);
        mapOfOwners.put(owner, ownedNfts);

    };

    public shared (msg) func mint(imgData : [Nat8], name : Text) : async Principal {
        let owner = msg.caller; //returns canisterid owner of main actor

        //experimental cycles for minting
        // Cycles.add(100_500_000_000);
        let newNFT = await NFTActorClass.NFT(name, owner, imgData); //create
        let newNFTPrincipal = await newNFT.getCanisterId(); //get id

        //store
        mapOfNFT.put(newNFTPrincipal, newNFT);
        addToOwnershipMap(owner, newNFTPrincipal);
        return newNFTPrincipal;
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

    public shared ({ caller }) func upsertPlan(target : Principal, plan : WillPlan) : async Text {
        let currentWill = switch (userWillMap.get(caller)) {
            case (null) {
                HashMap.HashMap<Principal, WillPlan>(DEFAULT_CAP, Principal.equal, Principal.hash);
            };
            case (?HashMap) HashMap;
        };

        currentWill.put(target, plan);
        userWillMap.put(caller, currentWill);

        return "success ";
    };

    // Function to retrieve all keys from the userWillMap
    public query func getAllUserAlreadyWillPlan() : async [Principal] {
        return Iter.toArray(userWillMap.keys());
    };

};
