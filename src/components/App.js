import React, {Component} from 'react';
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json';
import { ethers } from "ethers";
export default class App extends Component {
    async componentDidMount() {
        await this.loadWeb3ProviderAndBlockchainData();
    }


    async loadWeb3ProviderAndBlockchainData() {

        // Loads MetaMask as the provider
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();

        // Check if provider loaded
        if(provider) {
        } else {
            window.alert('No Ethereum Wallet detected');
        };

        // Get accounts and networkId
        const accounts = await provider.send('eth_accounts', []);
        const networkId = await provider.send('net_version', []);

        // Update State with info
        this.setState({
            account: accounts,
            networkIs: networkId
        });

        // Loads Contract information from the Blockchain
        const networkData = KryptoBird.networks[networkId];

        if(networkData) {

            const contractAbi = KryptoBird.abi;
            const contractAddress = networkData.address;

            // Ethers use a segregated approach to reading / writing to Contracts
            // To read from, use contractRead
            // To write to (like to Mint, etc, use contractSign

            const contractRead = new ethers.Contract(contractAddress, contractAbi, provider);
            const contractSign = new ethers.Contract(contractAddress, contractAbi, signer);

            this.setState({
                contractRead: contractRead,
                contractSign: contractSign
            });

        } else {
            window.alert('Smart Contract is not Deployed')
        };

        // When calling functions using ethers.js, you can call them directly
        // The below example calls totalSupply, directly under the contractRead object

        let getTotalSupply = await this.state.contractRead.totalSupply();
        getTotalSupply = ethers.utils.formatUnits(getTotalSupply, 0);

        this.setState({
            totalSupply: getTotalSupply
        });

        for(let i = 0; i < getTotalSupply; i++) {

            const KryptoBird = await this.state.contractRead.kryptoBirdz(i - 0);

            this.setState({
                kryptoBirdz:[...this.state.kryptoBirdz, KryptoBird]
            });
        }
    };

    constructor(props) {
        super(props);
        this.state = {
            account: ''
        }
    }
    render() {
        return (
            <div>
                <nav className={'navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'}>
                    <div className={'navbar-brand col-sm-3 col-md-3 mr-0'} style={{color: "white"}}>
                        Krypto Birdz NFTs (Non Fungible Token)
                    </div>
                    <ul className={'navbar-nav px-3'}>
                        <li className={'nav-item text-nowrap d-none d-sm-none d-sm-block'}>
                            <small className={'text-white'}>{this.state.account}</small>
                        </li>
                    </ul>
                </nav>
                <h1>NFT Marketplace</h1>
            </div>
        )
    }
}

