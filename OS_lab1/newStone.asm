; ����Դ���루stone.asm��
; ������ͷ��ʾ����ѧ��(��ɫ)����������ĸ(��ɫ)
; ֮���ı���ʽ��ʾ���ϴ�������һ��A��,��45���������˶���ײ���߿����,�������.
; ÿ����ײ���ַ�A����ı���ɫ
; NASM����ʽ
    	Dn_Rt equ 1                  	; D-Down
    	Up_Rt equ 2                  	; U-Up
    	Up_Lt equ 3                  	; R-right
    	Dn_Lt equ 4                  	; L-Left
    	delay equ 50000			; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
    	ddelay equ 580			; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�

    	org 07c00h				; ������ص�07c00h
start:
      mov ax,cs
	mov es,ax				; ES = 0
	mov ds,ax				; DS = CS
	mov es,ax				; ES = CS
	mov ax,0B800h			; �ı������Դ���ʼ��ַ
	mov gs,ax				; GS = B800h
   
main:
	;��ʾѧ�� ��������ĸ
     	mov es,ax
     	mov byte[es:00h],'1'
     	mov byte[es:01h],07h
	mov byte[es:02h],'6'
	mov byte[es:03h],07h	
	mov byte[es:04h],'3'
	mov byte[es:05h],07h
	mov byte[es:06h],'2'
	mov byte[es:07h],07h
	mov byte[es:08h],'7'
	mov byte[es:09h],07h
	mov byte[es:0ah],'1'
	mov byte[es:0bh],07h
	mov byte[es:0ch],'4'
	mov byte[es:0dh],07h
	mov byte[es:0eh],'3'
	mov byte[es:0fh],07h
	mov byte[es:10h],'Z'
	mov byte[es:11h],09h
	mov byte[es:12h],'H'
	mov byte[es:13h],09h
	mov byte[es:14h],'X'
	mov byte[es:15h],09h	
	  
loop1:
	dec word[count]			; �ݼ���������
	jnz loop1				; ������0����ת;
	dec word[dcount]			; �ݼ���������
      jnz loop1
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
      ;�Կ����ı���ʽ����С�ɿ��Ƶ�λΪ�ַ���VGA��25X80
      ;��x���Ϊ25��y���Ϊ80
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
	mov ax,-1
	sub ax,bx
      jz  ur2dr
	jmp show
ur2ul:
	mov word[y],78
      mov byte[rdul],Up_Lt
	jmp changeColor
ur2dr:
      mov word[x],1
      mov byte[rdul],Dn_Rt	
      jmp changeColor
	
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  ul2ur
	jmp show
ul2dl:
      mov word[x],1
      mov byte[rdul],Dn_Lt	
      jmp changeColor
ul2ur:
      mov word[y],1
      mov byte[rdul],Up_Rt	
      jmp changeColor
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  dl2dr
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dl2ul
	jmp show

dl2dr:
      mov word[y],1
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
	jmp main
	
end:
    jmp $                   		; ֹͣ��������ѭ�� 
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         		; ��ʼĬ���������˶�
    x    dw 7
    y    dw 0
    char db 'A'
    color db 0Fh				;��ɫ��ʼĬ�ϰ�ɫ
