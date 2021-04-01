.MODEL SMALL
.DATA

	;despliega el Bienvenida en la pantalla
	Bienvenida        db 13,10,'                   Bienvenido a la calculadora Hexadecimal '
	                  db 13,10,13,10,'$'

	;para poder desplegar el menu en pantalla
	menu              db "Menu de opciones",13,10
	                  db "                 ",13,10
	                  db "1.Suma",13,10
	                  db "2.Resta",13,10
	                  db "3.Division",13,10
	                  db "4.Multiplicacion",13,10
	                  db "5.Salir",13,10
	                  db 13,10, 'Digite una opcion: $',13,10
     
	ingreso1          db 13,10,'            Digite el primer valor = $'                                            	;guarda lo que digita el usuario
	;numero
	ingreso2          db 13,10,'            Digite el segundo valor = $'                                           	;guarda lo que digita el usuario
	;numero
	exisRe            DB 13,10
	                  DB 'La division tiene residuo! $'

	caracterNovalido  DB 13,10
	                  DB 'Por favor ingrese solo numeros Hexadecimales 0-9 y A-F! $'
	caracterNovalido2 DB 13,10
	                  DB 'La opcion Digita no existe ! $'

	limSup            DB 13,10,'Error!: se ha superado los limites , que puede representar la calculadora $'
	

	divporCero        DB 13,10
	                  DB 'Error:No se puede divir por cero! $'

  bitsNovalidos     DB 13,10
	                  DB 'Error:debe completar con los bits adecuados ejemplo 0002 o 12A3! $'

	Despedida         DB 13,10
	                  DB 'Gracias por usar la calculadora :D saliendo...... $'


	result            db 13,10,'               resultado = $'                                                      	;string para mostar el resultado
	resultf           db 11 dup(?)                                                                                 	;


	num1              dw 0                                                                                         	;variables para almacenar los resultados
	num2              dw 0
	num               dw 0
	num1d             db 5,0,5 dup(?)                                                                              	;guarda lo que digita el usuario
	num2d             db 5,0,5 dup(?)                                                                              	;guarda lo que digita el usuario

	potencia          dw 0001h, 10h, 100h, 1000h   ; ejemplo 12A3=1*16 ^0 ...........                                                            	;array con las diferentes potencias
	
	;------------------------------------------------------------------------
	;codigo
	;------------------------------------------------------------------------

