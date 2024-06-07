module karrier_one::kyc {
    use std::string;
    use sui::event;
    use karrier_one::kns::{ AdminCap };
    public struct Kyc has key { // no store attribute so it's soulbound
        id: UID
    }

    public struct MintedEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
    }
    public struct ApprovalEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
        ref: string::String,
    }

    public struct BurnedEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID
    }

    public entry fun approve(nft: &Kyc, ref: string::String)
    {
        event::emit(ApprovalEvent {
            object_id: object::id(nft),
            ref: ref
        });              
    }

    public fun airdrop(
        _: &AdminCap,
        recipient: address,
        ctx: &mut TxContext
    ) {                
        let nft = Kyc { id: object::new(ctx) };
        event::emit(MintedEvent {
            object_id: object::id(&nft)
        });
        //transfer::public_transfer(nft, recipient); // public transfer requires the store attribute
        sui::transfer::transfer(nft, recipient)
    }

    public fun airdrop_multi(
        admin: &AdminCap,
        mut recipients: vector<address>,
        ctx: &mut TxContext
    ) {
        let (mut i, len) = (0, vector::length(&recipients));
        while (i < len) {            
            let recipient = vector::pop_back(&mut recipients);
            airdrop(admin, recipient, ctx);
            i = i + 1;
        }
    }

    public fun burn(nft: Kyc) {
        event::emit(BurnedEvent {
            object_id: object::id(&nft)
        });           
        let Kyc { id } = nft;        
        object::delete(id)
    }
}