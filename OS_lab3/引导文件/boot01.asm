;��������(boot.asm��
;NASM��ʽ
;���ڼ��ز���ϵͳ�ں�
org  07c00h		               ; BIOS���������������ص�0:7C00����ʼִ��
Start:
    mov	ax, cs	                   ; �������μĴ���ֵ��CS��ͬ
    mov	ds, ax	                   ; ���ݶ�
    mov	bp, Message		           ; BP=��ǰ����ƫ�Ƶ�ַ
    mov	ax, ds			           ; ES:BP = ����ַ
    mov	es, ax			           ; ��ES=DS
    mov	cx, MessageLength 	       ; CX = ������=9��
    mov	ax, 1301h	               ; AH = 13h�����ܺţ���AL = 01h��������ڴ�β��
    mov	bx, 0007h	               ; ҳ��Ϊ0(BH = 0) �ڵװ���(BL = 07h)
    mov dh, 0	                   ; �к�=0
    mov	dl, 0	                   ; �к�=0
    int	10h		                   ; BIOS��10h���ܣ���ʾһ���ַ�
Load:
    ;�����̻�Ӳ���ϵĲ���ϵͳ�ں˵��ڴ��ES:BX����
    mov ax,baseOfSeg               ; �λ���ַ ; ������ݵ��ڴ����ַ
    mov es,ax                      ; ���öε�ַ������ֱ��mov es,�ε�ַ��
    mov bx, OffSetOfKernel         ; ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
    mov ah,2                       ; ���ܺ�
    mov al, SegNumOfKernel         ; ������
    mov dl,0                       ; �������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
    mov dh,0                       ; ��ͷ�� ; ��ʼ���Ϊ0
    mov ch,0                       ; ����� ; ��ʼ���Ϊ0
    mov cl,2                       ; ��ʼ������ ; ��ʼ���Ϊ1
    int 13H                        ; �����ж�
    ;�ں��Ѽ��ص�ָ���ڴ�������
    jmp baseOfSeg:OffSetOfKernel
    jmp $                          ;����ѭ��

Message:
    db 'Loading MyOS kernal...'
    MessageLength  equ ($-Message) ; �ַ�������
    OffSetOfKernel  equ 100h       ; ƫ����
    baseOfSeg    equ 800h          ; ������ݵ��ڴ����ַ
    SegNumOfKernel equ 9           ; �ں�ռ��������
    times 510-($-$$)	db	0	   ; ��0�����������ʣ�µĿռ�
    db 	0x55, 0xaa			       ; ��������������־
