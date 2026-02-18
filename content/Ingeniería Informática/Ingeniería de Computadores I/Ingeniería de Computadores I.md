#Organización/Estructura/Índice 

1. Estructura de un computador.
	1. [[1.1 Componentes de un computador|Componentes de un computador]].
	2. [[1.2 Función de un computador|Función de un computador]].
		1. [[1.2.1 Ciclos de búsqueda y ejecución|Ciclos de búsqueda y ejecución]].
		2. [[1.1.2 Ejemplo. Ejecución de una instrucción|Ejemplo: Ejecución de una instrucción]].
		3. [[1.2.3 Diagrama de flujo del ciclo de instrucción|Diagrama de flujo del ciclo de instrucción]].
		4. [[1.2.4 El ciclo de interrupción|El ciclo de interrupción]].
		5. [[1.2.5 Función de E-S|Función de E-S]].
	3. [[1.3 Estructuras de interconexión|Estructuras de interconexión]].
	4. [[1.4 Interconexión mediante bus|Interconexión mediante bus]].
	    1. [[1.4.1 Diagramas de temporización|Diagramas de temporización]].
	    2. [[1.4.2 Estructura de bus|Estructura de bus]].
	    3. [[1.4.3 Estructura jerárquica de buses|Estructura jerárquica de buses]].
	    4. [[1.4.4 Elementos de diseño del bus|Elementos de diseño del bus]].
	    5. [[1.4.5 Consideraciones prácticas en la conexión mediante bus|Consideraciones prácticas en la conexión mediante bus]].
	    6. [[1.4.6 Ejemplo de estructura del bus. El Unibus|Ejemplo de estructura del bus. El Unibus]].
	5. [[1.5 Conclusiones|Conclusiones]].
	6. [[1.6 Ejercicios de autoevaluación|Ejercicios de autoevaluación]].
	7. [[1.7 Problemas|Problemas]].
2. Unidad de memoria.
	1. [[2.1 Definiciones y conceptos básicos|Definiciones y conceptos básicos]].
		1. [[2.1.1 Localización|Localización]].
		2. [[2.1.2 Capacidad|Capacidad]].
		3. [[2.1.3 Unidad de transferencia|Unidad de transferencia]].
		4. [[2.1.4 Método de acceso|Método de acceso]].
		5. [[2.1.5 Tipos físicos|Tipos físicos]].
		6. [[2.1.6 Características físicas|Características físicas]].
		7. [[2.1.7 Velocidad|Velocidad]].
		8. [[2.1.8 Organización|Organización]].
		9. [[2.1.9 Resumen de características y propiedades de la memoria|Resumen de características y propiedades de la memoria]].
	2. [[2.2 Jerarquía de memorias|Jerarquía de memorias]].
		1. [[2.2.1 Ejemplo. Sistema con 2 niveles de memoria|Ejemplo: Sistema con 2 niveles de memoria]].
	3. [[2.3 Memorias de semiconductor|Memorias de semiconductor]].
		1. [[2.3.1 Características generales de un CIM|Características generales de un CIM]].
		2. [[2.3.2 Ejemplo. Cálculo del número de ciclos de reloj en los acceso a memoria|Ejemplo: Cálculo del número de ciclos de reloj en los acceso a memoria]].
		3. [[2.3.3 Estructura de la celda básica de memoria|Estructura de la celda básica de memoria]].
		4. [[2.3.4 Organización interna|Organización interna]].
		5. [[2.3.5 Diseño de bloques de memoria|Diseño de bloques de memoria]].
		6. Conexión de la unidad de memoria al bus del sistema.
		7. Estructura y direccionamiento de la unidad de memoria.
	4. Memorias asociativas.
		8. Ejemplo: Concepto de memoria asociativa.
		9. Estructura de una memoria asociativa.
		10. Ejemplo de una memoria asociativa.
		11. Determinación de la función lógica del registro de marca.
		12. Operación de lectura.
		13. Operación de escritura.
		14. Ejemplo: Diseño de una memoria asociativa.
	5. Memorias caché.
		1. Capacidad de la memoria caché.
		2. Organización de la memoria caché.
		3. Algoritmos de reemplazamiento.
		4. Estrategia de escritura.
		5. Rendimiento de una memoria caché.
		6. Ejemplo: Cálculo del rendimiento de una memoria caché.
		7. Tamaño del bloque.
		8. Número de cachés.
	6. Discos magnéticos.
		1. Estructura física.
		2. Ejemplo: Acceso a un archivo de acceso secuencial y aleatorio.
		3. Controlador del disco.
		4. Planificación del disco.
	7. Conclusiones.
	8. Ejercicios de autoevaluación.
	9. Problemas.
