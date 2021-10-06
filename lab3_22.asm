
;(vara+b + c)-(d + e+f)+(g+h + k-m) 11 variant
.386
.model flat, stdcall
option casemap: none
 
include includes\windows.inc
include  includes\user32.inc
include includes\kernel32.inc

includelib includes\user32.lib
includelib includes\kernel32.lib
 
include includes\macros\macros.asm
uselib masm32, comctl32, ws2_32


.data
msg_title db "Title", 0
A DB 1h
B DB 2h
varC DB 1h
D DB 1h
E DB 2h
F DB 1h
G DB 0h
H DB 3h
K DB 12h
M DB 1h
buffer db 128 dup(?)
format db "%d",0

.code
start:

MOV AL, A
ADD AL, B
ADD AL, varC

MOV BL, D
ADD BL, E
ADD BL, F

MOV CL, G
ADD CL, H
ADD CL, K
SUB CL, M

SUB AL, BL
ADD AL, CL

invoke wsprintf, addr buffer, addr format, al
invoke MessageBox, 0, addr buffer, addr msg_title,  MB_OK

invoke ExitProcess, 0

end start