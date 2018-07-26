#include p12f675.inc

GPIO_0 equ 0x01
GPIO_1 equ 0x02

rst	org	0x00
   goto	start

int	org	0x04
   goto	inthandle
  
intvector	org	0x08
inthandle
   banksel INTCON 
	BTFSS INTCON, GPIF ;if it is not a PORT interrupt return
   retfie
	banksel GPIO
	BTFSS GPIO, GPIO_0 ;if it is not a front signal return
	retfie

	banksel INTCON 
	BCF INTCON, GIE ;temporary disable interrupts
	
	banksel GPIO
	BSF GPIO, GPIO_1

	; active state of injector
step1
	MOVLW 0xFF
	DECFSZ W, 0x01
	GOTO step1
step2 
	MOVLW 0xFF
	DECFSZ W, 0x01
	GOTO step2

	BCF GPIO, GPIO_1

	banksel INTCON
	BCF INTCON, GPIF
	BSF INTCON, GIE
	retfie

start
   ;hardware settings
   banksel  GPIO
   clrf GPIO
   banksel  TRISIO
   movlw GPIO_0 ;set GPIO<0> as input, GPIO<1> as output
   movwf TRISIO 
   
   ;setup interrupts
   banksel  IOC   
   movlw GPIO_0
   movwf IOC    
   banksel INTCON 
   clrf INTCON
   bsf INTCON, GIE ;Enable Global Int's
   bsf INTCON, GPIE ;Port Change Interrupt Enable bit
   
   ;main loop
   goto  $
   end