.CODE
	main:           
	                mov   ah, 0fh                     	;capturando el modo de video
	                int   10h ; seleciona el modo de video
	                mov   ah, 00
	                int   10h
	                mov   ax, @data ;indicamos donde inicia el proyecto, con limpiamos el contenido basura
	                mov   ds, ax
	                mov   si, offset resultf          	;limpia el string para imprimir el resultado
	                add   si,11
	                mov   al,'$'
	                mov   [si],al

	; --------------------- despliega y maneja el menu --------------------

	menu1:          
	                call  clrscr
	                mov   dl,0                        	;posiciona el cursor
	                mov   dh,0
	                call  Acursor
	                mov   dx, offset Bienvenida       	;despliega el Bienvenida
	                call  cout
	                mov   dl,0                        	;posiciona el cursor
	                mov   dh,4h
	                call  Acursor
	                mov   dx, offset menu             	;despliega el menu
	                call  cout                        
	                jmp   evaluar

	evaluar:        
	                mov   Ah,00h                      	;obtiene la tecla pulsada
	                int   16h                         	;permite tomar las funcionalidades del teclado
	                cmp   al,39h
	                ja    fail             ;compara si la tecla pulsada esta en un rango de 
	                cmp   al,29h            ;29 o 30 donde eso representa  0-9 y A-F
	                jb    fail
	                jmp   success
	fail:           
	                mov   dl,00h
	                mov   dh,10
	                call  Acursor
	                lea   dx, caracterNovalido2
	                call  cout
	                mov   ah,0                        	
	                int   16h  ;captura las pulsaciones del teclado
	                jmp   menu1
	success:        
	                cmp   AL,49                       	;Compara con  1
	                je    Suma                        	;brinca a sumar
	                cmp   AL,50                       	;Compara con 2
	                je    Resta                       	;brinca a a restar
	                cmp   AL,51                       	;Compara con  3
	                je    Dividir                     	;brinca a dividir
	                cmp   AL,52                       	;Compara con  4
	                je    Multiplicar                 	;brinca a multiplicar
	                cmp   AL,53                       	;Compara con  CON 5
	                je    Terminar                    	;brinca a terminar
  
                                           ;el proceso de caputa devuelve en ax ciertos valores
	Suma:                                   ;en caso de detectar un error de entrada
	                push  ax
	                call  captura                     	;captura los datos
	                cmp   ax,0007h
	                je    errorDato
	                call  AddMethod                   	;realiza la suma e imprime el resultado
	                pop   ax
	                jmp   menu1                       	;brinca al menu principal

	Resta:          
	                push  ax
	                call  captura                     	;captura los datos
	                cmp   ax,0007h
	                je    errorDato
	                call  SubMethod                   	;realiza la resta e imprime el resultado
	                pop   ax
	                jmp   menu1                        	;brinca al menu principal
   
	Multiplicar:    
	                push  ax
	                call  captura                     	;captura los datos
	                cmp   ax,0007h
	                je    errorDato
	                call  MulMethod                   	;realiza la multiplicacion e imprime resultado
	                pop   ax
	                jmp   menu1                       	;brinca al menu principal

	Dividir:        
	                push  ax
	                call  captura                     	;captura los datos
	                cmp   ax,0007h
	                je    errorDato
	                call  divisionMethod              	;realiza la multiplicacion e imprime resultado
	                pop   ax
	                jmp   menu1                       	;brinca al menu principal

	errorDato:      
	                pop   ax
	                jmp   menu1                       	;brinca al menu principal

	Terminar:       
	                mov   dl,00h
	                mov   dh,10
	                call  Acursor
	                lea   dx,Despedida
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h
	                mov   ax, 4c00h                   	;termina la ejecucion del programa
	                int   21h

	;-------------------------------------------------------------------
	;     imprime los mensajes cargados a Dx
	; -------------------------------------------------------------------
	                proc  cout
	                push  ax
	                mov   ah,09h
	                int   21h
	                pop   ax
	                ret
	                endp  cout
	;-------------------------------------------------------------------
	;     pide datos al usuario
	; -------------------------------------------------------------------
	                proc  input

	                push  ax
	                mov   ah, 0ah
	                int   21h

	                pop   ax
	                ret
	                endp  input


	;------------------------------------------------------------------------
	;captura los numeros
	;------------------------------------------------------------------------

captura proc near                                 		;procedimiento para capturar los numeros
	                call  clrscr                      	;limpia la pantalla
	                mov   dl,0                        	;posiciona el cursor
	                mov   dh,3
	                call  Acursor
	                mov   dx, offset ingreso1         	;imprime el primer mensaje
	                call  cout                        	
	                mov   dx, offset num1d
	                call  input                         ;captura el primer numero
	                mov   num,0                       	;elige el numero uno
	                push  ax
	                call  convertirHexa               	;llama la funcion para convertir
	                cmp   ax,0008H                     ;Se ha encontrado un caracter invalido
	                je    msgError
                        cmp   ax,0036H                     ;no ha completado los bits
	                je    msgError2
	                pop   ax
	                mov   num1,bx                     	;mueve el resultado a una variable
	                mov   dl,0                        	;posiciona el cursor
	                mov   dh,5
	                call  Acursor
	                mov   dx, offset ingreso2         	;imprime el mensaje
	                call  cout
	                mov   dx, offset num2d            	;captura el numero dos
	                call  input
	                mov   num,1                       	;elige el numero dos
	                push  ax
	                call  convertirHexa               	;llama la funcion para convertir
	                cmp   ax,0008H
	                je    msgError
                        cmp   ax,0036H
	                je    msgError2
	                pop   ax
	                mov   num2,bx                     	;mueve el resultado a una variable
	                jmp   isfin					
	msgError:       
	                pop   ax
	                mov   dl,00h
	                mov   dh,10
	                call  Acursor
	                mov   dx, offset  caracterNovalido
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h
	                mov   ax,0007h
	                jmp   isfin
  	msgError2:       
	                pop   ax
	                mov   dl,00h
	                mov   dh,10
	                call  Acursor
	                mov   dx, offset  bitsNovalidos 
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h
	                mov   ax,0007h
	                jmp   isfin


	isfin:          
	                ret
