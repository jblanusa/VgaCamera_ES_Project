FIFO_one_clock_inst : FIFO_one_clock PORT MAP (
		clock	 => clock_sig,
		data	 => data_sig,
		rdreq	 => rdreq_sig,
		sclr	 => sclr_sig,
		wrreq	 => wrreq_sig,
		empty	 => empty_sig,
		full	 => full_sig,
		q	 => q_sig
	);
