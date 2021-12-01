; Новый проект masm32 успешно создан 
; Заполнен демо программой «Здравствуй, мир!» 
.386 
.model flat, stdcall 
option casemap :none 
 
include includes\windows.inc 
include includes\masm32.inc 
 
include includes\user32.inc 
include includes\kernel32.inc 
include includes\macros\macros.asm 
 
includelib includes\masm32.lib 
includelib includes\user32.lib 
includelib includes\kernel32.lib 
 
.const 
fileNameIn db 'in.txt', 0 
fileNameOut db 'out.txt', 0 
 
.data 
 
fileIn dd ? 
fileOut dd ? 
fileInSize dd ? 
count dd ? 
fileOutSize dd ? 
 
stdout dd ? 
cWritten dd ? 
cRead dd ? 
num db ? 
bufIn db 999d dup (?) 
bufOut db 999d dup (?) 
.code 
; 
BubbleSort proc 
  mov ecx, fileInSize; размер файла - число элементов массива 
  ;mov count, ecx 
  dec ecx ; счетчик внешнего цикла 
L1: 
  push ecx ; пушим его в стэк 
  mov esi, offset bufIn ; грузим адрес первого элемента 
L2:  ;lodsb; загружаем значение элемента 
  mov al, [esi]
  cmp al, ' ' ; производим проверки, чтоб сортировались слова 
  je isSpaceOrEnter 
  cmp al, 0ah 
  je isSpaceOrEnter 
   
  mov bl,al  
  mov al, [esi+1]
 ; записываем следующий символ  
  cmp al, ' ' ; производим проверки, чтоб сортировались слова 
  je isSpaceOrEnter2 
  cmp al, 0ah 
  je isSpaceOrEnter2 
   
  cmp bl, [esi+1] ; сравниваем соседние элементы bl=esi 
  jbe L3 ;если 1 больше 2-го, то берем следующую пару значений 
  mov al, [esi+1] ; иначе меняем элементы местами 
  mov [esi], al 
  mov [esi+1], bl 
  jmp L3 
isSpaceOrEnter:  
  mov [esi], al 
  jmp L3 
isSpaceOrEnter2: 
  mov [esi], bl 
L3: 
  inc esi ; счетчик 2 внутр цикла 
  loop L2 ; повторяем внутр цикл 
  pop ecx ; восстанавливаем внешний счетчик цикла 
  loop L1 ; повторяем внешний цикл 
L4: ret 
BubbleSort endp 
 
   
addNumber proc 
  mov esi, offset bufIn 
  inc num 
  mov al, num 
  add al, 30h 
  stosb 
  inc fileOutSize 
  inc fileOutSize 
   
  checkLine: 
  lodsb 
  cmp al, 0ah 
  je numLine 
  stosb 
  jmp cycl 
  numLine: 
    stosb 
    inc num 
    mov al, num 
    add al, 30h 
    inc fileOutSize 
    inc fileOutSize 
    stosb 
    ;lodsb 
  cycl: 
    cmp al, 0d 
    jnz checkLine 
    ret 
addNumber endp 
;осталось добавить нумерацию и пофиксить файлик 
 
start: 
 
invoke CreateFileA, addr fileNameIn, GENERIC_READ, 0, 0, OPEN_EXISTING, 
FILE_ATTRIBUTE_NORMAL, 0 
mov fileIn, eax ; дискриптор входного файла 
 
; получаем размеры входого и выходного файла 
invoke GetFileSize, eax, 0 
mov fileInSize, eax 
mov fileOutSize, eax 
 
; дескриптор открытия файла out.txt 
invoke CreateFileA, addr fileNameOut, GENERIC_WRITE, 0, 0, OPEN_ALWAYS, 
FILE_ATTRIBUTE_NORMAL, 0 
mov fileOut, eax ; дискриптор выходного файла 
 
; считываем файл в буфер 
invoke ReadFile, fileIn, addr bufIn, fileInSize, 0, 0 
mov esi, offset bufIn  
mov edi, offset bufOut 
;запускаем написанные выше процедуры 
call BubbleSort 
call addNumber 
 
invoke WriteFile, fileOut, addr bufOut, fileOutSize, 0, 0 
 
invoke CloseHandle, fileIn ;закрытие файла 
invoke CloseHandle, fileOut 
invoke ExitProcess, 0 
 
end start 