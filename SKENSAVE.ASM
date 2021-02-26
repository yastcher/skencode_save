	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
	endif
	?debug	V 300h
	?debug	S "SKENSAVE.CPP"
	?debug	C E93C6439280C534B454E534156452E435050
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
	?debug	C E8010C534B454E534156452E4350503C643928
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
   ;	if (Curr_Key == 0x1000)
   ;	
	?debug	L 33
	cmp	word ptr DGROUP:_Curr_Key,4096
	jne	short @1@86
   ;	
   ;	   {
   ;	   setvect(INTR, Old_9h);          //Alt-Q выход
   ;	
	?debug	L 35
	push	word ptr DGROUP:_Old_9h+2
	push	word ptr DGROUP:_Old_9h
	mov	ax,9
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;	   setvect(INTR, Old_8h);
   ;	
	?debug	L 36
	push	word ptr DGROUP:_Old_8h+2
	push	word ptr DGROUP:_Old_8h
	mov	ax,9
	push	ax
	call	near ptr _setvect
	add	sp,6
   ;	
   ;	   exit(0);		//Выходит сразу из Nortona. Это удобно.
   ;	
	?debug	L 37
	xor	ax,ax
	push	ax
	call	near ptr _exit
	pop	cx
@1@86:
   ;	
   ;	   }
   ;	
   ;	addstr[0]=(char)(Curr_Key/(256*16));
   ;	
	?debug	L 40
	mov	ax,word ptr DGROUP:_Curr_Key
	mov	cl,12
	shr	ax,cl
	mov	byte ptr DGROUP:_addstr,al
   ;	
   ;	addstr[1]=(char)((Curr_Key - addstr[0]*256*16)/256);
   ;	
	?debug	L 41
	mov	al,byte ptr DGROUP:_addstr
	cbw	
	mov	cl,8
	shl	ax,cl
	mov	cl,4
	shl	ax,cl
	mov	dx,word ptr DGROUP:_Curr_Key
	sub	dx,ax
	mov	cl,8
	shr	dx,cl
	mov	byte ptr DGROUP:_addstr+1,dl
   ;	
   ;	addstr[2]=(char)((Curr_Key - addstr[0]*256*16-addstr[1]*256)/16);
   ;	
	?debug	L 42
	mov	al,byte ptr DGROUP:_addstr
	cbw	
	mov	cl,8
	shl	ax,cl
	mov	cl,4
	shl	ax,cl
	mov	dx,word ptr DGROUP:_Curr_Key
	sub	dx,ax
	mov	al,byte ptr DGROUP:_addstr+1
	cbw	
	mov	cl,8
	shl	ax,cl
	sub	dx,ax
	mov	cl,4
	shr	dx,cl
	mov	byte ptr DGROUP:_addstr+2,dl
   ;	
   ;	addstr[3]=(char)Curr_Key - addstr[0]*256*16-addstr[1]*256-addstr[2]*16;
   ;	
	?debug	L 43
	mov	al,byte ptr DGROUP:_addstr
	mov	cl,8
	shl	al,cl
	mov	cl,4
	shl	al,cl
	mov	dl,byte ptr DGROUP:_Curr_Key
	sub	dl,al
	mov	al,byte ptr DGROUP:_addstr+1
	mov	cl,8
	shl	al,cl
	sub	dl,al
	mov	al,byte ptr DGROUP:_addstr+2
	mov	cl,4
	shl	al,cl
	sub	dl,al
	mov	byte ptr DGROUP:_addstr+3,dl
   ;	
   ;	addstr[4]=' ';
   ;	
	?debug	L 44
	mov	byte ptr DGROUP:_addstr+4,32
   ;	
   ;	addstr[5]=0;
   ;	
	?debug	L 45
	mov	byte ptr DGROUP:_addstr+5,0
   ;	
   ;	for (int i=0; i<4; i++)
   ;	
	?debug	L 46
	mov	word ptr [bp-2],0
	jmp	short @1@254
