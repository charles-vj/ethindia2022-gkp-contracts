# 🔐 GateKeeping Protokol Contracts🔗

## Gatekeeping protocol as your event entry manager
POAPs are overkill and highly unscalable at the same time. We wanted to create something that is easy for the event organisers to use, which doesn't involve the usual web3 jargon and has more than just a option to airdrop/mint NFTs . Presenting **Gatekeeping Protocol**, 
The event organizers can choose from a wide range of gated mechanisms that we provide, for them to gatekeep as they want.

## Gatekeeping protocol as a subscription manager
We take the idea of using NFTs as proof of attendance and extend it to using the same token as proof of subscription, thus extending the legs of POAP into the domain of subscription models. Some of these models include minting soul bound NFTs, NFT that can be sublet to others for a price.

## Gatekeeping protocol as a *boring* POAP dispenser
In addition to all the other cool features that we provide, we also act as POAP dispenser, which is just a fancy way of explaining account whitelisting.


# Protocol structure
* The protocol right now consists of 3 different type of subscription model / event management structures. All three of them are maintained by the **Gatekeeper** contract. This contract creates the NFT collection or whitelisting database as needed. It also acts as a lens to view all relevant data

* Soul-bound NFT contract. This acts as the key to the gates which have issued an NFT 

* Rentable NFT contract. These keys have a lessor-tenant relationship. The original keys can be rented out to other accounts for borrowing the utility. Best usecase for these kind of NFTs are OTT subscriptions

# Contract address

* Gatekeeper.sol : "0xA78268bC5A0a192300f935570FCd002796410387" deployed on Mumbai testnet on polygon.
* RentedKey.sol : "0xE0E0CeCfa04Ad0Da26F9635131B3Da25AA3b153C" deployed on Mumbai testnet on Polygon.
* SoulBoundKey.sol : "0x8029ec1b26A9eA9345F7E2D3fbc031Dcf1f7082C" deployed on Mumbai testnet on Polygon.
