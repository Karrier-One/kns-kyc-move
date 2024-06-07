module karrier_one::kns {
    use std::string;  
    use sui::display;
    use sui::package; 
    use sui::event;

    public struct KNS has drop {}
    
    public struct Kns has key, store {
        id: UID
    }

    public struct AdminCap has key, store {
        id: UID
    }

    public struct ApprovalEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
        ref: string::String,
    }

    public struct MintedEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID
    }

    public struct BurnedEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID
    }

    public fun setup_display<T: key>(pub: &package::Publisher, fields: vector<string::String>, values: vector<string::String>, ctx: &mut TxContext): display::Display<T> {
        let mut display = display::new_with_fields<T>(pub, fields, values, ctx);
        display.update_version();

        display
    }

    fun init(otw: KNS, ctx: &mut TxContext) {        
        package::claim_and_keep(otw, ctx);  
        transfer::public_transfer(AdminCap { id: object::new(ctx) }, tx_context::sender(ctx));     
    }

    public entry fun approve(nft: &Kns, ref: string::String)
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
        let nft = Kns { 
            id: object::new(ctx)
            };
        event::emit(MintedEvent {
            object_id: object::id(&nft)
        });            
        transfer::public_transfer(nft, recipient);        
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

    public fun burn(nft: Kns) {
        event::emit(BurnedEvent {
            object_id: object::id(&nft)
        });
        let Kns { id } = nft;
        object::delete(id)
    }
}