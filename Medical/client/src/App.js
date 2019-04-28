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
      account: null,
      records: [],
      status: "Doctor"
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

      // web3.eth.getCoinbase(function(err, account) {
      //   if (err === null) {
      //     this.setState({ account: account })
      //     $("#accountAddress").html("Your Account: " + account);
      //   }
      // });

      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }

  instantiateContract() {
    const contract = require('truffle-contract')
    const simpleStorage = contract(SimpleStorageContract)
    simpleStorage.setProvider(this.state.web3.currentProvider)


    // Get account.
    this.state.web3.eth.getCoinbase((error, account) => {
      // simpleStorage.deployed().then((instance) => {
      //   this.simpleStorageInstance = instance
      //   this.setState({ account : account[0] })
      //   // Get the value from the contract to prove it worked.
      //   return this.simpleStorageInstance.getRecords(account).call({from: {account}})
      // }).then((records) => {
      //   // Update state with the result.
      //   return this.setState({ records })
      // })
    })
  }


  captureFile(event) {
    event.preventDefault()
    // const file = event.target.files[0]
    // const reader = new window.FileReader()
    // reader.readAsArrayBuffer(file)
    // reader.onloadend = () => {
    //   this.setState({ buffer: Buffer(reader.result) })
     // console.log('buffer', this.state.buffer)
     console.log("captured file")
    //}
  }

  onSubmit(event) {
    event.preventDefault()
    // ipfs.files.add(this.state.buffer, (error, result) => {
    //   if(error) {
    //     console.error(error)
    //     return
    //   }
    //   this.simpleStorageInstance.set(result[0].hash, { from: this.state.account }).then((r) => {
    //     return this.setState({ ipfsHash: result[0].hash })
    //     //console.log('ifpsHash', this.state.ipfsHash)
    //   })
    // })
  }


  render() {
    let permissionButtonType;
    let permissionButtonRender;
    let addButtonType;
    let addButtonRender;

    if(this.state.status === "Individual"){
        permissionButtonType = <a style={{backgroundColor: '#18232E', color: 'white'}} className="btn" data-toggle="collapse"  href="#multiCollapseExample1" role="button" aria-expanded="false" aria-controls="multiCollapseExample1"><strong>Set Permission</strong></a>
        permissionButtonRender =<div className="collapse multi-collapse col-md-6" id="multiCollapseExample1">
                                  <div className="card card-body" style={{backgroundColor: '#18232E', color: 'white'}}>
                                    <form>
                                      <div className="form-row">
                                        <div className="col-9">
                                          <input type="text" className="form-control form-control-sm" placeholder="Account" />
                                        </div>
                                        <div className="col">
                                          <input type="text" className="form-control form-control-sm" placeholder="#" />
                                        </div>
                                        <div className="col">
                                          <button type="submit" className="btn btn-info btn-sm mb-2">Submit</button>
                                        </div>
                                      </div>
                                    </form>
                                  </div>
                                </div>
        addButtonType = <a style={{backgroundColor: '#18232E', color: 'white'}} className="btn" data-toggle="modal" href="#multiCollapseExample2" role="button" aria-expanded="false" aria-controls="multiCollapseExample1"><strong>Add Record</strong></a>
        addButtonRender = <div className="modal fade" id="multiCollapseExample2" tabIndex={-1} role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                            <div className="modal-dialog modal-dialog-centered" role="document">
                              <div className="modal-content">
                                <div className="modal-header">
                                  <h5 className="modal-title" id="exampleModalLongTitle">Error</h5>
                                  <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">×</span>
                                  </button>
                                </div>
                                <div className="modal-body">
                                  You are not authorized for this Operation!
                                </div>
                                <div className="modal-footer">
                                  <button type="button" className="btn btn" data-dismiss="modal" style={{backgroundColor: '#18232E', color: 'white'}}>Close</button>
                                </div>
                              </div>
                            </div>
                          </div>
    
    }
    else if(this.state.status === "Doctor"){
      permissionButtonType = <a style={{backgroundColor: '#18232E', color: 'white'}} className="btn" data-toggle="modal" href="#multiCollapseExample1" role="button" aria-expanded="false" aria-controls="multiCollapseExample1"><strong>Set Permission</strong></a>
      permissionButtonRender =<div className="modal fade" id="multiCollapseExample1" tabIndex={-1} role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                                <div className="modal-dialog modal-dialog-centered" role="document">
                                  <div className="modal-content">
                                    <div className="modal-header">
                                      <h5 className="modal-title" id="exampleModalLongTitle">Error</h5>
                                      <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">×</span>
                                      </button>
                                    </div>
                                    <div className="modal-body">
                                      You are not authorized for this Operation!
                                    </div>
                                    <div className="modal-footer">
                                      <button type="button" className="btn btn" data-dismiss="modal" style={{backgroundColor: '#18232E', color: 'white'}}>Close</button>
                                    </div>
                                  </div>
                                </div>
                              </div>
      addButtonType = <a style={{backgroundColor: '#18232E', color: 'white'}} className="btn" data-toggle="collapse" href="#multiCollapseExample2" role="button" aria-expanded="false" aria-controls="multiCollapseExample1"><strong>Add Record</strong></a>
      addButtonRender = <div className="collapse multi-collapse col-md-6" id="multiCollapseExample2">
                          <div className="card card-body" style={{backgroundColor: '#18232E', color: 'white'}}>
                            <form>
                              <div className="form-group">
                                <label htmlFor="doctorName"><strong>Doctor</strong></label>
                                <input type="text" className="form-control form-control-sm" id="doctorName" />
                              </div>
                              <div className="form-group">
                                <label htmlFor="hospital"><strong>Hospital</strong></label>
                                <input type="text" className="form-control form-control-sm" id="hospital" />
                              </div>
                              <div className="form-group">
                                <label htmlFor="fName"><strong>First Name</strong></label>
                                <input type="text" className="form-control form-control-sm" id="fName" />
                              </div>
                              <div className="form-group">
                                <label htmlFor="lName"><strong>Last Name</strong></label>
                                <input type="text" className="form-control form-control-sm" id="lName" />
                              </div>
                              <div className="form-group">
                                <label htmlFor="account"><strong>Account</strong></label>
                                <input type="text" className="form-control form-control-sm" id="account" />
                              </div>
                              <div className="form-group">
                                <input type="file" className="form-control-file" id="exampleFormControlFile1" onChange={this.captureFile}/>
                              </div>
                              <div className="form-group">
                                <label htmlFor="date"><strong>Date</strong></label>
                                <input className="form-control form-control-sm col-md-3" id="date" name="date" placeholder="MM/DD/YYY" type="text" />
                              </div>
                              <button type="submit" className="btn btn-info btn-sm mb-2">Submit</button>
                            </form>
                          </div>
                        </div>


    }
    else{
      return(
      <div>
        <nav className="navbar" style={{backgroundColor: '#18232E'}}>
          <a className="navbar-brand" href="#" style={{color: 'white'}}>
            <i className="fas fa-laptop-medical" />
          </a>
        </nav>
        <div className="container">
          <div className="jumbotron" style={{backgroundColor: '#18232E', color: 'white', marginTop: '1%'}}>
            <div className>
              <h1 className="display-4">Welcome to ....</h1>
              <p className="lead" />
            </div>
          </div>
          <div className="card col-md-6" style={{backgroundColor: '#18232E', color: 'white', marginLeft: '25%'}}>
            <h5 className="card-header">Sign Up</h5>
            <div className="card-body">
              <div className="input-group mb-3">
                <div className="input-group-prepend">
                  <label className="input-group-text" htmlFor="inputGroupSelect01">Options</label>
                </div>
                <select className="custom-select" id="inputGroupSelect01">
                  <option selected>Choose...</option>
                  <option value={1}>Medical Center</option>
                  <option value={2}>Individual</option>
                </select>
              </div>
              <p className="card-text">0x305F746cB05dc1393bB3e27D0054dc583400f662</p>
              <a href="#" className="btn btn-primary">Submit</a>
            </div>
          </div>
        </div>
      </div>

      );
    }

    return (
      <div>
        <nav className="navbar" style={{backgroundColor: '#18232E'}}>
          <a className="navbar-brand" href="#" style={{color: 'white'}}>
            <i className="fas fa-laptop-medical" />
          </a>
        </nav>
        <div className="container">
          <h1>Oluwafisayo Oke</h1>
          <br />
          <table className="table table-striped">
            <thead style={{backgroundColor: '#18232E', color: 'white'}}>
              <tr>
                <th scope="col">#</th>
                <th scope="col">Doctor</th>
                <th scope="col">Hospital</th>
                <th scope="col">Date</th>
                <th scope="col" />
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
                <td>Jacob Jake</td>
                <td>Emory Hospital</td>
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
            {permissionButtonType}
            <span> </span>{addButtonType}
          </p>
          {addButtonRender}
          {permissionButtonRender}
          
        </div>
      </div>
    );
  }
}

export default App;
