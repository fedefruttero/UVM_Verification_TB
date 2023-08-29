// ----------------------------------------------------------------------------
// Title: RF Data Transaction
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This file defines a UVM transaction class for the Register File (RF) data. 
// It includes data fields for address, data, and port. The class provides functions for 
// string conversion, deep copying, comparison, and loading data into a transaction.
// ----------------------------------------------------------------------------

// Import the package containing generic definitions
import generic_pkg::*;

// Definition of the RF Data Transaction class
class rf_data extends uvm_sequence_item;
    `uvm_object_utils(rf_data)

    // Transaction fields
    rand logic[NBITS-1:0]     data;  // Data value to be transferred
    rand logic[ADDR_SIZE-1:0] addr;  // Address for the RF operation
    rand logic                port;  // Port identifier for the RF operation

    // Constructor for initializing the transaction
    function new(string name = "");
        super.new(name);
    endfunction : new

    // Convert transaction to a human-readable string
    function string convert2string();
        return $sformatf("addr: %h data (port %d): %h", addr, port, data);
    endfunction : convert2string

    // Deep copy implementation for creating a copy of the transaction
    function void do_copy(uvm_object rhs);
        rf_data RHS;
        super.do_copy(rhs);  // Call the base class copy function
        $cast(RHS, rhs);     // Cast the incoming object to rf_data
        data = RHS.data;     // Copy the data field
        addr = RHS.addr;     // Copy the address field
        port = RHS.port;     // Copy the port field
    endfunction : do_copy

    // Compare transactions for equality
    function bit comp(uvm_object rhs);
        rf_data RHS;
        $cast(RHS, rhs);  // Cast the incoming object to rf_data
        return (RHS.addr == addr) && (RHS.data == data) && (RHS.port == port);
    endfunction : comp

    // Load data into a transaction for simulation
    function void load_data(logic[ADDR_SIZE-1:0] a, logic[NBITS-1:0] d, logic p);
        addr = a;  // Set the address field
        data = d;  // Set the data field
        port = p;  // Set the port field
    endfunction : load_data

endclass : rf_data
