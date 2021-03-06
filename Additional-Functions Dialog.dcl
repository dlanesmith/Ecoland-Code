PLSet : dialog {
	label = "Point and Label Settings";
	: boxed_row {
		:radio_column {
			label = "Features";
			:toggle {
				key = "f1";
				label = "Point";
			}
			: toggle {
				key = "f2";
				label = "Label";
			}
			:toggle {
				key = "f3";
				label = "Label Border";
			}
			: toggle {
				key = "f4";
				label = "Record Coordinate";
			}
		}
		:radio_column {
			label = "Options";
			:paragraph{
				:text_part{
					label = "Set as Default";
				}
			}
			: radio_button {
				key = "d1";
				label = "Yes";
			}
			: radio_button {
				key = "d2";
				label = "No";
			}
			:paragraph{}
			:paragraph{
				:text_part{
					label = "Write Custom Label";
				}
			}
			: toggle {
				label = "Toggle On";
				key = "o1";
			}
		}
	}
	
	:boxed_row {
		:edit_box {
			key = "e1";
			label = "Name this preset: ";
			edit_width = 20;
		}
	}
	ok_cancel;
	
}

PLFeat : dialog {
	label = "Point and Label Features";
	:boxed_row{
		:radio_column {
			label = "Features";
			:toggle {
				key = "f1";
				label = "Record Elevation";
			}
			: toggle {
				key = "f2";
				label = "Arrow";
			}
			:toggle {
				key = "f3";
				label = "Print Coordinate";
			}
		}
	}
	ok_cancel;
}