@1@114:
   ;	
   ;	    {
   ;	    if (addstr[i] > 9)
   ;	
	?debug	L 48
	mov	bx,word ptr [bp-2]
	cmp	byte ptr DGROUP:_addstr[bx],9
	jle	short @1@170
   ;	
   ;	       addstr[i] += 55;
   ;	
	?debug	L 49
	mov	bx,word ptr [bp-2]
	mov	al,byte ptr DGROUP:_addstr[bx]
	add	al,55
	jmp	short @1@198
@1@170:
   ;	
   ;	    else addstr[i] += 48;
   ;	
	?debug	L 50
	mov	bx,word ptr [bp-2]
	mov	al,byte ptr DGROUP:_addstr[bx]
	add	al,48
@1@198:
	mov	bx,word ptr [bp-2]
	mov	byte ptr DGROUP:_addstr[bx],al
	?debug	L 46
	inc	word ptr [bp-2]
@1@254:
	cmp	word ptr [bp-2],4
	jl	short @1@114
   ;	
   ;	    }
   ;	//   len_this=strlen(addstr);
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
	?debug	L 61
 	mov	 AH, 03DH                  
   ;	
   ;	asm mov AL, 1
   ;	
	?debug	L 62
 	mov	 AL, 1
   ;	
   ;	asm mov DX, offset filename
   ;	
	?debug	L 63
 	mov	 DX, offset DGROUP:_filename
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 64
 	int	 021H
   ;	
   ;	asm mov handle, AX
   ;	
	?debug	L 65
 	mov	 DGROUP:_handle, AX
   ;	
   ;	
   ;	asm mov AH, 0x42
   ;	
	?debug	L 67
 	mov	 AH, 042H
   ;	
   ;	asm mov AL, 2
   ;	
	?debug	L 68
 	mov	 AL, 2
   ;	
   ;	asm mov BX, handle
   ;	
	?debug	L 69
 	mov	 BX, DGROUP:_handle
   ;	
   ;	asm mov CX, 0
   ;	
	?debug	L 70
 	mov	 CX, 0
   ;	
   ;	asm mov DX, 0
   ;	
	?debug	L 71
 	mov	 DX, 0
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 72
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
	?debug	L 80
 	mov	 AH, 040H
   ;	
   ;	asm mov BX, handle
   ;	
	?debug	L 81
 	mov	 BX, DGROUP:_handle
   ;	
   ;	asm mov CX, 5              //len_this
   ;	
	?debug	L 82
 	mov	 CX, 5              
   ;	
   ;	asm mov DX, offset addstr
   ;	
	?debug	L 83
 	mov	 DX, offset DGROUP:_addstr
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 84
 	int	 021H
   ;	
   ;	
   ;	asm mov AH, 0x3E
   ;	
	?debug	L 86
 	mov	 AH, 03EH
   ;	
   ;	asm mov BX, handle
   ;	
	?debug	L 87
 	mov	 BX, DGROUP:_handle
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 88
 	int	 021H
   ;	
   ;	
   ;	/*asm pop BX
   ;	asm mov AH, 50
   ;	asm int 0x21*/
   ;	
   ;	NotWriteThis:
   ;	return;
   ;	
	?debug	L 95
	jmp	short @1@842
@1@842:
   ;	
   ;	}
   ;	
	?debug	L 96
	mov	sp,bp
	pop	bp
	ret	
	?debug	C E601690402FEFF00
	?debug	E
	?debug	E
@addtofile$qv	endp
   ;	
   ;	void interrupt New_8h(__CPPARGS)
   ;	
	?debug	L 98
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
	?debug	L 100
	pushf	
	call	dword ptr DGROUP:_Old_8h
   ;	
   ;	
   ;	asm mov AX, 0xB800          //Индикатор работы
   ;	
	?debug	L 102
 	mov	 AX, 0B800H          
   ;	
   ;	asm mov ES, AX
   ;	
	?debug	L 103
 	mov	 ES, AX
   ;	
   ;	asm mov AX, word ptr DS:NotWrited
   ;	
	?debug	L 104
 	mov	 AX, word ptr DS:DGROUP:_NotWrited
   ;	
   ;	asm mov ES:[0x00], AX
   ;	
	?debug	L 105
 	mov	 ES:[000H], AX
   ;	
   ;	
   ;	if (NotWrited)
   ;	
	?debug	L 107
	cmp	byte ptr DGROUP:_NotWrited,0
	je	short @2@254
   ;	
   ;	   {
   ;	   if (peekb((unsigned int)(in_dos/65536), in_dos-((unsigned int)(in_dos/65536))*65536)==0)
   ;	
	?debug	L 109
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
	?debug	L 111
	mov	al,byte ptr DGROUP:_NotWrited
	mov	ah,0
	shl	ax,1
	mov	bx,ax
	mov	ax,word ptr DGROUP:_Last_Key[bx]
	mov	word ptr DGROUP:_Curr_Key_for8,ax
   ;	
   ;	      addtofile();
   ;	
	?debug	L 112
	call	near ptr @addtofile$qv
   ;	
   ;	      NotWrited--;
   ;	
	?debug	L 113
	dec	byte ptr DGROUP:_NotWrited
@2@254:
   ;	
   ;	      }
   ;	   }
   ;	}
   ;	
	?debug	L 116
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
	?debug	L 118
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
	?debug	L 120
	pushf	
	call	dword ptr DGROUP:_Old_9h
   ;	
   ;	
   ;	asm mov AX, 0xB800          //Индикатор работы
   ;	
	?debug	L 122
 	mov	 AX, 0B800H          
   ;	
   ;	asm mov ES, AX
   ;	
	?debug	L 123
 	mov	 ES, AX
   ;	
   ;	asm mov AX, word ptr DS:NotWrited
   ;	
	?debug	L 124
 	mov	 AX, word ptr DS:DGROUP:_NotWrited
   ;	
   ;	asm mov ES:[0x02], AX
   ;	
	?debug	L 125
 	mov	 ES:[002H], AX
   ;	
   ;	
   ;	asm mov AX, 0x0040          //Переслать в AX последний символ из буфера
   ;	
	?debug	L 127
 	mov	 AX, 00040H          
   ;	
   ;	asm mov ES, AX
   ;	
	?debug	L 128
 	mov	 ES, AX
   ;	
   ;	asm mov BX, ES:0x1A
   ;	
	?debug	L 129
 	mov	 BX, ES:01AH
   ;	
   ;	asm mov AX, ES:[BX]
   ;	
	?debug	L 130
 	mov	 AX, ES:[BX]
   ;	
   ;	
   ;	Curr_Key_for9=_AX;
   ;	
	?debug	L 132
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
	?debug	L 140
	inc	byte ptr DGROUP:_NotWrited
   ;	
   ;	if (NotWrited >= 254)              //сброс буфера при переполнении
   ;	
	?debug	L 141
	cmp	byte ptr DGROUP:_NotWrited,254
	jb	short @3@338
   ;	
   ;	   {
   ;	   NotWrited=1;
   ;	
	?debug	L 143
	mov	byte ptr DGROUP:_NotWrited,1
@3@338:
   ;	
   ;	   }
   ;	
   ;	for (int i=NotWrited;i>1;i--)
   ;	
	?debug	L 146
	mov	al,byte ptr DGROUP:_NotWrited
	mov	ah,0
	mov	word ptr [bp-2],ax
	jmp	short @3@422
