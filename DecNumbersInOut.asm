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
;переменные для ввода
oneInt dd ?
twoInt dd ?
threeInt dd ?
fourInt dd ?
fiveInt dd ?
userInput db ?
userEndInput dw ?
inputAA dw ?
inputBB dw ?
inputCC dw ?
inputDD dw ?
inputEE dw ?
inputFF dw ?
inputGG dw ?
inputHH dw ?
inputKK dw ?
inputMM dw ?
mulAB dw ?
mulBC dw ?
mulCD dw ?
mulEF dw ?
addDE dw ?
divAG dw ?
divGH dw ?
addHK dw ?
mulKM dw ?
result dd ?
newresult dd ?
;сообщения в консоль
msgA db "A: "
msgB db "B: "
msgC db "C: "
msgD db "D: "
msgE db "E: "
msgF db "F: "
msgG db "G: "
msgH db "H: "
msgK db "K: "
msgM db "M: "
msg1310 db 13, 10
ifmtDEC db "%d", 0
msgTASK db "(a*b*c*d+e*f)/(g/h+k*m) = "
countt db 0
newcount dd 0

;дискрипоторы ввода/вывода
stdIn dd ?
stdOut dd ?

;буфер
buf db 1 dup (?)
outBuf dd 1 dup (?)
buffer_key_2 db ?
;для сохранения ввденных символов
numWr dd ?
cxForInput dw ?
cxForCycl dw ?
cxForStack dw ?

.code
start:
	
invoke AllocConsole;запрашиваем консоль WIN

invoke GetStdHandle, STD_INPUT_HANDLE ;записываем дискриптор ввода
mov stdIn, EAX

invoke GetStdHandle, STD_OUTPUT_HANDLE ;записываем дискриптор вывода
mov stdOut, EAX

invoke SetConsoleMode, stdIn, 0
;устанавливаем посимвольный ввод в консоль
;(a*b*c*d+e*f)/(g/h+k*m)
 
mov cxForCycl, 10
mov cx, cxForCycl ; делаем цикл на 10 повторов
mainCycl:
;вывод начального сообщения в зависимости от итерации
cmp cxForCycl, 10
je intA
cmp cxForCycl, 9
je intB
cmp cxForCycl, 8
je intC
cmp cxForCycl, 7
je intD
cmp cxForCycl, 6
je intE
cmp cxForCycl, 5
je intF
cmp cxForCycl, 4
je intG
cmp cxForCycl, 3
je intH
cmp cxForCycl, 2
je intK
cmp cxForCycl, 1
je intM

intA:
	invoke WriteConsole, stdOut, addr msgA, sizeof msgA, addr numWr, 0
	jmp startInput
intB:
	invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, addr numWr, 0
	invoke WriteConsole, stdOut, addr msgB, sizeof msgB, addr numWr, 0
	jmp startInput
intC:
	invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, addr numWr, 0
	invoke WriteConsole, stdOut, addr msgC, sizeof msgC, addr numWr, 0
	jmp startInput
intD:
	invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, addr numWr, 0
	invoke WriteConsole, stdOut, addr msgD, sizeof msgD, addr numWr, 0
	jmp startInput
intE:
	invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, addr numWr, 0
	invoke WriteConsole, stdOut, addr msgE, sizeof msgE, addr numWr, 0
	jmp startInput
intF:
	invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, addr numWr, 0
	invoke WriteConsole, stdOut, addr msgF, sizeof msgF, addr numWr, 0
	jmp startInput
intG:
	invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, addr numWr, 0
	invoke WriteConsole, stdOut, addr msgG, sizeof msgG, addr numWr, 0
	jmp startInput
intH:
	invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, addr numWr, 0
	invoke WriteConsole, stdOut, addr msgH, sizeof msgH, addr numWr, 0
	jmp startInput
intK:
	invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, addr numWr, 0
	invoke WriteConsole, stdOut, addr msgK, sizeof msgK, addr numWr, 0
	jmp startInput
intM:
	invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, addr numWr, 0
	invoke WriteConsole, stdOut, addr msgM, sizeof msgM, addr numWr, 0
	jmp startInput
	
