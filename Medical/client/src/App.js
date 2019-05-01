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
      firstName: null,
      lastName: null,
      doctorName: null,
      hospitalName: null,
      toAccount: null,
      date: null,
      ipfsHash: '',
      web3: null,
      buffer: null,
      account: null,
      records: [],
      status: "Medical Center"

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
      simpleStorage.deployed()
      .then((instance) => {
        this.simpleStorageInstance = instance
        this.setState({account : account})
        console.log(this.simpleStorageInstance)
        // Get the value from the contract to prove it worked.
          return this.simpleStorageInstance.getRecords(account, {from: account})
       }).then((records) => {
      //   // Update state with the result.
         return this.setState({ records })
      })
    })
  }
  handleInputChange = (event) => {
    event.preventDefault()
    //console.log(event.target.name + " " + event.target.value)
    this.setState({[event.target.name]: event.target.value})
    //console.log(event.target.name + " " + this.state.firstName)
  }

  captureFile = (event) => {
    event.preventDefault()
    const file = event.target.files[0]
    const reader = new window.FileReader()
    reader.readAsArrayBuffer(file)
    reader.onloadend = () => {
      this.setState({ buffer: Buffer(reader.result) })
     console.log('buffer', this.state.buffer)
    // console.log("captured file")
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
        console.log('ifpsHash', this.state.ipfsHash)
      })
    })


    console.log(this.state.firstName + this.state.lastName + this.state.doctorName + this.state.hospitalName +this.state.date)
  }

  patientCreateTableHeader = ()=>{
    let tableHeader = []
    tableHeader.push(<th scope="col">#</th>)
    tableHeader.push(<th scope="col">Doctor</th>)
    tableHeader.push(<th scope="col">Hospital</th>)
    tableHeader.push(<th scope="col">Date</th>)
    tableHeader.push(<th scope="col" />)

    return <tr>{tableHeader}</tr>
  }

  patientCreateTableBody = ()=>{
    let tableBody = []

    for(let i=0; i<this.state.records.length;i++){
      let children = []

      children.push(<th scope="row">{this.state.records[i][0]}</th>)
      children.push(<td>{this.state.records[i][3]}</td>)
      children.push(<td>{this.state.records[i][4]}</td>)
      children.push(<td>{this.state.records[i][5]}</td>)
      children.push(<td><a className="btn btn-success btn-sm" href={`https://ipfs.io/ipfs/${this.state.records[i][6]}`} role="button">View</a></td>)

      tableBody.push(<tr>{children}</tr>)
    }
    return tableBody
    
  }

  doctorCreateTableHeader = ()=>{
    let tableHeader = []
    tableHeader.push(<th scope="col">#</th>)
    tableHeader.push(<th scope="col">First Name</th>)
    tableHeader.push(<th scope="col">Last Name</th>)
    tableHeader.push(<th scope="col">Doctor</th>)
    tableHeader.push(<th scope="col">Hospital</th>)
    tableHeader.push(<th scope="col">Date</th>)
    tableHeader.push(<th scope="col" />)

    return <tr>{tableHeader}</tr>
  }

  doctorCreateTableBody = ()=>{
    let tableBody = []

    for(let i=0; i<this.state.records.length;i++){
      let children = []

      children.push(<th scope="row">{this.state.records[i][0]}</th>)
      children.push(<td>{this.state.records[i][1]}</td>)
      children.push(<td>{this.state.records[i][2]}</td>)
      children.push(<td>{this.state.records[i][3]}</td>)
      children.push(<td>{this.state.records[i][4]}</td>)
      children.push(<td>{this.state.records[i][5]}</td>)
      children.push(<td><a className="btn btn-success btn-sm" href={`https://ipfs.io/ipfs/${this.state.records[i][6]}`} role="button">View</a></td>)

      tableBody.push(<tr>{children}</tr>)
    }

    return tableBody
    
  }

  userPageName = ()=>{
    if(this.state.records.length > 0 && this.state.status === "Individual"){
      return <h1>{this.state.records[0][1]} {this.state.records[0][2]} </h1>
   }
   else if(this.state.records.length > 0 && this.state.status === "Medical Center"){
      return <h1>{this.state.records[0][4]}</h1>
   }
    else{
      return <h1>User</h1>
    }
  }




  render() {
    let permissionButtonType;
    let permissionButtonRender;
    let addButtonType;
    let addButtonRender;
    let tableHeader;
    let tableBody;
    let pageName;

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
        tableHeader = this.patientCreateTableHeader()
        tableBody = this.patientCreateTableBody()
        pageName =  this.userPageName()

    
    }
    else if(this.state.status === "Medical Center"){
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
                            <form onSubmit={this.onSubmit}>
                              <div className="form-group">
                                <label htmlFor="doctorName"><strong>Doctor</strong></label>
                                <input type="text" className="form-control form-control-sm" id="doctorName" name="doctorName" onChange = {this.handleInputChange}/>
                              </div>
                              <div className="form-group">
                                <label htmlFor="hospital"><strong>Hospital</strong></label>
                                <input type="text" className="form-control form-control-sm" id="hospital" name="hospitalName" onChange = {this.handleInputChange}/>
                              </div>
                              <div className="form-group">
                                <label htmlFor="fName"><strong>First Name</strong></label>
                                <input type="text" className="form-control form-control-sm" id="fName" name="firstName" onChange = {this.handleInputChange} />
                              </div>
                              <div className="form-group">
                                <label htmlFor="lName"><strong>Last Name</strong></label>
                                <input type="text" className="form-control form-control-sm" id="lName" name="lastName" onChange = {this.handleInputChange}/>
                              </div>
                              <div className="form-group">
                                <label htmlFor="account"><strong>Account</strong></label>
                                <input type="text" className="form-control form-control-sm" id="account" name="toAccount" onChange = {this.handleInputChange}/>
                              </div>
                              <div className="form-group">
                                <input type="file" className="form-control-file" id="exampleFormControlFile1" onChange={this.captureFile}/>
                              </div>
                              <div className="form-group">
                                <label htmlFor="date"><strong>Date</strong></label>
                                <input className="form-control form-control-sm col-md-3" id="date" type="text" name="date" onChange = {this.handleInputChange}/>
                              </div>

                              

                        
                              <button type="submit" className="btn btn-info btn-sm mb-2">Submit</button>
                            </form>
                          </div>
                        </div>

      tableHeader = this.doctorCreateTableHeader()
      tableBody = this.doctorCreateTableBody()
      pageName = this.userPageName()



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
              <h1 className="display-4">Welcome</h1>
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
              <p className="card-text">{this.state.account}</p>
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

          {pageName}
          <br />
          <table className="table table-striped">
            <thead style={{backgroundColor: '#18232E', color: 'white'}}>
              {tableHeader}
            </thead>
            <tbody>
              {tableBody}
            </tbody>
          </table>
          <hr />
          <p id="accountAddress" className="text-center">{this.state.account}</p>
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
