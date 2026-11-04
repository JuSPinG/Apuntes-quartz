# Guía de conceptos

1. [[#CIS: _Communications and Information Systems_|CIS: Communications and Information Systems]].
2. [[#SIC: _Security of Classified Information_|SIC: Security of Classified Information]].
3. [[#Grados de clasificación]].
4. [[#HPS: Habilitación Personal de Seguridad]].
5. [[#Instrucción de seguridad]].
6. [[#ONS: Oficina Nacional de Seguridad]].
7. [[#^5489bf|ZAP: Zona Administrativa de Protección]].
8. [[#^d24a11|ZAR: Zona de Alta Restricción]].
9. [[#IC: Información Clasificada]].
10. [[#^892150|CNI: Centro Nacional de Inteligencia]].
11. [[#^bd04f3|CCN: Centro Criptológico Nacional]].
12. [[#^71e7bd|ENS: Esquema Nacional de Seguridad]].
13. STIC: Seguridad de las Tecnologías de la Información y Comunicación.

# Desarrollo de conceptos

## CIS: _Communications and Information Systems_

Cualquier sistema formado por _hardware_, _software_, y redes y procedimientos que permite procesar, almacenar o transmitir información

Puede contener información clasificada.

## SIC: _Security of Classified Information_

Sistema autorizado que puede tratar información clasificada. Cumple con la normativa de seguridad y está acreditada.

$$\text{SIC}\in \text{CIS}$$
## Grados de clasificación

En España, y en orden:

1. Secreto: El más grado de protección. Su difusión no autorizada es extremadamente grave para la seguridad del Estado.
2. Reservado: Alto grado de protección. Su difusión no autorizada puede dar lugar a una amenaza para los intereses del Estado.
3. Confidencial: Se aplicará a la información cuya revelación no autorizada pudiera dar lugar a una amenaza.
4. Difusión limitada: Se aplicará a la información cuya revelación pudiera ser contraria a los intereses de España.

| OTAN              | UE                             | ESA              |
| ----------------- | ------------------------------ | ---------------- |
| Comic Top Secret  | EU Top Secret o Tres Secret UE | ESA Top Secret   |
| NATO Secret       | Secret UE                      | ESA Secret       |
| NATO Confidencial | Confidentiel UE                | ESA Confidential |
| NATO Restricted   | Restreint UE                   | ESA Restricted   |
| NATO Unclassified | Limite UE                      | ESA Unclassified |

## HPS: Habilitación Personal de Seguridad

Es la autorización que permite a una persona acceder a información clasificada hasta un determinado nivel (Nacional, UE, OTAN), tras haber sido acreditado.

Ser HPS no significa poder ver toda la información. Solo se accede a la información que realmente se necesita conocer. La validez del HPS es de 5 años.

## Instrucción de seguridad

Aquellas consignas y conocimientos que deben ser compartidos a cada trabajador para mantenerle informado de las amenazas de seguridad, hacerle consciente de sus vulnerabilidades y sus responsabilidades.

## ONS: Oficina Nacional de Seguridad

Integrada en el CNI, es responsable de expedir las habilitaciones personas de seguridad ([[#HPS Habilitación Personal de Seguridad|HPS]]) como materias clasificadas del MDEF.

## Zonificación

1. ZAP (Zona Administrativa de Protección): Actúa como un perímetro de control autodeclarado al que se accede antes de acceder al sistema. Almacena y maneja información hasta el grado de difusión limitada. ^5489bf
2. ZAR (Zona de Alta Restricción): Aquí se encuentran los equipos que realmente procesan información clasificada. Son las instalaciones donde se almacena o maneja la Información Clasificada de grado confidencial o superior. ^d24a11
	1. Área del Clase I: La entrada a la zona supone, a todos los efectos, el acceso a la información clasificada.
	2. Área de Clase II: La IC está protegida del acceso de personas no autorizadas mediante controles establecidos internamente.
## IC: Información Clasificada

Cualquier información o material cuya divulgación no autorizada afecta a la seguridad nacional o a intereses estratégicos. Posee [[#Grados de clasificación]] y el incumplimiento de su seguridad trae consecuencias legales.

Para acceder a la información clasificada, será necesario tener el [[#HPS: Habilitación Personal de Seguridad|HPS]] y tener el principio de necesidad de conocer (_need to know_).

Las Materias Clasificadas, establecidas por la Ley 9/1968 y modificada por la Ley 48/1978 (Ley de Secretos Oficiales, LSO), establece los niveles: secreto y reservado.

Por otro lado, las Materias Objeto de Reserva Interna serán las confidenciales y difusión limitada.

### Seguridad física

La seguridad integral se basa en proteger al personal, la información, y los sistemas. También se emplean métodos de la defensa en profundidad, donde es necesario atravesar varias protecciones antes de llegar a lo verdaderamente protegido.

Entornos de seguridad:

1. EGS (Entorno Global de Seguridad): Perímetro que protege la zona restringida.
2. ELS (Entorno Local de Seguridad): Medidas internas de accesos, paredes y zonas cercanas a la IC.
3. ESE (Entorno de Seguridad Electrónico): Protección frente a fugas de información (TEMPEST y escuchas).

### Seguridad en el personal

Garantiza que el personal sea [[#HPS: Habilitación Personal de Seguridad|HPS]]. Los siguientes deben cumplirlo.

1. El personal que pertenece al órgano de control.
2. Los usuarios de los documentos clasificados que sirvan a dicho control.

### Seguridad de la información

Se da cuando se aplican una serie de medidas y procedimientos para el correcto manejo de la información clasificada (DICTA).

### Directrices generales para la gestión de la IC

Nunca debemos:

1. Gestionar IC al margen las indicaciones establecidas.
2. Remitir IC por canales no autorizados.
3. Extraer IC del ZAR donde se encuentre.
4. Proporcionar IC a personas ajenas al proyecto.
5. Hacernos cargo de IC, en vez de acudir a responsables.
6. Conectar sistemas clasificados a Internet.
7. Hacer CRUD de IC sin autorización previa.
### Amenazas y vulnerabilidades

1. Personas ajenas al proyecto o desconocidas.
2. Un amigo que nos sonsaca información.

## Marco Normativo en España

1. CNI: Encargado de velar por el artículo 4º apartado "f" de la Ley 11/2002, que establece que debe "velar por el cumplimiento de la normativa de la protección de la IC". ^892150
2. CCN: Organismo responsable de definir políticas de seguridad TIC para el sector público. ^bd04f3
3. ENS: Establece los mínimos de la seguridad de la información y los servicios que deben cumplir las AA.PP. Regulado por el Real Decreto 311/2022. El ENS es gestionado y liderado por el CCN-CERT (Equipo de Respuesta ante Incidentes de Seguridad de la Información del Centro Criptológico Nacional). Su metodología es la siguiente: ^71e7bd
	1. Nivel de seguridad ante una posible incidencia (DICTA): bajo, medio alto. Acorde al Declaración de Requerimientos de Seguridad ([[#^b87451|DRS]]). ^849768
	2. Categoría del sistema de acuerdo con las [[3. Implementación de las Medidas de Seguridad|73 medidas del ENS]]: básica, media, alta. Estas medidas se dividen.
		1. Marco Organizativo: relacionado con la organización global de seguridad, burocrático.
		2. Marco Operacional: relacionado con de la creación de procedimientos formales; protege el sistema como conjunto integral.
		3. Medidas de Protección: protege activos concretos.

## Marco Normativo en Europa

En Europa no tienen ENS, tienen el NIS. Alguna de sus características son:

1. Regulado por la Directiva UE 2022/2555 - NIS2.
2. Armoniza la seguridad entre los Estados miembro.
3. Fomenta la cooperación y la respuesta con el CSIRT.

# Proceso de creación de un CIS

Cuando se inicia un proyecto, lo primero es analizar los requisitos del cliente, el alcance del sistema y la infraestructura prevista. Así se establecen los activos el sistema y las necesidades de seguridad (junto con su diseño y esquema de red)

Una vez creado, es necesario identificar amenazas, vulnerabilidades y otros posibles impactos sobre el sistema.
1. Herramientas PILAR: Ayuda a automatizar la gestión de amenazas e impactos.

2. Revisión de propuesta.
	1. Archivos del sistema.
		1. Servidores.
		2. Clientes.
		3. Dispositivos de seguridad.
		4. Aduana.
	2. Aplicaciones.
		1. Tipos de licencia.
	3. Forma de conexión.
	4. Particularidades.
3. Planteamiento inicial.
	1. Creación del diagrama (VISO).
		1. PNG.
		2. VSDX.
	2. Desarrollo de AARR (PILAR).
		1. Metodología MAGERIT: Permite identificar metodología de análisis y gestión de riesgos.
		2. MGR.
		3. Gráfico de araña.
		4. RTF.
		5. Informe de Análisis de Riesgos (AARR).
4. Configuración de sistemas.
	1. Pre-bastionado.
	2. Bastionado, según las guías.
5. Análisis.
	1. CLARA: Informe de deficiencias y cumplimiento.
	2. Nessus: Vulnerabilidades.
6. [[#Documentación de seguridad]].
7. Comprobaciones finales.
	1. Red.
	2. Servicios.
	3. Procedimiento o aplicativos particulares.
	4. Revisión de entregables.
	5. Preparación de entregables de salidas SP.

# Documentación de seguridad

Esta es una lluvia de conceptos relacionada con la documentación de seguridad.

1. Diagrama de red.
2. Análisis de riesgos: Se identifican y evalúan riesgos que pueden afectar a un sistema de información, como activos, amenazas (lo que causa el ataque), vulnerabilidades (brecha de seguridad; por donde entra el ataque), impacto sobre los activos, probabilidad de ello. Su objetivo es determinar el riesgo y definir medidas.
3. CO (Concepto Operacional): Se define cómo se organiza y gestiona la seguridad del sistema desde el punto de vista operativo y organizativo.
	1. Roles de responsabilidades de seguridad, procedimientos de gestión de incidentes, normas de uso de los sistemas, gestión de los accesos y usuarios... La parte no técnica.
	2. Cómo deben actuar las personas y los procesos para mantener la seguridad del sistema de forma continua.
4. COS (Concepto Operacional de Seguridad): Describe cómo se implementará la seguridad del sistema en su funcionamiento diario. La parte técnica.
5. [[#^849768|DRS]]: Establece los requisitos de seguridad que debe cumplir el sistema antes de su desarrollo o implementación. ^b87451
	1. Controles de seguridad obligatorios.
	2. Requisitos de DICTA.
	3. Sirve para diseñar, implementar y evaluar la seguridad del sistema.
6. DRES (Documento de Requisitos Específicos de Seguridad): Requisitos de seguridad más detallados y específicos de un sistema concreto. Permite adaptar específicamente el DRS.
7. POS (Proceso de Operativos de Seguridad): Cómo se aplican en la práctica durante la operación diaria los controles y medidas de seguridad.
	1. Procedimiento del CRUD.
	2. Gestión de incidentes de seguridad.
	3. Procedimientos de la copia de seguridad.
	4. Actualización y mantenimiento de sistemas.
	5. Monitorización y registro de eventos de seguridad.
	6. Procedimientos ante situaciones de emergencia.
8. DRSI (Declaración de Requisitos de Seguridad de Interconexión): Documento que detalla cómo debe un sistema de información intercambiar datos con otros sistemas a través de redes externas. Por ello, establece múltiples medidas de seguridad.
	1. Qué se conecta.
	2. Qué tipo de información se intercambia.
	3. Medidas de seguridad aplicadas a la conexión, como el cifrado o la autenticación.
	4. Protocolos y mecanismos de comunicación.
	5. Responsabilidades de cada sistema.
	6. Medidas de monitorización y control de la interconexión.