10 REM ****
11 REM ORIGIONAL COPYRIGHT C ANDREW COLIN 1978
20 REM SNARK SIMULATOR FOR THE IBM PC
30 REM ****
40 REM CP MARKS NEED TO RECOMPILE
50 REM EF IS NUMBER OF ERRORS IN SOURCE
60 REM GH IS SET = 1 IF "END" OBEYED
70 REM SS MARKS "SINGLE-SHOT"
80 REM OC IS CONTROL COUNTER
90 REM ****
100 DIM C$(20)
110 DIM C(10)
120 DIM T$(127)
130 DIM T(127)
140 DIM M$(16)
150 CP = 1
160 REM ****
170 REM READ MNEMONICS
180 FOR J = 0 TO 15 : READ M$(J) : NEXT
190 DATA LDA,STA,ADD,SUB,AND,ORA,JMP,BZE
200 DATA BNZ,BMI,BPL,LRS,NEG,INA,OUT,END
210 REM ****
220 REM READ CODES TO BE IGNORED
230 FOR J = 1 TO 10 : READ C(J) : NEXT J
240 DATA 18,146,141,19,147,17,145,29,157,148
250 REM ****
260 REM MAIN CONTROL POINT
270 GOSUB 3680
280 GOSUB 1030
290 REM LC IS "LIST COMMENTS"
300 IF X$ = "LC" THEN 670
310 IF X$ = "LISTALL" THEN 770
320 REM TEST FOR "LIST A - B"
330 IF LEFT$(X$,4) = "LIST" THEN 690
340 IF X$ = "RUN" THEN 450
350 IF X$ = "WIPE" THEN 850
360 IF X$ = "SAVE" THEN 1540
370 IF X$ = "LOAD" THEN 1720
380 IF X$ = "DUMP" THEN 810
390 IF X$ = "TRANSLATE" THEN 690
400 IF LEFT$(X$,2) = "PM" THEN 950
410 PRINT "DIRECTIVE NOT RECOGNISABLE"
420 GOTO 280
430 REM ****
440 REM RUN SEQUENCE
450 IF CP = 0 THEN 490
460 PRINT "TRANSLATION NEEDED." : GOSUB 2370
470 IF EF = 0 THEN PRINT "COMPILATION CORRECT" : CP = 0 : GOTO 490
480 PRINT EF ; "ERRORS IN TRANSLATION" : GOTO 170
490 INPUT "DISPLAY ON " ; Q$ : LF = 1 : SS = 0
500 IF LEFT$(Q$,1) = "N" THEN LF = 0 : GOTO 530
510 INPUT "SINGLE SHOT" ; Q$
520 IF LEFT$(Q$,1) = "Y" THEN SS = 1
530 INPUT "START ADDRESS" ; PX
540 IF PX = (-1) THEN 580
550 PC = PX
560 IF PC < 0 OR PC > 127 THEN 530
570 CLS
580 GH = 0
590 GOSUB 2640
600 IF GH = 1 THEN 280
610 IF SS = 1 THEN 640
620 Q$ = INKEY$ : IF LEN(Q$) = 0 THEN 590
630 GOTO 280
640 Q$ = INKEY$ : IF LEN(Q$) = 0 THEN 640
650 IF Q$ = "B" THEN 280
660 GOTO 590
670 GOSUB 1380 : GOTO 280
680 REM ****
690 X$ = MID$(X$,5) : GOSUB 3240 : REM GET PARAMETERS FOR LIST A-B
700 IF AB = 1 THEN 730
710 GOSUB 1460
720 GOTO 280
730 PRINT "LIST PARAMETERS WRONG"
740 GOTO 280
750 REM ****
760 REM "LISTALL"
770 GOSUB 1380 : A = 0 : B = 127 : GOSUB 1460
780 GOTO 280
790 REM ****
800 REM DUMP TO PRINTER
810 GOSUB 3540 : A = 0 : B = 127 : GOSUB 3620
820 GOTO 280
830 REM ****
840 REM "WIPE"
850 FOR J = 0 TO 20 : C$(J) = "" : NEXT J
860 FOR J = 0 TO 127 : T$(J) = "" : NEXT J
870 GOTO 280
880 REM ****
890 REM "TRANSLATE"
900 GOSUB 2370
910 IF EF = 0 THEN PRINT "COMPILATION CORRECT" : CP = 0 : GOTO 280
920 PRINT EF ; "ERRORS" : GOTO 280
930 REM ****
940 REM "PM"
950 X$ = MID$(X$,3) : GOSUB 3240
960 IF AB = 1 THEN 990
970 GOSUB 3360
980 GOTO 280
990 PRINT "POST-MORTEM PARAMETERS WRONG"
1000 GOTO 280
1010 REM ****
1020 REM READ SOURCE FROM KEYBOARD
1030 PRINT "? "; CHR$(95); : X$ = ""
1040 Y$ = INKEY$ : IF LEN(Y$) = 0 THEN 1040
1050 K = ASC(Y$)
1060 FOR J = 1 TO 10
1070 IF K = C(J) THEN 1040
1080 NEXT
1090 IF K <> 20 THEN 1120
1100 IF Y$ = "" THEN 1040
1110 X$ = MID$(X$,1,LEN(X$)-1)
1120 PRINT CHR$(29); Y$; : IF K = 13 THEN 1140
1125 PRINT CHR$(95);
1130 X$ = X$ + Y$ : GOTO 1040
1140 IF X$ = "" THEN 1030
1150 IF LEFT$(X$,1) <> "C" THEN 1220
1160 Z = VAL(MID$(X$,2))
1170 IF Z >= 0 AND Z <= 20 THEN 1200
1180 PRINT "WRONG COMMENT NUMBER .. RANGE IS 1 - 20"
1190 GOTO 1030
1200 C$(Z) = X$
1210 GOTO 1030
1220 Z$ = LEFT$(X$,1)
1230 IF ASC(Z$) > 57 OR ASC(Z$) < 48 THEN 1350
1240 Z = VAL(X$)
1250 IF Z >= 0 AND Z <= 127 THEN 1290
1260 PRINT "WRONG DESTINATION ADDRESS"
1270 PRINT "RANGE IS 0 TO 127"
1280 GOTO 1030
1290 X$ = MID$(X$,2,LEN(X$)-1)
1300 IF X$ = "" THEN 1330
1310 IF LEFT$(X$,1) = " " THEN 1290
1320 IF ASC(X$) <= 57 AND ASC(X$) >= 48 THEN 1290
1330 T$(Z) = X$ : CP =1
1340 GOTO 1030
1350 RETURN
1360 REM ****
1370 REM LIST COMMENTS
1380 FOR J = 1 TO 20
1390 IF C$(J) = "" THEN 1410
1400 PRINT C$(J)
1410 NEXT J
1420 PRINT
1430 RETURN
1440 REM ****
1450 REM LIST SOURCE TEXT
1460 FOR J = A TO B
1470 IF T$(J) = "" THEN 1490
1480 PRINT J;T$(J)
1490 NEXT J
1500 PRINT
1510 RETURN
1520 REM ****
1530 REM "DUMP"
1540 GOSUB 1910
1550 INPUT "ENTER FILE NAME : ",FS$
1560 OPEN "O",1,FS$
1570 FOR J = 1 TO 20
1580 IF C$(J) = "" THEN 1610
1590 PRINT #1,C$(J)
1600 GOTO 1620
1610 PRINT #1,"X"
1620 NEXT J
1630 FOR J = 0 TO 127
1640 IF T$(J) = "" THEN 1660
1650 PRINT #1,T$(J) : GOTO 1670
1660 PRINT #1,"X"
1670 NEXT J
1680 CLOSE 1
1690 GOTO 280
1700 REM ***
1710 REM "LOAD"
1720 GOSUB 1910
1730 INPUT "ENTER FILE NAME : ",FL$
1740 OPEN "I",1,FL$
1750 CP = 1
1760 FOR J = 1 TO 20
1770 INPUT #1,C$(J)
1780 IF C$ (J) = "X" THEN 1800
1790 PRINT C$(J) : GOTO 1810
1800 C$(J) = ""
1810 NEXT
1820 FOR J = 0 TO 127
1830 INPUT #1,T$(J)
1840 IF T$(J) = "X" THEN 1860
1850 PRINT J; T$(J) : GOTO 1870
1860 T$(J) = ""
1870 NEXT
1880 CLOSE 1
1890 GOTO 280
1900 REM ****
1910 REM "TAKEN OUT NOT A TAPE UNIT"
1920 REM ****
1930 RETURN
1940 REM ****
1950 REM COLLAPSE X$ INTO Y$
1960 Y$ = ""
1970 FOR J = 1 TO LEN(X$)
1980 Z$ = MID$(X$,J,1)
1990 IF Z$ = ";" THEN RETURN
2000 IF Z$ = " " THEN 2020
2010 Y$ = Y$ + Z$
2020 NEXT
2030 RETURN
2040 REM ****
2050 REM DECODE INSTRUCTION IN Y$
2060 E% = 0 : M% = 0 : D% = 0
2070 IF LEN(Y$) < 3 THEN E% = 1 : RETURN
2080 FOR J = 0 TO 15
2090 IF LEFT$(Y$,3) = M$(J) THEN 2120
2100 NEXT
2110 E% = 2 : RETURN
2120 F% = J
2130 Y$ = MID$(Y$,4)
2140 A% = 0
2150 IF J >= 11 AND LEN(Y$) = 0 THEN RETURN
2160 IF J <= 10 THEN 2200
2170 IF LEFT$(Y$,1) = "A" THEN RETURN
2180 IF LEFT$(Y$,1) <> "B" THEN E% = 3 : RETURN
2190 A% = 1 : RETURN
2200 REM ADDRESSED INSTRUCTION
2210 IF LEN(Y$) = 0 THEN E% = 4 : RETURN
2220 IF LEFT$(Y$,1) = "A" THEN 2250
2230 IF LEFT$(Y$,1) <> "B" THEN 2270
2240 A% = 1
2250 Y$ = MID$(Y$,2)
2260 IF LEN(Y$) = 0 THEN E% = 4 : RETURN
2270 M% = 1
2280 IF LEFT$(Y$,1) <> "#" THEN 2310
2290 M% = 0
2300 Y$ = MID$(Y$,2)
2310 D% = ASC(Y$)
2320 IF D% < 4 OR D% > 57 THEN E% = 4 : RETURN
2330 D% = VAL(Y$)
2340 IF RIGHT$(Y$,1) = "A" THEN M% = 2
2350 IF RIGHT$(Y$,1) = "B" THEN M% = 3
2360 RETURN
2370 REM INSTRUCTION TRANSLATOR
2380 EF = 0
2390 FOR H = 0 TO 127
2400 IF T$(H) = "" THEN 2600
2410 X$ = T$(H) : GOSUB 1950
2420 IF ASC(Y$) = 43 OR ASC(Y$) = 45 THEN 2570
2430 GOSUB 2050
2440 IF E% <> 0 THEN 2480
2450 T(H) = D% + 512 * M% + 2048 * A% + 4096 * F%
2460 IF T(H) > 32767 THEN T(H) = T(H) - 65536!
2470 GOTO 2600
2480 EF = EF + 1
2490 PRINT "ERROR IN LINE ";H
2500 PRINT H;T$(H)
2510 IF E% = 1 THEN PRINT "TOO SHORT" : PRINT
2520 IF E% = 2 THEN PRINT "UNKNOWN MNEMONIC" : PRINT
2530 IF E% = 3 THEN PRINT "WRONG ACCUMULATOR DESIGNATION" : PRINT
2540 IF E% = 4 THEN PRINT "ADDRESS PART MISSING" : PRINT
2550 IF E% = 5 THEN PRINT "ADDRESS OR VALUE TOO LARGE" : PRINT
2560 GOTO 2600
2570 T = VAL(Y$)
2580 IF ABS(T) > 32767 THEN E% = 5 : GOTO 2480
2590 T(H) = T
2600 NEXT H
2610 EF = 0
2620 RETURN
2630 REM ****
2640 REM SINGLE INSTRUCTION CYCLE
2650 IR = T(PC) : PC = PC + 1
2660 D = IR AND 511 : M% = (IR AND 1536) / 512
2670 A% = IR AND 2048 : F = INT(IR/4096)
2680 IF F < 0 THEN F = F + 16
2690 IF LF = 0 THEN 2770
2700 PRINT PC - 1 ; M$(F); : IF A% > 0 THEN PRINT " B"; : GOTO 2720
2710 PRINT " A ";
2720 IF F > 10 THEN PRINT "     "; : GOTO 2760
2730 IF M% = 0 THEN PRINT "#";
2740 PRINT D; : IF M% = 2 THEN PRINT "A";
2750 IF M% = 3 THEN PRINT "B";
2760 PRINT "   ",
2770 CA = A0 : IF A% = 2048 THEN CA = A1
2780 IF F > 7 THEN 2800
2790 ON F + 1 GOTO 2820,2810,2830,2840,2850,2860,2870,2880
2800 ON F - 7 GOTO 2900,2920,2940,2960,2970,2990,3010,3020
2810 GOSUB 3120 : T(D) = CA : GOTO 3070
2820 GOSUB 3180 : CA = D : GOTO 3030
2830 GOSUB 3180 : CA = CA + D : GOTO 3030
2840 GOSUB 3180 : CA = CA - D : GOTO 3030
2850 GOSUB 3180 : CA = CA AND D : GOTO 3030
2860 GOSUB 3180 : CA = CA OR D : GOTO 3030
2870 GOSUB 3120 : PC = D : GOTO 3070
2880 GOSUB 3120 : IF CA = 0 THEN PC = D
2890 GOTO 3070
2900 GOSUB 3120 : IF CA <> 0 THEN PC = D
2910 GOTO 3070
2920 GOSUB 3120 : IF CA < 0 THEN PC = D
2930 GOTO 3070
2940 GOSUB 3120 : IF CA > 0 THEN PC = D
2950 GOTO 3070
2960 CA = INT(CA * .5) : GOTO 3030
2970 CA = -CA : GOTO 3030
2980 PRINT "                           ";
2990 PRINT : PRINT
3000 INPUT "INPUT : ";CA : PRINT "                            "; : GOTO 3030
3010 PRINT "OUTPUT IS "; CA : RETURN
3020 GH = 1 : GOTO 3070
3030 IF CA > 32767 THEN CA = CA - 65536! : GOTO 3030
3040 IF CA < -32768! THEN CA = CA + 65536! : GOTO 3040
3050 IF A% = 0 THEN A0 = CA : GOTO 3070
3060 A1 = CA
3070 IF LF = 0 THEN RETURN
3080 PRINT "A = "; A0, "B = "; A1
3090 RETURN
3100 REM ****
3110 REM GET ADDRESS OF OPERAND
3120 IF M% = 2 THEN D = D + A0
3130 IF M% = 3 THEN D = D + A1
3140 IF D > 0 AND D < 128 THEN RETURN
3150 PRINT "ADDRESS VIOLATION IN LINE "; PC - 1 : D = 127 : GH = 1 : RETURN
3160 REM ****
3170 REM GET OPERAND
3180 IF M% = 2 THEN D = D + A0
3190 IF M% = 3 THEN D = D + A1
3200 IF M% = 0 THEN RETURN
3210 IF D > 0 AND D < 128 THEN D = T(D) : RETURN
3220 GOTO 3150
3230 REM ****
3240 REM GET PARAMETERS FOR LIST OR PM
3250 Y$ = X$ : AB = 0
3260 IF Y$ = "" THEN RETURN
3270 Y$ = MID$(Y$,2)
3280 IF Y$ = "" THEN RETURN
3290 IF ASC(Y$) <> 45 THEN 3260
3300 Y$ = MID$(Y$,2)
3310 A = VAL(X$) : B = VAL(Y$) : IF A < 0 OR A > 127 THEN RETURN
3320 IF B < 0 OR B > 127 THEN RETURN
3330 IF B < A THEN RETURN
3340 AB = 0 : RETURN
3350 REM ****
3360 REM INSTRUCTION CODE AND LISTING
3370 FOR J = A TO B
3380 PRINT J; : IR = T(J) : D% = IR AND 511
3390 M% = (IR AND 1536) / 512 : A% = IR AND 2048
3400 F% = IR / 4096
3410 IF F% < 0 THEN F% = F% + 16
3420 PRINT M$(F%);
3430 IF A% > 0 THEN PRINT " B"; : GOTO 3450
3440 PRINT " A";
3450 IF F% > 10 THEN PRINT "  ", : GOTO 3490
3460 IF M% = 0 THEN PRINT "#";
3470 PRINT D%; : IF M% = 2 THEN PRINT "A";
3480 IF M% = 3 THEN PRINT "B";
3490 PRINT " ",IR
3500 NEXT J
3510 RETURN
3520 REM ****
3530 PRINT COMMENTS
3540 FOR J = 1 TO 20
3550 IF C$(J) = "" THEN 3570
3560 LPRINT C$(J)
3570 NEXT J
3580 LPRINT
3590 RETURN
3600 REM ****
3610 REM PRINT SOURCE TEXT
3620 FOR J = A TO B
3630 IF T$(J) = "" THEN 3650
3640 LPRINT J;T$(J)
3650 NEXT J
3660 LPRINT
3670 RETURN
3680 REM ****
3690 REM DISPLAY SCREEN WITH INSTRUCTIONS
3700 KEY OFF
3710 CLS
3720 KEY 1,"SAVE"+CHR$(13)
3730 KEY 2,"LOAD"+CHR$(13)
3740 KEY 3,"DUMP"+CHR$(13)
3750 KEY 4,"WIPE"+CHR$(13)
3760 KEY 5,"LISTALL"+CHR$(13)
3770 KEY 6,"LC"+CHR$(13)
3780 KEY 7,"LIST "
3790 KEY 8,"RUN"+CHR$(13)
3820 KEY 9,""
3830 KEY 10,""
3840 KEY ON
3850 PRINT:PRINT
3860 PRINT "                       SNARK ASSEMBLER"
3870 PRINT "                      ~~~~~~~~~~~~~~~~~"
3880 PRINT:PRINT
3890 PRINT "    SAVE     : Save Assembler Program To Disk"
3900 PRINT "    LOAD     : Load Assembler Program From Disk"
3910 PRINT "    DUMP     : List Assembler Program To Printer"
3920 PRINT "    WIPE     : Clear Assembler Program From Memory"
3930 PRINT "    LISTALL  : List Assembler Program To Screen"
3940 PRINT "    LC       : List All Comment Lines"
3950 PRINT "    LIST n-m : List Assemler Program Lines n To m Inclusive"
3960 PRINT "    RUN      : Run Assembler Program In Memory"
3970 PRINT "    PM n-m   : Display Contents Of Registers n To m"
3980 PRINT:PRINT
3990 RETURN
4000 REM ****
4010 REM PRINTABLE RUN
4020 IR = T(PC) : PC = PC + 1
4030 D = IR AND 511
4040 D = IR AND 511 : M% = (IR AND 1536) / 512
4050 A% = IR AND 2048 : F = INT(IR/4096)
4060 IF F < 0 THEN F = F + 16
4070 IF LF = 0 THEN 4150
4080 PRINT PC - 1 ; M$(F); : IF A% > 0 THEN PRINT " B"; : GOTO 4100
4090 PRINT " A ";
4100 IF F > 10 THEN PRINT "     "; : GOTO 4140
4110 IF M% = 0 THEN PRINT "#";
4120 PRINT D; : IF M% = 2 THEN PRINT "A";
4130 IF M% = 3 THEN PRINT "B";
4140 PRINT "   ",
4150 CA = A0 : IF A% = 2048 THEN CA = A1
4160 IF F > 7 THEN 4180
4170 ON F + 1 GOTO 4200,4190,4210,4220,4230,4240,4250,4260
4180 ON F - 7 GOTO 4280,4300,4320,4340,4350,6360,4370,6380
4190 GOSUB 3120 : T(D) = CA : GOTO 4440
4200 GOSUB 3180 : CA = D : GOTO 4400
4210 GOSUB 3180 : CA = CA + D : GOTO 4400
4220 GOSUB 3180 : CA = CA - D : GOTO 4400
4230 GOSUB 3180 : CA = CA AND D : GOTO 4400
4240 GOSUB 3180 : CA = CA OR D : GOTO 4400
4250 GOSUB 3120 : PC = D : GOTO 4440
4260 GOSUB 3120 : IF CA = 0 THEN PC = D
4270 GOTO 4440
4280 GOSUB 6500 : IF CA <> 0 THEN PC = D
4290 GOTO 4440
4300 GOSUB 6500 : IF CA < 0 THEN PC = D
4310 GOTO 4440
4320 GOSUB 6500 : IF CA > 0 THEN PC = D
4330 GOTO 4440
4340 CA = INT(CA * .5) : GOTO 4400
4350 CA = -CA : GOTO 4400
4360 PRINT "                           ";
4370 PRINT
4380 PRINT "OUTPUT IS "; CA : RETURN
4390 GH = 1 : GOTO 3070
4400 IF CA > 32767 THEN CA = CA - 65536! : GOTO 3030
4410 IF CA < -32768! THEN CA = CA + 65536! : GOTO 3040
4420 IF A% = 0 THEN A0 = CA : GOTO 3070
4430 A1 = CA
4440 IF LF = 0 THEN RETURN
4450 PRINT "A = "; A0, "B = "; A1
4460 RETURN
