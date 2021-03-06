require("dotenv").config();
const TransferredTokenSupplyStrategyRenderer = artifacts.require('TransferredTokenSupplyStrategyRenderer');
const TransferredTokenSupplyStrategy = artifacts.require('TransferredTokenSupplyStrategy');
const ERC20SaleStrategyTemplate = artifacts.require('tokenboost-solidity-erc20sale/ERC20SaleStrategyTemplate');
const ERC20SaleStrategyRegistry = artifacts.require('tokenboost-solidity-erc20sale/ERC20SaleStrategyRegistry');
const getAccounts = require('./getAccounts');
const updateTemplate = require('./updateTemplate.js');

module.exports = async function (callback) {
    try {
        let template = await updateTemplate(
            web3,
            "net.tokenboost.strategy.sale.erc20.transferred-token-supply",
            TransferredTokenSupplyStrategy,
            TransferredTokenSupplyStrategyRenderer,
            ERC20SaleStrategyTemplate,
            ERC20SaleStrategyRegistry,
            2 * 10 ** 18,
            (await getAccounts(web3))[0]
        );
        await Promise.all([
            await template.setNameAndDescription(
                'en',
                'Transferred Token Supply',
                'This strategy supplies tokens to the sale. Before your sale starts, you should transfer maximum amount of tokens to sell to this strategy.'
            ),
            await template.setNameAndDescription(
                'ko',
                '전송되는 토큰 공급',
                '이 전략은 세일에 토큰을 공급합니다. 세일이 시작되기 전에 판매할 최대 수량의 토큰을 이 전략에게로 전송해야 합니다.'
            )
        ]);
        callback();
    } catch (e) {
        callback(e);
    }
};
