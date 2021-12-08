.386 
.model flat, stdcall 
option casemap :none 
 
include includes\windows.inc 
include includes\masm32.inc 
 
include includes\user32.inc 
include includes\kernel32.inc 
include includes\macros\macros.asm 
include includes\msvcrt.inc 
 
includelib includes\masm32.lib 
includelib includes\user32.lib 
includelib includes\kernel32.lib 
includelib includes\msvcrt.lib 
 
 
.data 
 stdOut dd ? 
 stdIn dd ? 
 
 buf db 1 dup (?) 
 
 num dd ? 
 numWr dd ? 
 
 msg0 db "Pls, enter your number: " 
 msg1 db "Pls, enter onli bin number with 8 lenght and restart your program. " 
 msg2 db "Entered Num: " 
 msg3 db "Number inside out: " 
 msg4 db "Number after division by 16: " 
 msg1310 db 13, 10 ; перевод строки 
 
 myNum dw ? ; значение в регситре ax 
 myNum2 db ? ;копии значений в AL 
 myNum3 db ? 
 newNum db ? 
 div16Num db ? 
 forChange db ? 
 forChange2 db ? 
 
 zn dw ? 
 
 printNumber db ? 
 
 zeroPrt db '0' 
 bitPrt db '1' 
 
.code 
start: 
 
 invoke AllocConsole ; запрашиваем у Windows консоль 
 invoke GetStdHandle, STD_INPUT_HANDLE ; получаем хэндл консоли для вывода 
 mov stdIn, EAX ; переписываем его 
 invoke GetStdHandle, STD_OUTPUT_HANDLE ; получаем хэндл консоли для вывода 
 mov stdOut, EAX ; переписываем его 
 
 invoke WriteConsole,stdOut, addr msg0, SIZEOF msg0, ADDR numWr,0 
;подготовка цикла 
 mov cx, 8 
 mov zn, 8 
CYCL: 
 
 invoke ReadConsole, stdIn, addr buf, 1, addr num, 0 
 ;invoke WriteConsole,stdOut, addr msg2, SIZEOF msg2, ADDR numWr,0 
 mov al, byte ptr buf+0 
 cmp al, '0' 
 je isZero ; если ввели 0, то к услвоия для 0 
 cmp al, '1' ; если ввели 1, то к условию для 1 
 je isBit 
 cmp al, '1' ; если больше 1 то отключаем консольку 
 ja isNotBin 
 
 isZero: 
 shl myNum,1 
 jmp myCycl 
 
 isBit: 
 add myNum,1 
 shl myNum, 1 
 jmp myCycl 
 isNotBin: 
 invoke WriteConsole,stdOut, addr msg1, SIZEOF msg1, ADDR numWr,0 
 invoke ExitProcess, 0 
 myCycl: 
 mov cx, zn 
 dec cx 
 mov zn, cx 
 cmp cx,0 
 
 jne CYCL 
 
 rcr myNum, 1 
 invoke WriteConsole,stdOut, addr msg2, SIZEOF msg2, ADDR numWr,0 
 mov ax, myNum ; убираем лишний 0 и возвращаем самый первый введенный 
;символ на место 
 
;реализция вывода числа в 2оичной системе 
 mov myNum2, al 
 mov myNum3, al 
 
 mov cx, 8 
 mov zn, 8 
 
 printNum: 
 ;При циклическом сдвиге RCL все биты числа (от старшего до младшего) 
 ;проходят через флаг переноса. Выполняя сложение CF + 30h 
 ;мы получим код символа "0" или "1" (в зависимости от значения CF): 
 
 rcl myNum2,1 
 jb CF_1 
 
 ;если регистр cf = 0 
 mov bl, '0' 
 mov printNumber, bl 
 invoke WriteConsole,stdOut, addr printNumber, SIZEOF printNumber, 
ADDR numWr,0 
 jmp endOfPrint 
 
 CF_1: ; если он равен 1 
 mov bl, '1' 
 mov printNumber, bl 
 invoke WriteConsole,stdOut, addr printNumber, SIZEOF printNumber, 