captura endp                                      		;finaliza funcion captura

	;------------------------------------------------------------------------
	;convierte un string a Hexadecimal
	;------------------------------------------------------------------------

convertirHexa proc near                           		;procedimiento que convierte un string a binario
	            mov   dx,0ah
	            cmp   num,0                       	;verifica si se convierte el numero 1
	            jnz   cnum1                       	;brinca a convertir numero dos
	            mov   di, offset num1d+1
	            mov   cx,[di]
                    push cx
                    xor ch,ch
                    cmp cx,4
                    jb wrong2
                    pop cx
	            mov   si, offset num1d+2
	            jmp   cnum2
	cnum1:          
                  
	            mov   di, offset num2d+1
	            mov   cx,[di]
	            mov   si, offset num2d+2
                    push cx
                    xor ch,ch
                    cmp cx,4
                    jb wrong2
                    pop cx
	cnum2:          
	            xor   ch,ch
	            mov   di, offset potencia
	            dec   si
	            add   si,cx
	            xor   bx,bx
	            std
	cnum3:          
	            lodsb                             	;carga al
	            cmp   al,46h
	            ja    wrong
	            cmp   al,30h
	            jb    wrong
	            cmp   al,40h
	            ja    letras
	            cmp   al,40h
	            jb    numeros
	letras:         
	            sub   al,41h
	            add   al,0ah
	            jmp   convert
	numeros:        
	            sub   al,30h
	            jmp   convert
	convert:        
	            cbw                               	;convierte a palabra
	            mov   dx,[di]
	            mul   dx
	            add   bx,ax                       	;suma el resultado a bx
	            add   di,2
	            loop  cnum3                     
	            jmp   cnum4
	wrong:          
	            mov   ax,0008H
	            jmp   final
  	wrong2:          
                    pop cx
	            mov   ax,0036H
	            jmp   final			

	cnum4:          
	            cld
	            jmp   final
	final:          
	            ret
convertirHexa endp                                		;fin de la   conversion

	;------------------------------------------------------------------------
	;convierte de Hexadecimal a ascii
	;------------------------------------------------------------------------


convToOctal proc near
	                push  dx                          	;guarda en la pila
	                push  ax
	                mov   si, offset resultf          	;inicializa variable
	                add   si,11
	                mov   al,'$'
	                mov   [si],al
	                mov   si, offset resultf          	;inicializa variable
	                mov   cx, 10
	                mov   al, '*'
	conv2:          
	                mov   [si], al
	                inc   si
	                loop  conv2
	                pop   ax
	                pop   bx
	                mov   bx, ax
	                mov   ax, dx
	                mov   si, offset resultf          	;caddena donde guarda resultado
	                add   si, 11
	                mov   cx, 8                       	;divisor = 8

	obdig:          
	                dec   si
	                xor   dx, dx
	                div   cx
	                mov   di, ax
	                mov   ax, bx
	                div   cx
	                mov   bx, ax
	                mov   ax, di
	                add   dl, 30h                     	;convierte en asscii
	                mov   [si], dl                    	;se almacena
	                or    ax, ax                      	;si la palabra alta no es cero
	                jnz   obdig                       	; brinca a obtendigito
	                or    bx, bx                      	;si la palabra baja no es cero
	                jnz   obdig                       	; brinca a obtendigito
	                ret
convToOctal endp                                  		; fin de la conversion

	;------------------------------------------------------------------------
	;suma
	;------------------------------------------------------------------------

AddMethod proc near                               		;procedimiento que realiza la suma
	                xor   dx,dx
	                mov   ax,num1                     	;almacena numero 1
	                mov   bx,num2                     	;almacena numero 2
	                add   ax,bx                       	;realiza la suma
			jo  OverSuma
	                jnc   suma1                       	;si no hay acarreo
	                adc   dx,0                        	;si hay acarreo
			jmp suma1
					
	OverSuma: 	mov   dl,00h
	                mov   dh,10
	                push  ax
	                call  Acursor
	                mov   dx, offset limSup  ; informamos al usuario que supero los limites
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h
	                pop   ax
			jmp final1
	                		
	suma1:          
	                xor   dx,dx             ;evitamos un posible problema al imprimir
	                call  convierte_ascii
			jmp final1
	final1:
	                ret
