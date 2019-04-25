import React, { Component } from "react";
import SimpleStorageContract from "./contracts/SimpleStorage.json";
import getWeb3 from "./utils/getWeb3";
import ipfs from './ipfs'
// import { Route, Link, BrowserRouter as Router, Switch } from 'react-router-dom'

import "./App.css";

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      ipfsHash: '',
      web3: null,
      buffer: null,
      account: null
    }
    this.captureFile = this.captureFile.bind(this);
    this.onSubmit = this.onSubmit.bind(this);
  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.

    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })

      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */

    const contract = require('truffle-contract')
    const simpleStorage = contract(SimpleStorageContract)
    simpleStorage.setProvider(this.state.web3.currentProvider)

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
      // simpleStorage.deployed().then((instance) => {
      //   this.simpleStorageInstance = instance
      //   this.setState({ account: accounts[0] })
      //   // Get the value from the contract to prove it worked.
      //   return this.simpleStorageInstance.get.call(accounts[0])
      // }).then((ipfsHash) => {
      //   // Update state with the result.
      //   return this.setState({ ipfsHash })
      // })
    })
  }



  captureFile(event) {
    event.preventDefault()
    const file = event.target.files[0]
    const reader = new window.FileReader()
    reader.readAsArrayBuffer(file)
    reader.onloadend = () => {
      this.setState({ buffer: Buffer(reader.result) })
      console.log('buffer', this.state.buffer)
    }
  }

  onSubmit(event) {
    event.preventDefault()
    ipfs.files.add(this.state.buffer, (error, result) => {
      if(error) {
        console.error(error)
        return
      }
      this.simpleStorageInstance.set(result[0].hash, { from: this.state.account }).then((r) => {
        return this.setState({ ipfsHash: result[0].hash })
        //console.log('ifpsHash', this.state.ipfsHash)
      })
    })
  }

  render() {
    return (
      <div>
        <nav className="navbar navbar-dark bg-dark">
          <a className="navbar-brand" href="#"><i className="fas fa-laptop-medical" /></a>
        </nav>
        <div className="container">
          <h1>Oluwafisayo Oke</h1>
          <br />
          <table className="table table-striped">
            <thead>
              <tr>
                <th scope="col">#</th>
                <th scope="col">Doctor</th>
                <th scope="col">Hospital</th>
                <th scope="col">Date</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th scope="row">1</th>
                <td>Mark Make</td>
                <td>Grady Hospital</td>
                <td>2/2/19</td>
                <td><button type="button" className="btn btn-success btn-sm">View</button></td>
              </tr>
              <tr>
                <th scope="row">2</th>
                <td>Amaka Agu</td>
                <td>Kaiser Permanente</td>
                <td>6/4/19</td>
                <td><button type="button" className="btn btn-success btn-sm">View</button></td>
              </tr>
              <tr>
                <th scope="row">3</th>
                <td>Larry Bird</td>
                <td>Celtics Hospital</td>
                <td>6/5/20</td>
                <td><button type="button" className="btn btn-success btn-sm">View</button></td>
              </tr>
            </tbody>
          </table>
          <p id="accountAddress" className="text-center">0x305F746cB05dc1393bB3e27D0054dc583400f662</p>
          <p>
            <a className="btn btn-dark" data-toggle="collapse" href="#multiCollapseExample1" role="button" aria-expanded="false" aria-controls="multiCollapseExample1"><strong>Set Permission</strong></a> <span> </span>
            <a className="btn btn-dark" data-toggle="collapse" href="#multiCollapseExample2" role="button" aria-expanded="false" aria-controls="multiCollapseExample1"><strong>Add Record</strong></a>
          </p>
          <div className="collapse multi-collapse" id="multiCollapseExample2">
            <div className="card card-body">
              <form className="form-inline">
                <div className="form-group">
                  <label htmlFor="exampleFormControlFile1">Upload File</label>
                  <input type="file" className="form-control-file" id="exampleFormControlFile1" />
                </div>
                <button type="submit" className="btn btn-dark btn-sm mb-2">Submit</button>
              </form>
            </div>
          </div>
          <div className="collapse multi-collapse" id="multiCollapseExample1">
            <div className="card card-body">
              <form>
                <div className="form-row">
                  <div className="col-7">
                    <input type="text" className="form-control" placeholder="Account" />
                  </div>
                  <div className="col">
                    <input type="text" className="form-control" placeholder="#" />
                  </div>
                  <div className="col">
                    <button type="submit" className="btn btn-dark btn-sm mb-2">Submit</button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
