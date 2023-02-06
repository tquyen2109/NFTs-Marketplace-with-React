import React, {Component} from 'react';
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json';
export default class App extends Component {
    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }
    async loadWeb3 () {
        const provider = await detectEthereumProvider();
        if(provider) {
            console.log('ethereum wallet is connected');
            window.web3 = new Web3(provider);
        } else {
            console.log('no ethereum wallet detected')
        }
    }

    async loadBlockchainData() {
        const account = await window.web3.eth.getAccounts();
        console.log(account);
    }
    render() {
        return (
            <div>
                <h1>NFT Marketplace</h1>
            </div>
        )
    }
}

