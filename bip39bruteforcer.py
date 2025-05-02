from bip_utils import Bip39MnemonicGenerator, Bip39SeedGenerator, Bip44, Bip44Coins, Bip44Changes
import requests

def generate_wallet():
    # Generate mnemonic
    mnemonic = Bip39MnemonicGenerator().FromWordsNumber(12)
    seed = Bip39SeedGenerator(mnemonic).Generate()
    bip44_wallet = Bip44.FromSeed(seed, Bip44Coins.BITCOIN)
    bip44_addr = bip44_wallet.Purpose().Coin().Account(0).Change(Bip44Changes.CHAIN_EXT).AddressIndex(0)
    
    private_key = bip44_addr.PrivateKey().ToWif()
    address = bip44_addr.PublicKey().ToAddress()
    return mnemonic, private_key, address

def check_balance(address):
    try:
        url = f"https://blockstream.info/api/address/{address}"
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        balance = data.get("chain_stats", {}).get("funded_txo_sum", 0) - data.get("chain_stats", {}).get("spent_txo_sum", 0)
        return balance / 1e8  # Convert sats to BTC
    except Exception as e:
        return f"Error checking balance: {e}"
      
mnemonic, priv_key, address = generate_wallet()
print(f"Mnemonic Phrase: {mnemonic}")
print(f"Private Key (WIF): {priv_key}")
print(f"Bitcoin Address: {address}")

balance = check_balance(address)
print(f"Balance: {balance} BTC")
