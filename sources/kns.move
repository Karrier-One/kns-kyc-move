module karrier_one::kns {
    use std::string::{String, utf8};
    use std::vector;    
    use sui::display;
    use sui::object::{Self, ID, UID};
    use sui::package;
    use sui::transfer;        
    use sui::tx_context::{sender, TxContext};    
    use sui::event;

    struct KNS has drop {}
    
    struct Kns has key, store {
        id: UID
    }

    struct AdminCap has key, store {
        id: UID
    }

    struct ApprovalEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
        ref: String,
    }

    struct MintedEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID
    }

    struct BurnedEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID
    }

    fun init(otw: KNS, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
            utf8(b"description"),
            utf8(b"project_url"),
        ];
        
        let values = vector[
            // name
            utf8(b"Karrier Number System"),
            // image_url
            utf8(b"https://kns-api.karrier.one/profile/{id}.svg"),
            // description
            utf8(b"Cellular Phone Number"),
            // project_url
            utf8(b"https://karrier.one"),
        ];
        let publisher = package::claim(otw, ctx);
        let display = display::new_with_fields<Kns>(
            &publisher, keys, values, ctx
        );
        display::update_version(&mut display);
        
        transfer::public_transfer(publisher, sender(ctx));
        transfer::public_transfer(display, sender(ctx));     
        transfer::public_transfer(AdminCap { id: object::new(ctx) }, sender(ctx));     
    }    

    public entry fun approve(nft: &mut Kns, ref: String, _ctx: &mut TxContext)
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
        _: &AdminCap,
        recipients: vector<address>,
        ctx: &mut TxContext
    ) {
        let (i, len) = (0, vector::length(&recipients));
        while (i < len) {
            let recipient = vector::pop_back(&mut recipients);
            let nft = Kns { 
                id: object::new(ctx)
                };
            event::emit(MintedEvent {
                object_id: object::id(&nft)
            });            
            transfer::public_transfer(nft, recipient);
            i = i + 1;
        }
    }

    public fun burn(nft: Kns, _: &mut TxContext) {
        event::emit(BurnedEvent {
            object_id: object::id(&nft)
        });
        let Kns { id } = nft;
        object::delete(id)
    }    
}