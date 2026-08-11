module Sign_Extend (In,ImmSrc,Imm_Ext);
    input [31:0] In;
    input [1:0] ImmSrc;
    output [31:0] Imm_Ext;

assign Imm_Ext = (ImmSrc == 2'b00) ? {{20{In[31]}}, In[31:20]} : 
                 (ImmSrc == 2'b01) ? {{20{In[31]}}, In[31:25], In[11:7]} :
                 (ImmSrc == 2'b10) ? {{19{In[31]}}, In[31], In[7], In[30:25], In[11:8], 1'b0} :
                 32'h00000000;

endmodule
