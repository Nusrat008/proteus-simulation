
_main:

;us_project_demo.c,17 :: 		void main()
;us_project_demo.c,21 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;us_project_demo.c,22 :: 		Lcd_Cmd(_LCD_CLEAR);          // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;us_project_demo.c,23 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);     // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;us_project_demo.c,25 :: 		TRISB = 0b00010000;           //RB4 as Input PIN (ECHO)
	MOVLW      16
	MOVWF      TRISB+0
;us_project_demo.c,27 :: 		Lcd_Out(1,1,"Developed By");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_us_project_demo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;us_project_demo.c,28 :: 		Lcd_Out(2,1,"electroSome");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_us_project_demo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;us_project_demo.c,30 :: 		Delay_ms(3000);
	MOVLW      31
	MOVWF      R11+0
	MOVLW      113
	MOVWF      R12+0
	MOVLW      30
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
;us_project_demo.c,31 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;us_project_demo.c,33 :: 		T1CON = 0x10;                 //Initialize Timer Module
	MOVLW      16
	MOVWF      T1CON+0
;us_project_demo.c,35 :: 		while(1)
L_main1:
;us_project_demo.c,37 :: 		TMR1H = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1H+0
;us_project_demo.c,38 :: 		TMR1L = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1L+0
;us_project_demo.c,40 :: 		PORTB.F0 = 1;               //TRIGGER HIGH
	BSF        PORTB+0, 0
;us_project_demo.c,41 :: 		Delay_us(10);               //10uS Delay
	MOVLW      6
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	NOP
;us_project_demo.c,42 :: 		PORTB.F0 = 0;               //TRIGGER LOW
	BCF        PORTB+0, 0
;us_project_demo.c,44 :: 		while(!PORTB.F4);           //Waiting for Echo
L_main4:
	BTFSC      PORTB+0, 4
	GOTO       L_main5
	GOTO       L_main4
L_main5:
;us_project_demo.c,45 :: 		T1CON.F0 = 1;               //Timer Starts
	BSF        T1CON+0, 0
;us_project_demo.c,46 :: 		while(PORTB.F4);            //Waiting for Echo goes LOW
L_main6:
	BTFSS      PORTB+0, 4
	GOTO       L_main7
	GOTO       L_main6
L_main7:
;us_project_demo.c,47 :: 		T1CON.F0 = 0;               //Timer Stops
	BCF        T1CON+0, 0
;us_project_demo.c,49 :: 		a = (TMR1L | (TMR1H<<8));   //Reads Timer Value
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      main_a_L0+0
	MOVF       R0+1, 0
	MOVWF      main_a_L0+1
;us_project_demo.c,50 :: 		a = a/58.82;                //Converts Time to Distance
	CALL       _int2double+0
	MOVLW      174
	MOVWF      R4+0
	MOVLW      71
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      main_a_L0+0
	MOVF       R0+1, 0
	MOVWF      main_a_L0+1
;us_project_demo.c,51 :: 		a = a + 1;                  //Distance Calibration
	MOVF       R0+0, 0
	ADDLW      1
	MOVWF      R2+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R2+1
	MOVF       R2+0, 0
	MOVWF      main_a_L0+0
	MOVF       R2+1, 0
	MOVWF      main_a_L0+1
;us_project_demo.c,52 :: 		if(a>=2 && a<=400)          //Check whether the result is valid or not
	MOVLW      128
	XORWF      R2+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main15
	MOVLW      2
	SUBWF      R2+0, 0
L__main15:
	BTFSS      STATUS+0, 0
	GOTO       L_main10
	MOVLW      128
	XORLW      1
	MOVWF      R0+0
	MOVLW      128
	XORWF      main_a_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main16
	MOVF       main_a_L0+0, 0
	SUBLW      144
L__main16:
	BTFSS      STATUS+0, 0
	GOTO       L_main10
L__main13:
;us_project_demo.c,54 :: 		IntToStr(a,txt);
	MOVF       main_a_L0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       main_a_L0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_txt_L0+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;us_project_demo.c,55 :: 		Ltrim(txt);
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
;us_project_demo.c,56 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;us_project_demo.c,57 :: 		Lcd_Out(1,1,"Distance = ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_us_project_demo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;us_project_demo.c,58 :: 		Lcd_Out(1,12,txt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;us_project_demo.c,59 :: 		Lcd_Out(1,15,"cm");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_us_project_demo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;us_project_demo.c,60 :: 		}
	GOTO       L_main11
L_main10:
;us_project_demo.c,63 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;us_project_demo.c,64 :: 		Lcd_Out(1,1,"Out of Range");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_us_project_demo+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;us_project_demo.c,65 :: 		}
L_main11:
;us_project_demo.c,66 :: 		Delay_ms(400);
	MOVLW      5
	MOVWF      R11+0
	MOVLW      15
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
;us_project_demo.c,67 :: 		}
	GOTO       L_main1
;us_project_demo.c,68 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
