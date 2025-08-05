
//input ports
add mapped point clk clk -type PI PI
add mapped point rst_n rst_n -type PI PI
add mapped point tbl_game_start tbl_game_start -type PI PI
add mapped point tbl_game_over tbl_game_over -type PI PI
add mapped point cr_ack cr_ack -type PI PI
add mapped point cr_rdata[7] cr_rdata[7] -type PI PI
add mapped point cr_rdata[6] cr_rdata[6] -type PI PI
add mapped point cr_rdata[5] cr_rdata[5] -type PI PI
add mapped point cr_rdata[4] cr_rdata[4] -type PI PI
add mapped point cr_rdata[3] cr_rdata[3] -type PI PI
add mapped point cr_rdata[2] cr_rdata[2] -type PI PI
add mapped point cr_rdata[1] cr_rdata[1] -type PI PI
add mapped point cr_rdata[0] cr_rdata[0] -type PI PI
add mapped point cr_rdatavld cr_rdatavld -type PI PI

//output ports
add mapped point cr_cmdvld cr_cmdvld -type PO PO
add mapped point cr_cmd[2] cr_cmd[2] -type PO PO
add mapped point cr_cmd[1] cr_cmd[1] -type PO PO
add mapped point cr_cmd[0] cr_cmd[0] -type PO PO
add mapped point cr_wdata[5] cr_wdata[5] -type PO PO
add mapped point cr_wdata[4] cr_wdata[4] -type PO PO
add mapped point cr_wdata[3] cr_wdata[3] -type PO PO
add mapped point cr_wdata[2] cr_wdata[2] -type PO PO
add mapped point cr_wdata[1] cr_wdata[1] -type PO PO
add mapped point cr_wdata[0] cr_wdata[0] -type PO PO
add mapped point hand_rank_out[8] hand_rank_out[8] -type PO PO
add mapped point hand_rank_out[7] hand_rank_out[7] -type PO PO
add mapped point hand_rank_out[6] hand_rank_out[6] -type PO PO
add mapped point hand_rank_out[5] hand_rank_out[5] -type PO PO
add mapped point hand_rank_out[4] hand_rank_out[4] -type PO PO
add mapped point hand_rank_out[3] hand_rank_out[3] -type PO PO
add mapped point hand_rank_out[2] hand_rank_out[2] -type PO PO
add mapped point hand_rank_out[1] hand_rank_out[1] -type PO PO
add mapped point hand_rank_out[0] hand_rank_out[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point u_fsm/mem_we_reg/q u_fsm_mem_we_reg_reg/Q -type DFF DFF
add mapped point u_rank_eval/hand_rank_out[0]/q u_rank_eval_hand_rank_out_reg[0]/Q -type DFF DFF
add mapped point u_rank_eval/hand_rank_out[1]/q u_rank_eval_hand_rank_out_reg[1]/Q -type DFF DFF
add mapped point u_rank_eval/hand_rank_out[2]/q u_rank_eval_hand_rank_out_reg[2]/Q -type DFF DFF
add mapped point u_rank_eval/hand_rank_out[3]/q u_rank_eval_hand_rank_out_reg[3]/Q -type DFF DFF
add mapped point u_rank_eval/hand_rank_out[4]/q u_rank_eval_hand_rank_out_reg[4]/Q -type DFF DFF
add mapped point u_rank_eval/hand_rank_out[5]/q u_rank_eval_hand_rank_out_reg[5]/Q -type DFF DFF
add mapped point u_rank_eval/hand_rank_out[6]/q u_rank_eval_hand_rank_out_reg[6]/Q -type DFF DFF
add mapped point u_rank_eval/hand_rank_out[7]/q u_rank_eval_hand_rank_out_reg[7]/Q -type DFF DFF
add mapped point u_rank_eval/hand_rank_out[8]/q u_rank_eval_hand_rank_out_reg[8]/Q -type DFF DFF
add mapped point u_rank_eval/rank_done/q u_rank_eval_rank_done_reg/Q -type DFF DFF
add mapped point u_fsm/card_counter[2]/q u_fsm_card_counter_reg[2]/Q -type DFF DFF
add mapped point card_index[2]/q card_index_reg[2]/Q -type DFF DFF
add mapped point u_hand_mem/hand[3][5]/q u_hand_mem_hand_reg[3][5]/Q -type DFF DFF
add mapped point u_hand_mem/hand[3][4]/q u_hand_mem_hand_reg[3][4]/Q -type DFF DFF
add mapped point u_hand_mem/hand[3][1]/q u_hand_mem_hand_reg[3][1]/Q -type DFF DFF
add mapped point u_hand_mem/hand[3][2]/q u_hand_mem_hand_reg[3][2]/Q -type DFF DFF
add mapped point u_hand_mem/hand[3][3]/q u_hand_mem_hand_reg[3][3]/Q -type DFF DFF
add mapped point u_fsm/card_counter[1]/q u_fsm_card_counter_reg[1]/Q -type DFF DFF
add mapped point u_fsm/current_state[0]/q u_fsm_current_state_reg[0]/Q -type DFF DFF
add mapped point u_hand_mem/hand[1][3]/q u_hand_mem_hand_reg[1][3]/Q -type DFF DFF
add mapped point u_hand_mem/hand[1][5]/q u_hand_mem_hand_reg[1][5]/Q -type DFF DFF
add mapped point u_hand_mem/hand[1][4]/q u_hand_mem_hand_reg[1][4]/Q -type DFF DFF
add mapped point u_hand_mem/hand[1][1]/q u_hand_mem_hand_reg[1][1]/Q -type DFF DFF
add mapped point u_hand_mem/hand[1][2]/q u_hand_mem_hand_reg[1][2]/Q -type DFF DFF
add mapped point u_hand_mem/hand[0][1]/q u_hand_mem_hand_reg[0][1]/Q -type DFF DFF
add mapped point u_fsm/card_counter[0]/q u_fsm_card_counter_reg[0]/Q -type DFF DFF
add mapped point u_hand_mem/hand[0][4]/q u_hand_mem_hand_reg[0][4]/Q -type DFF DFF
add mapped point u_hand_mem/hand[0][3]/q u_hand_mem_hand_reg[0][3]/Q -type DFF DFF
add mapped point u_hand_mem/hand[0][2]/q u_hand_mem_hand_reg[0][2]/Q -type DFF DFF
add mapped point u_hand_mem/hand[0][5]/q u_hand_mem_hand_reg[0][5]/Q -type DFF DFF
add mapped point u_hand_mem/hand[2][5]/q u_hand_mem_hand_reg[2][5]/Q -type DFF DFF
add mapped point u_hand_mem/hand[2][4]/q u_hand_mem_hand_reg[2][4]/Q -type DFF DFF
add mapped point u_hand_mem/hand[2][1]/q u_hand_mem_hand_reg[2][1]/Q -type DFF DFF
add mapped point u_hand_mem/hand[2][2]/q u_hand_mem_hand_reg[2][2]/Q -type DFF DFF
add mapped point u_hand_mem/hand[2][3]/q u_hand_mem_hand_reg[2][3]/Q -type DFF DFF
add mapped point card_index[1]/q card_index_reg[1]/Q -type DFF DFF
add mapped point u_fsm/current_state[2]/q u_fsm_current_state_reg[2]/Q -type DFF DFF
add mapped point u_hand_mem/hand[4][2]/q u_hand_mem_hand_reg[4][2]/Q -type DFF DFF
add mapped point u_hand_mem/hand[4][1]/q u_hand_mem_hand_reg[4][1]/Q -type DFF DFF
add mapped point u_hand_mem/hand[4][4]/q u_hand_mem_hand_reg[4][4]/Q -type DFF DFF
add mapped point u_hand_mem/hand[4][3]/q u_hand_mem_hand_reg[4][3]/Q -type DFF DFF
add mapped point card_index[0]/q card_index_reg[0]/Q -type DFF DFF
add mapped point u_fsm/current_state[1]/q u_fsm_current_state_reg[1]/Q -type DFF DFF
add mapped point u_hand_mem/hand[4][5]/q u_hand_mem_hand_reg[4][5]/Q -type DFF DFF
add mapped point u_fsm/stored_card_reg[4]/q u_fsm_stored_card_reg_reg[4]/Q -type DFF DFF
add mapped point u_fsm/stored_card_reg[3]/q u_fsm_stored_card_reg_reg[3]/Q -type DFF DFF
add mapped point u_fsm/stored_card_reg[2]/q u_fsm_stored_card_reg_reg[2]/Q -type DFF DFF
add mapped point u_fsm/stored_card_reg[5]/q u_fsm_stored_card_reg_reg[5]/Q -type DFF DFF
add mapped point u_fsm/stored_card_reg[1]/q u_fsm_stored_card_reg_reg[1]/Q -type DFF DFF



//Black Boxes
add mapped point u_player_if u_player_if -type BBOX BBOX



//Empty Modules as Blackboxes