AddMethod endp                                    	;final de la suma

	;------------------------------------------------------------------------
	;resta
	;------------------------------------------------------------------------

SubMethod proc near                               		;realiza la resta
	                xor   dx,dx
	                mov   ax,num1                     	;almacena numero 1
	                mov   bx, num2                    	;almacena numero 2
			cmp ax,bx
	                sub   ax, bx                      	;hace la resta
			jo  OverResta
	                jnc   resta1                      	;si no hay acarreo
	                sbb   dx,0                        	;si hay acarreo
			jmp resta1

	OverResta: 	mov   dl,00h
	                mov   dh,10
	                push  ax
	                call  Acursor
	                mov   dx, offset limSup  ; informamos al usuario que supero los limites
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h
	                pop   ax
			jmp final2
	resta1:         

			xor   dx,dx
	                call  convierte_ascii
	final2:
	                ret
SubMethod endp                                    		;final de la resta
	;------------------------------------------------------------------------
	;multiplicacion
	;------------------------------------------------------------------------
MulMethod proc near                               		;procedimeinto que multiplica
	                xor   dx,dx
	                mov   ax,num1
	                mov   bx,num2
	                mul   bx
                        jo OverMul
			jmp mul1
OverMul: 	        mov   dl,00h
	                mov   dh,10
	                push  ax
	                call  Acursor
	                mov   dx, offset limSup  ; informamos al usuario que supero los limites
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h
	                pop   ax
			jmp final3

mul1:
	                xor   dx,dx
	                call  convierte_ascii
final3:
	                ret
MulMethod endp

	;------------------------------------------------------------------------
	;division
	;------------------------------------------------------------------------
divisionMethod proc near                          		;realiza la division
	                xor   dx,dx
	                mov   ax,num1
	                mov   bx,num2
	                cmp   bx,0000h  ;antes de hacer la division compara bx con Cero
	                je    esCero
	                div   bx
			jo OverDiv
	                cmp   dx,0000h ; evalua el residuo
	                jne   residuo
	                jmp   convAs

   OverDiv: 	        mov   dl,00h
	                mov   dh,10
	                push  ax
	                call  Acursor
	                mov   dx, offset limSup  ; informamos al usuario que supero los limites
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h
	                pop   ax
			jmp endo
	
	residuo:        
	                mov   dl,00h
	                mov   dh,10
	                push  ax
	                call  Acursor
	                mov   dx, offset exisRe  ; informamos al usuario que hay residuo
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h
	                pop   ax
	                xor   dx,dx
	                jmp   convAs
	esCero:         
	                mov   dl,00h
	                mov   dh,10
	                call  Acursor
	                mov   dx, offset divporCero ;informamos que el denominador es cero
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h
	                jmp   endo
	convAs:         
	                call  convierte_ascii
	endo:           
	                ret
divisionMethod endp

 

	;------------------------------------------------------------------------
	;convierte a ascii
	;------------------------------------------------------------------------

convierte_ascii proc near
	                call  convToOctal                 	;convierte a asscii
	                mov   dl,0                        	;posicion del cursor
	                mov   dh,10
	                call  Acursor
	                mov   dx,offset result            	;muestra mensaje
	                call  cout
	                mov   dx,offset resultf           	;muestra resultado
	                call  cout
	                mov   ah,0                        	;captura la tecla
	                int   16h

	                ret
convierte_ascii endp

	; -------------------------------------------------------------------
	;                 despejar pantalla
	; -------------------------------------------------------------------
clrscr proc near
	                mov   ax,0600h
	                mov   bh,31h
	                mov   cx,0000
	                mov   dx,184fh
	                int   10h ; muestra texto en pantalla sin llamar al int 21h
	                ret
clrscr endp
	; -------------------------------------------------------------------
	;                 posiciona Acursor
	; -------------------------------------------------------------------

Acursor proc near                                 		;posiciona el cursor el la fila 0 columna 0
	                mov   bh,0
	                mov   ah,2
	                int   10h
	                ret
Acursor endp
              
stack
end main ;final del programa
