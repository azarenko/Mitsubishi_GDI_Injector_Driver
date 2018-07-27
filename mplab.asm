#include p12f675.inc

CNT1 equ 0x20
CNT2 equ 0x21

rst	org	0x00

	goto	start

int	org	0x04
	retfie
  
start org 0x20
	;hardware settings
    banksel ANSEL
	movlw 00h 
	movwf ANSEL

	banksel ADCON0
	movlw 00h 
	movwf ADCON0

	banksel CMCON
	movlw 07h 
	movwf CMCON

	banksel VRCON
	movlw 00h 
	movwf VRCON    

	banksel TRISIO
	movlw 01h ;set GPIO<0> as input, all others as ouptut
	movwf TRISIO

	banksel GPIO
	clrf GPIO

begin   
	banksel  GPIO
	BTFSC GPIO, 00h ;if it is not a front signal return
	goto begin
	
	banksel GPIO
	BSF GPIO, 01h

	MOVLW 0x05
	movwf CNT1

first_counter
	DECFSZ CNT1, 1
	GOTO second_counter
	GOTO end_of_pulse    

second_counter
	MOVLW 0x0A
	movwf CNT2
	DECFSZ CNT2, 1
	GOTO $ - 1
	GOTO first_counter

end_of_pulse
	BCF GPIO, 01h

	;pause
	MOVLW 0x01
	movwf CNT1

pause_first_counter
	DECFSZ CNT1, 1
	GOTO pause_second_counter
	GOTO begin

pause_second_counter
	MOVLW 0x01
	movwf CNT2
	DECFSZ CNT2, 1
	GOTO $ - 1
	GOTO pause_first_counter

	goto begin
	end