3. Unidad de entrada-salida.
	1. Dispositivos externos.
	2. Controlador de E/S.
		1. Funciones del controlador de E/S.
		2. Estructura del controlador de E/S.
		3. Estructura del sistema de E/S.
	3. E/S controlada por programa.
		1. Órdenes de E/S.
		2. Instrucciones de E/S.
		3. Ejemplo: Transferencia de E/S controlada por programa en el 68000.
	4. E/S por interrupciones.
		1. Clasificación de las interrupciones.
		2. Origen de las interrupciones.
		3. Número de líneas de interrupción.
		4. Control de la CPU sobre la interrupción.
		5. Identificación de la fuente de la interrupción y gestión de su prioridad.
		6. Niveles de interrupción.
		7. Controlador de interrupciones.
		8. Ejemplos de controladores de interrupciones.
		9. Estructura de interrupciones del 68000.
	5. Acceso directo a memoria (DMA).
		1. Controlador de DMA.
		2. Transferencia de datos mediante DMA.
		3. Configuración del DMA.
	6. Procesador de E/S (PE/S).
		1. Características de los PE/S.
		2. Clasificación de los PE/S.
	7. Conclusiones.
	8. Ejercicios de autoevaluación.
	9. Problemas.
4. Unidad aritmético-lógica.
	1. Sumadores binarios.
		1. Semisumador binario (SSB).
		2. Sumador binario completo (SBC).
		3. Sumador binario serie.
		4. Sumador binario paralelo con propagación del arrastre.
		5. Sumador-restador binario paralelo con propagación del arrastre.
	2. Sumadores de alta velocidad.
		1. Características de los arrastre.
		2. Sumadores con anticipación del arrastre.
	3. Sumadores en código BCD.
		1. Organización de los sumadores en código BCD.
	4. Multiplicadores binarios.
		1. Multiplicación de “lápiz y papel” de números sin signo.
		2. Mejoras en el algoritmo de “lápiz y papel”.
		3. Multiplicación en complemento a 2: Algoritmo de Booth.
		4. Ejemplo: Algoritmo de Booth.
	5. Unidad aritmético-lógica (ALU).
		1. ALU’s integradas.
	6. Operaciones de desplazamiento.
		1. Clasificación de las operaciones de desplazamiento.
		2. Ejemplo: Diseño de un registro de desplazamiento de 4 bits.
		3. Estructura de los registros de desplazamiento.
	7. Operaciones de comparación.
		1. Utilizando un circuito combinacional.
		2. Utilizando un circuito secuencial.
		3. Utilizando un sumador.
	8. Conclusiones.
	9. Ejercicios de autoevaluación.
	10. Problemas.
5. Transferencia entre registros.
	1. Diseño jerárquico de un sistema digital.
	2. Nivel de transferencia entre registros.
		1. Representación.
		2. Expansibilidad de los componentes.
	3. Estructura de un sistema digital.
		1. Componentes de un sistema digital.
		2. Puntos de control.
		3. Modelo de Glushkov.
	4. Máquinas de estados algorítmicas (ASM).
	5. Ejemplo: multiplicador binario.
		1. Multiplicador binario.
		2. Unidad de procesamiento o ruta de datos del multiplicador.
		3. Diagrama ASM del multiplicador.
		4. Unidad de control con lógica cableada.
		5. Unidad de control con elementos de memoria tipo D.
		6. Unidad de control con un elemento de memoria por estado.
		7. Unidad de control con un registro de estado y una memoria ROM.
		8. Unidad de control con un registro de estado y un PLA.
		9. Resumen del procedimiento de diseño a nivel de registro.
	6. Conclusiones.
	7. Ejercicios de autoevaluación.
	8. Problemas.
6. Diseño del procesador.  
	1. Repertorio de instrucciones.  
		1. Procesadores de tres direcciones.  
		2. Procesadores de dos direcciones.  
		3. Procesadores de una dirección (procesadores con acumulador).  
		4. Procesadores de cero direcciones (procesadores con pila).  
		5. Procesadores sin ALU.  
		6. Análisis de las diferentes arquitecturas de procesadores.  
		7. Procesadores con banco de registros.  
		8. Arquitectura de carga/almacenamiento: Procesadores RISC.  
	2. Modos de direccionamiento.  
	3. Ciclo de ejecución de una instrucción.  
		1. Fase de búsqueda de la instrucción.  
		2. Fase de decodificación de la instrucción.  
		3. Fase de búsqueda de los operandos.  
		4. Fase de ejecución de la instrucción.  
		5. Transferencia a un subprograma.  
		6. Ciclo de interrupción.  
	4. Fases en el diseño del procesador.  
	5. Diseño de un procesador elemental.  
		1. Especificación del procesador SIMPLEI.  
		2. Repertorio de instrucciones.  
		3. Diagrama de flujo del repertorio de instrucciones.  
		4. Asignación de recursos a la unidad de procesamiento o ruta de datos.  
		5. Obtención del diagrama ASM del procesador.  
		6. Diseño de la unidad de control con lógica cableada.  
		7. Diseño de la unidad de procesamiento o ruta de datos.  
	6. Introducción a la microprogramación.  
		1. Modelo original de Wilkes.  
		2. Estructura de una unidad de control microprogramada.  
		3. Elementos de una unidad de control microprogramada.  
		4. Secuenciamiento de las microinstrucciones.  
		5. Organización de la memoria de control.  
		6. Ejecución de las microinstrucciones.  
	7. Conclusiones.  
	8. Ejercicios de autoevaluación.  
	9. Problemas.