module FA_data_flow
(
  input  wire A, 
  input  wire B,
  input  wire Cin,
  
  output wire sum,
  output wire cout
);

  assign {cout, sum} = A + B + Cin;  
  
endmodule