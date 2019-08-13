; ����Դ���루stone.asm��
; ֮���ı���ʽ����ʾ������1/4�����ϴ�������һ��A��,��45���������˶���ײ���߿����
; ÿ����ײ���ַ�A����ı���ɫ
; NASM����ʽ
    	Dn_Rt equ 1                  	; D-Down
    	Up_Rt equ 2                  	; U-Up
    	Up_Lt equ 3                  	; R-right
    	Dn_Lt equ 4                  	; L-Left
    	delay equ 50000			; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
    	ddelay equ 800			; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�

    	org 0xD100				; ������ص�07c00h
start:
      mov ax,cs
	mov es,ax				; ES = 0
	mov ds,ax				; DS = CS
	mov es,ax				; ES = CS
	mov ax,0B800h			; �ı������Դ���ʼ��ַ
	mov gs,ax				; GS = B800h
clear:                         	;�崰��
      mov ah,0x06                 
      mov al,0                   
      mov ch,0                 	;���Ͻǵ��к�
      mov cl,0                 	;���Ͻǵ��к�
      mov dh,24                	;���½ǵ��к�
      mov dl,79                	;���½ǵ��к�(��������������)
      mov bh,0x0               	;�������ú�ɫ�����
      int 10h     
main:
	dec word[count]			; �ݼ���������
	jnz main				; ������0����ת;
	dec word[dcount]			; �ݼ���������
      jnz main
	mov word[count],delay
	mov word[dcount],ddelay

      ;�ж� ��rdul��Ϊ1,2,3,4,
      ;��ֱ���ת�������£����ϣ����ϣ������˶������
      mov al,1
      cmp al,byte[rdul]
	jz  DnRt
      mov al,2
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4
      cmp al,byte[rdul]
	jz  DnLt
      jmp $	

DnRt:
	;x,yΪ��Ļ�����������
      inc word[x]
	inc word[y]
      ;�Կ����ı���ʽ����С�ɿ��Ƶ�λΪ�ַ���VGA��13X80
      ;��xΪ13-25��yΪ40-80
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      ;down-right to up-right,x�����Ե,�ı䷽��Ϊ����
      jz  dr2ur
          
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      ;down-right to down-left,y�����Ե,�ı䷽��Ϊ����
      jz  dr2dl
	jmp show
dr2ur:
	;�ı䷽����ͬ
      mov word[x],23
      mov byte[rdul],Up_Rt	
      ;�ı���ɫ����ͬ
	jmp changeColor
dr2dl:
      mov word[y],78
      mov byte[rdul],Dn_Lt	
      jmp changeColor

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  ur2ul
	mov bx,word[x]
	mov ax,12
	sub ax,bx
      jz  ur2dr
	jmp show
ur2ul:
	mov word[y],78
      mov byte[rdul],Up_Lt
	jmp changeColor
ur2dr:
      mov word[x],14
      mov byte[rdul],Dn_Rt	
      jmp changeColor
	
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,12
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,39
	sub ax,bx
      jz  ul2ur
	jmp show
ul2dl:
      mov word[x],14
      mov byte[rdul],Dn_Lt	
      jmp changeColor
ul2ur:
      mov word[y],41
      mov byte[rdul],Up_Rt	
      jmp changeColor
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,39
	sub ax,bx
      jz  dl2dr
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dl2ul
	jmp show

dl2dr:
      mov word[y],41
      mov byte[rdul],Dn_Rt	
      jmp changeColor
	
dl2ul:
      mov word[x],23
      mov byte[rdul],Up_Lt	
      jmp changeColor

changeColor:
	;�ı���ɫ
	mov ax,word[color]
	sub ax,1
	mov byte[color],al
	jnz show
	mov byte[color],0Fh
show:	
      mov ax,word[x]                ;�����Դ��ַ
	mov bx,80				
	mul bx				;(ax)=(ax)*80��λ 80x
	add ax,word[y]			;(ax)=(ax)+y      80x+y
	mov bx,2			
	mul bx				;(ax)=(ax)*2 1�ֽ��ַ� 1�ֽ���ɫ
	mov bp,ax				;bp��ΪҪ��ʾ�ַ����Դ��ַ
	mov ah,byte[color]		;AH(ax��λ)Ϊ��ɫ
	mov al,byte[char]			;AL(ax��λ)��ʾ�ַ�ֵ
	mov word[gs:bp],ax  		;���ַ�ֵ����ɫ�͵�Ҫ��ʾ�ַ����Դ��ַ
	
	xor ax,ax
	mov ah,1
	int 0x16                    ;ɨ�����뻺�����Ƿ����ַ�
	cmp al,27                   ;�����Esc�򷵻ؼ�س���
	jne main           
	jmp 7c00h
	
end:
    jmp $                   		; ֹͣ��������ѭ�� 
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         		; ��ʼĬ���������˶�
    x    dw 20
    y    dw 40
    char db 'A'
    color db 0Fh				;��ɫ��ʼĬ�ϰ�ɫ
	times 510-($-$$) db 0
      db 0x55,0xaa