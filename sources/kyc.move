module karrier_one::kyc {
    use std::string::{String, utf8};
    use sui::object::{Self, ID, UID};
    use sui::package;
    use sui::display;
    use sui::transfer;
    use std::vector;  
    use sui::tx_context::{Self, sender, TxContext};    
    use sui::event;

    struct Kyc has key { 
        //}, store { // store attribute is required for public_transfer, which we don't want here
        id: UID
    }
    /// One-Time-Witness for the module.
    struct KYC has drop {}

    /// AdminCap is used to control the airdrop function
    struct AdminCap has key, store {
        id: UID,
    }
    
    struct MintedEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
    }
    struct ApprovalEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
        ref: String,
    }

    struct BurnedEvent has copy, drop {
        // The Object ID of the NFT
        object_id: ID
    }

    public entry fun approve(nft: &mut Kyc, ref: String, _ctx: &mut TxContext)
    {
        event::emit(ApprovalEvent {
            object_id: object::id(nft),
            ref: ref
        });              
    }

    fun init(otw: KYC, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
  //          utf8(b"link"),
            utf8(b"image_url"),
            utf8(b"description"),
            utf8(b"project_url"),
            utf8(b"creator"),
        ];

        let values = vector[
            // name
            utf8(b"KYC Verification Certificate"),
            // image_url
            utf8(b"https://kns-api.karrier.one/kyc/{id}.svg"),
            // description
            utf8(b"The owner of this wallet has been verified by Karrier One."),
            // project url
            utf8(b"https://karrier.one"),
            // creator
            utf8(b"Karrier One Team")  
        ];

        // Claim the `Publisher` for the package
        let publisher = package::claim(otw, ctx);

        // Get a new `Display` object for the `Hero` type.
        let display = display::new_with_fields<Kyc>(
            &publisher, keys, values, ctx
        );

        // Commit first version of `Display` to apply changes.
        display::update_version(&mut display);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));
        transfer::public_transfer(AdminCap { id: object::new(ctx) }, sender(ctx));        
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
        _: &AdminCap,
        recipients: vector<address>,
        ctx: &mut TxContext
    ) {
        let (i, len) = (0, vector::length(&recipients));
        while (i < len) {
            let recipient = vector::pop_back(&mut recipients);
            let nft = Kyc { 
                id: object::new(ctx)
                };
            event::emit(MintedEvent {
                object_id: object::id(&nft)
            });         
            sui::transfer::transfer(nft, recipient);
            i = i + 1;
        }
    }

    public fun burn(nft: Kyc, _: &mut TxContext) {
        event::emit(BurnedEvent {
            object_id: object::id(&nft)
        });           
        let Kyc { id } = nft;        
        object::delete(id)
    }
}