ADDR numWr,0 
 
 endOfPrint: 
 mov cx, zn 
 dec cx 
 mov zn, cx 
 cmp cx,0 
 jne printNum 
 
; сама функция необходимая по заданию 
 
invoke WriteConsole, stdOut, ADDR msg1310, SIZEOF msg1310, ADDR numWr, 0 
invoke WriteConsole, stdOut, ADDR msg3, SIZEOF msg3, ADDR numWr, 0 
 
 ;меняем местами 1 и 4 
 
mov al, myNum3 
and al, 10000000b 
shr al, 3 
 
mov bl, myNum3 
and bl, 00010000b 
shl bl, 3 
 
or al, bl ; совместил полученное число 
mov bl, myNum3 
and bl, 01101111b 
or al, bl ; получаем число псоле смены. 
mov newNum, al ; записываем число после смены 2 бит 
; повторяем все по анологии 
mov al, newNum 
and al, 01000000b 
shr al, 1 
 
mov bl, newNum 
and bl, 00100000b 
shl bl, 1 
 
or al, bl ; совместил полученное число 
mov bl, newNum 
and bl, 10011111b 
or al, bl ; получаем число псоле смены. 
mov newNum, al ; записываем число после смены 2 бит 
; повторяем все по анологии 
mov al, newNum 
and al, 00001000b 
shr al, 3 
 
mov bl, newNum 
and bl, 00000001b 
shl bl, 3 
 
or al, bl ; совместил полученное число 
mov bl, newNum 
and bl, 11110110b 
or al, bl ; получаем число псоле смены. 
mov newNum, al ; записываем число после смены 2 бит 
; повторяем все по анологии 
mov al, newNum 
and al, 00000100b 
shr al, 1 
 
mov bl, newNum 
and bl, 00000010b 
shl bl, 1 
 
or al, bl ; совместил полученное число 
mov bl, newNum 
and bl, 11111001b 
or al, bl ; получаем число псоле смены. 
mov newNum, al ; записываем число после смены 2 бит 
 
mov cx, 8 
mov zn, 8 
 printMixNum: 
 
 rcl newNum,1 
 jb CF_1Mix 
 ;если регистр cf = 0 
 mov bl, '0' 
 mov printNumber, bl 
 invoke WriteConsole,stdOut, addr printNumber, SIZEOF printNumber, 
ADDR numWr,0 
 jmp endOfMixPrint 
 CF_1Mix: ; если он равен 1 
 mov bl, '1' 
 mov printNumber, bl 
 invoke WriteConsole,stdOut, addr printNumber, SIZEOF printNumber, 
ADDR numWr,0 
 endOfMixPrint: 
 ;invoke WriteConsole,stdOut, addr msg1, SIZEOF msg1, ADDR numWr,0 
 mov cx, zn 
 dec cx 
 mov zn, cx 
 cmp cx,0 
 jne printMixNum 
 
 
; деление числа 
invoke WriteConsole, stdOut, ADDR msg1310, SIZEOF msg1310, ADDR numWr, 0 
invoke WriteConsole, stdOut, ADDR msg4, SIZEOF msg4, ADDR numWr, 0 
 
;делим на 16 
 
mov al, myNum3 
shr al, 4 
mov div16Num, al 
 
mov cx, 8 
mov zn, 8 
 printDivNum: 
 
 rcl div16Num,1 
 jb CF_1Div 
 ;если регистр cf = 0 
 mov al, '0' 
 mov printNumber, al 
 invoke WriteConsole,stdOut, addr printNumber, SIZEOF printNumber, 
ADDR numWr,0 
 jmp endOfDivPrint 
 CF_1Div: ; если он равен 1 
 mov al, '1' 
 mov printNumber, al 
 invoke WriteConsole,stdOut, addr printNumber, SIZEOF printNumber, 
ADDR numWr,0 
 endOfDivPrint: 
 ;invoke WriteConsole,stdOut, addr msg1, SIZEOF msg1, ADDR numWr,0 
 mov cx, zn 
 dec cx 
 mov zn, cx 
 cmp cx,0 
 jne printDivNum 
 
; работает на все 100 процентов. 
 
 invoke ExitProcess, 0 
end start; 