@3@366:
   ;	
   ;	    {
   ;	    Last_Key[i]=Last_Key[i-1];
   ;	
	?debug	L 148
	mov	bx,word ptr [bp-2]
	shl	bx,1
	mov	ax,word ptr DGROUP:_Last_Key[bx-2]
	mov	bx,word ptr [bp-2]
	shl	bx,1
	mov	word ptr DGROUP:_Last_Key[bx],ax
	?debug	L 146
	dec	word ptr [bp-2]
@3@422:
	cmp	word ptr [bp-2],1
	jg	short @3@366
   ;	
   ;	    }
   ;	Last_Key[1]=Curr_Key_for9;
   ;	
	?debug	L 150
	mov	ax,word ptr DGROUP:_Curr_Key_for9
	mov	word ptr DGROUP:_Last_Key+2,ax
   ;	
   ;	//ToHome:
   ;	}
   ;	
	?debug	L 152
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
	?debug	L 154
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
	?debug	L 167
 	mov	 AH, 034H                 
   ;	
   ;	asm int 0x21
   ;	
	?debug	L 168
 	int	 021H
   ;	
   ;	asm mov word ptr DS:in_dos, BX
   ;	
	?debug	L 169
 	mov	 word ptr DS:DGROUP:_in_dos, BX
   ;	
   ;	asm mov word ptr DS:in_dos+2, ES
   ;	
	?debug	L 170
 	mov	 word ptr DS:DGROUP:_in_dos+2, ES
   ;	
   ;	
   ;	Old_8h=getvect(INTR);            //Поменяем 8-ое и 9-ое прерывание на свои
   ;	
	?debug	L 172
	mov	ax,9
	push	ax
	call	near ptr _getvect
	pop	cx
	mov	word ptr DGROUP:_Old_8h+2,dx
	mov	word ptr DGROUP:_Old_8h,ax
   ;	
   ;	setvect(INTR, New_8h);
   ;	
	?debug	L 173
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
	?debug	L 175
	mov	ax,9
	push	ax
	call	near ptr _getvect
	pop	cx
	mov	word ptr DGROUP:_Old_9h+2,dx
	mov	word ptr DGROUP:_Old_9h,ax
   ;	
   ;	setvect(INTR, New_9h);
   ;	
	?debug	L 176
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
	?debug	L 178
	mov	ax,offset DGROUP:s@
	push	ax
	call	near ptr _printf
	pop	cx
   ;	
   ;	
   ;	keep(0, _SS + (_SP/16) - _psp);
   ;	
	?debug	L 180
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
	?debug	L 181
	xor	ax,ax
	jmp	short @4@170
@4@170:
   ;	
   ;	}
   ;	
	?debug	L 182
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
	?debug	C E35400000023040001
	?debug	C EB075F7072696E74665400
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