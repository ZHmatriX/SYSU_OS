; ����Դ���루BIOSCall.asm��
; �������õ�BIOS����
; NASM����ʽ
org 1400h
main:
	call Clear
	int 33h
	call Delay
	int 34h
	call Delay
	int 35h
	call Delay
	int 36h
	call Delay
	ret
	
Clear: ;����
    mov ax,0003H
    int 10H
	ret

Delay:                           ;��ʾ�����һ��ʱ��
    mov cx,delayTime      
loop1:
	mov word [es:t],cx          
	mov cx,delayTime
loop2:
	loop loop2 
	mov cx,word [es:t]         
	loop loop1
	ret
	delayTime equ 30000
	t dw 0
times 510-($-$$) db 0
      db 0x55,0xaa