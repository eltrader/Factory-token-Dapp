import FCTTokenFactory from './FCTTokenFactory.json'
import contract from 'truffle-contract'

export default async (provider) => {
    const tokenFactory = contract(FCTTokenFactory)
    tokenFactory.setProvider(provider)
    var instance = await tokenFactory.deployed()
    return instance
}