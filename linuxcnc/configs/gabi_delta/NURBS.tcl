

set infile [open "/home/gabriel/linuxcnc/configs/sim.axis/NURBS_PEMC/nurbs_out.txt" r]
set number0 0
set number1 0
set number2 0
set number3 0

set number3 [net mist iocontrol.0.coolant-mist]
if {$number3 > 0} {
	while { [gets $infile line] >= 0 } {
		
		puts number0 {string range [gets $infile line] 144 167}
		puts number1 {string range [gets $infile line] 169 191}
		puts number2 {string range [gets $infile line] 193 214}
		net number0 => lcec.0.3.out2
		net number1 => lcec.0.4.out2
		net number2 => lcec.0.5.out2
	}
}
close $infile
