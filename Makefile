# Load environment variables from .env
include .env
export $(shell sed 's/=.*//' .env)

.SILENT:

openzeppelin:
	forge install openzeppelin/openzeppelin-contracts

openzeppelin-upgr:
	forge install openzeppelin/openzeppelin-contracts-upgradeable

account-abstraction:
	forge install eth-infinitism/account-abstraction

solady:
	forge install Vectorized/solady

webauthn:
	forge install base/webauthn-sol

fresh:
	forge install rdubois-crypto/FreshCryptoLib
	
install-forge: openzeppelin openzeppelin-upgr account-abstraction solady webauthn fresh

build:
	forge clean && forge compile