;записываем числа в userInputEnd и переписываем в нужную переменную
;до 4 циферок
startInput:
	mov cxForInput, 4
	mov cx, cxForInput;будет цикл для считывания до 4 чисел
	mov ax, 0 

writeIn:
	invoke ReadConsole, stdIn, addr buf, sizeof buf, addr numWr,0 ;читаем число
	mov al, buf ; переписываем в al 
	cmp al,13 ; производим все необходимые проверки
	je isFirstEnter
	
	
	cmp al, '0'
	jb outOfRange 
	cmp al, '9'
	ja outOfRange
	jmp nextInt
isFirstEnter:
	cmp cxForInput, 4
	je outOfRange
	jmp writeNextInt
outOfRange:
	jmp writeIn ; если число не подходит нам 
	
nextInt:
	sub al, 30h ; преобразуем строку из al в число
	cmp cxForInput,4 ; проверка шага цикла
	je notMul ; на первый проход просто записыавем число
	cmp cxForInput, 4
	jne Mull ;на второй умножаем на 10 и add число из al
	
	notMul:
		mov userInput, al
		cbw
		mov userEndInput, ax
		invoke crt_printf, offset ifmtDEC,  userEndInput
		cmp cxForCycl, 10
		je inpA
		cmp cxForCycl, 9
		je inpB
		cmp cxForCycl, 8
		je inpC
		cmp cxForCycl, 7
		je inpD
		cmp cxForCycl, 6
		je inpE
		cmp cxForCycl, 5
		je inpF
		cmp cxForCycl, 4
		je inpG
		cmp cxForCycl, 3
		je inpH
		cmp cxForCycl, 2
		je inpK
		cmp cxForCycl, 1
		je inpM
		;back:
		jmp inNext
	Mull:
		mov cl, al 
		mov bl, 10
		cmp cxForInput, 3
		je isTree
		jmp notTree
	isTree:
		mov userEndInput, 0
		mov al, userInput
		mul bl
		mov userEndInput,ax
		mov al, cl
		cbw
		add userEndInput, ax
		invoke crt_printf, offset ifmtDEC,  cl
		cmp cxForCycl, 10
		je inpA
		cmp cxForCycl, 9
		je inpB
		cmp cxForCycl, 8
		je inpC
		cmp cxForCycl, 7
		je inpD
		cmp cxForCycl, 6
		je inpE
		cmp cxForCycl, 5
		je inpF
		cmp cxForCycl, 4
		je inpG
		cmp cxForCycl, 3
		je inpH
		cmp cxForCycl, 2
		je inpK
		cmp cxForCycl, 1
		je inpM
		;back:
		jmp inNext
	notTree:
		mov ax, userEndInput
		mul bl
		mov userEndInput,ax
		mov al, cl
		cbw
		add userEndInput, ax
	;invoke crt_printf, offset ifmtDEC,  inputAA
		mov ax, userEndInput
		invoke crt_printf, offset ifmtDEC,  cl
		cmp cxForCycl, 10
		je inpA
		cmp cxForCycl, 9
		je inpB
		cmp cxForCycl, 8
		je inpC
		cmp cxForCycl, 7
		je inpD
		cmp cxForCycl, 6
		je inpE
		cmp cxForCycl, 5
		je inpF
		cmp cxForCycl, 4
		je inpG
		cmp cxForCycl, 3
		je inpH
		cmp cxForCycl, 2
		je inpK
		cmp cxForCycl, 1
		je inpM
		;back:
		jmp inNext
		inNext:
		mov cx, cxForInput
		dec cx 
		mov cxForInput, cx 
		cmp cx,0 
		jmp isEnd
 ;для ввода переменных куда надо первый раз
 inpA:
	mov ax, userEndInput
	mov inputAA, ax
	jmp inNext
 inpB:
	mov ax, userEndInput
	mov inputBB, ax
	jmp inNext
 inpC:
	mov ax, userEndInput
	mov inputCC, ax
	jmp inNext 
  inpD:
	mov ax, userEndInput
	mov inputDD, ax
	jmp inNext
 inpE:
	mov ax, userEndInput
	mov inputEE, ax
	jmp inNext
 inpF:
	mov ax, userEndInput
	mov inputFF, ax
	jmp inNext  
 inpG:
	mov ax, userEndInput
	mov inputGG, ax
	jmp inNext
 inpH:
	mov ax, userEndInput
	mov inputHH, ax
	jmp inNext
 inpK:
	mov ax, userEndInput
	mov inputKK, ax
	jmp inNext  
 inpM:
	mov ax, userEndInput
	mov inputMM, ax
	jmp inNext 
		
	isEnd:	  
    jne writeIn

writeNextInt:
		mov cx, cxForCycl
		dec cx 
		mov cxForCycl, cx 
		cmp cx,0 
		jne mainCycl

   
count:
    ;(a*b*c*d+e*f)/(g/h+k*m)
    invoke WriteConsole, stdOut, addr msg1310, sizeof msg1310, 0, 0
    invoke WriteConsole, stdOut, addr msgTASK, sizeof msgTASK, 0, 0
    
    ;a*b
    mov ax, inputAA
    mov bx, inputBB
    mul bx
    mov mulAB, ax

   	;c*d
   	mov ax, inputCC
   	mov bx, inputDD
   	mul bx
    mov mulCD, ax                      	
    	
    ;ab*cd
   	mov ax, mulAB
   	mov bx, mulCD
   	mul bx
   	mov mulBC, ax
   	
    ;e*f
   	mov ax, inputEE
   	mov bx, inputFF
   	mul bx
   	mov mulEF, ax
    	
   	;abcdd+ef
   	mov ax, mulBC
   	add ax, mulEF
   	mov addDE, ax
    	
   	;g/h
   	mov ax, inputGG
    CWDE ; ax--> eax
   	mov bx, inputHH
   	div bx
   	mov divGH, ax
   	
    ;k*m
    mov ax, inputKK
    mov bx, inputMM
    mul bx
    mov mulKM, ax
    	
    ;gh+km
    mov ax, mulKM
    add ax, divGH
    mov addHK, ax
    	
    ;abcde/ghkm
    mov ax, addDE
    CWDE 
    mov bx, addHK
    div bx
    mov divAG, ax
    CWDE
	mov result, eax

  ; invoke crt_printf, offset ifmtDEC, result
   
intToString:	
xor edx, edx 
mov eax, result;сохраняем резульатт в eax
mov ebx, 10; делитель
div ebx
add edx, 30h ; преобразуем в строку
mov newresult,edx
mov result, eax ; записываем новое число/10
inc countt

cmp countt, 1
je one
cmp countt, 2
je two
cmp countt, 3
je three
cmp countt, 4
je four
cmp countt, 5
je five

jmpback:
cmp result,0
je outInt
jmp intToString

one:
	mov eax, newresult
	mov oneInt , eax
	;invoke WriteConsole, stdOut, addr newresult, sizeof newresult, 0, 0
	mov oneInt, eax
	
	jmp jmpback
two:
	mov eax, newresult
	mov twoInt , eax
	jmp jmpback
three:
	mov eax, newresult
	mov threeInt, eax
	jmp jmpback		
four:
	mov eax, newresult
	mov fourInt, eax
	jmp jmpback
five:
	mov eax, newresult
	mov fiveInt, eax
	jmp jmpback

outInt:
	cmp countt, 5
	je outFive
	cmp countt, 4
	je outFour
	cmp countt, 3
	je outThree
	cmp countt, 2
	je outTwo
	cmp countt, 1
	je outOne
	outBack:
	dec countt
	cmp countt, 0
	jnz outInt
	jmp itIsEnd
	outFive:
	invoke WriteConsole, stdOut, addr fiveInt, 1, 0, 0
	jmp outBack
	outFour:
		invoke WriteConsole, stdOut, addr fourInt, 1, 0, 0
	jmp outBack
	outThree:
		invoke WriteConsole, stdOut, addr threeInt, 1, 0, 0
	jmp outBack
	outTwo:
		invoke WriteConsole, stdOut, addr twoInt, 1, 0, 0
	jmp outBack
	outOne:
		invoke WriteConsole, stdOut, addr oneInt, 1, 0, 0
	jmp outBack
	itIsEnd:
end start
;добавить ноликов