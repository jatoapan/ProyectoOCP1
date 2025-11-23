# 🏆 Proyecto de Organización de Computadores: Juego de los Tesoros

Este proyecto fue desarrollado para la asignatura **Organización de Computadores (CCPG1049)** de la **Escuela Superior Politécnica del Litoral (ESPOL)**. Consiste en la implementación de un juego de búsqueda de tesoros por turnos utilizando el lenguaje ensamblador **MIPS32**.

---

## 🧑‍💻 Elaborado por

* **TOAPANTA DOMINGUEZ JOSE ANDRES**
* **PARRALES VILLACRESES DIEGO XAVIER**

---

## 🌟 Objetivos del Proyecto

* Implementar un programa en lenguaje de nivel medio (ensamblador MIPS) para comprender la ejecución de las instrucciones llevadas a cabo por el procesador.
* Investigar nuevas instrucciones para el uso de diferentes tipos y estructuras de datos.
* Implementar funciones (subrutinas) para un mejor comportamiento del código, facilitando la depuración y el seguimiento del flujo de ejecución.

---

## 🎮 Reglas Principales del Juego

El juego simula una búsqueda de tesoros entre un jugador y la máquina en un tablero unidimensional de casillas.

| Característica | Detalle |
| :--- | :--- |
| **Tablero** | El usuario elige el tamaño entre **20 y 120 casillas** (validado). |
| **Tesoros** | El **30% del total de casillas** contienen un tesoro. Se representan internamente con el valor centinela **-1**. |
| **Dinero** | Las casillas restantes contienen cantidades aleatorias entre **$10 y $100**. |
| **Movimiento** | El Jugador avanza **1 a 6** casillas. La Máquina avanza con un dado aleatorio entre **1 y 6**. |
| **Finalización** | El juego termina cuando uno encuentra **3 tesoros** o cuando **ambos llegan al final del tablero**. |
| **Turnos Extra** | Si un jugador llega al final primero, el otro debe seguir jugando hasta completar su recorrido. |
| **Determinación del Ganador** | Si nadie encuentra 3 tesoros, gana el jugador con **más dinero acumulado**. En caso de empate, se decide por **más tesoros**. |
| **Premio** | El ganador se lleva el **dinero total acumulado de los 2 jugadores**. |

---

## ⚙️ Especificaciones Técnicas

### 1. Requisitos del Sistema

* **Simulador:** **MARS** (MIPS Assembler and Runtime Simulator) versión **4.5**.
* **Arquitectura:** Conjunto de instrucciones **MIPS32**.
* **Entorno de Ejecución:** Java Runtime Environment (JRE) o OpenJDK (versión 8 o superior).

### 2. Características de la Implementación en MIPS

* **Gestión de Memoria Dinámica (Heap):** El proyecto utiliza **asignación dinámica de memoria** mediante el `syscall 9` (`sbrk`). El tamaño del tablero se define en tiempo de ejecución, optimizando el uso de recursos.
* **Gestión de la Pila (Stack):** Se implementó un manejo estricto del puntero de pila (`$sp`) para preservar los registros guardados (`$s0-$s7`) y la dirección de retorno (`$ra`) durante las llamadas a subrutinas anidadas.
* **Generación Aleatoria:** Uso del **syscall 42** para la distribución estocástica de tesoros y la simulación de los lanzamientos de dados.
* **Validación Robusta:** Sistema de control de entrada que restringe el tamaño del tablero al intervalo `[20, 120]` y los valores de los dados al rango `[1, 6]`.

---

## 🚀 Guía de Ejecución (Entorno Linux/WSL)

El proyecto está diseñado para ejecutarse en modo consola (CLI) utilizando el emulador MARS.

### 1. Verificación de Archivos

Asegúrese de contar con los siguientes archivos en el mismo directorio de trabajo:

* `Mars4_5.jar` (Emulador MARS).
* `proyecto.asm` (Código fuente en ensamblador MIPS).

### 2. Comando de Ejecución

Para iniciar el programa sin la interfaz gráfica, se invoca a la Máquina Virtual de Java (JVM):

```bash
java -jar Mars4_5.jar nc proyecto.asm
```

El argumento `nc` (`No Copyright`) indica la ejecución en modo consola. El simulador carga el programa e inicia la interacción solicitando el tamaño del tablero.

---

## 📂 Archivos Adicionales Incluidos

Además del código fuente en ensamblador MIPS (`proyecto.asm`), el repositorio incluye:

* **`proyecto.c`**: Código fuente del juego implementado en lenguaje C, utilizado como referencia durante el desarrollo.
* **`proyecto.exe`**: El ejecutable binario compilado a partir del código C (para uso en Windows).

---

## 💡 Posibles Mejoras a Futuro

* **Interfaz Gráfica (Bitmap Display):** Utilizar la herramienta **Bitmap Display** del simulador MARS para visualizar el tablero, los jugadores y los tesoros mediante píxeles de colores, ofreciendo una experiencia visual más intuitiva.
* **Persistencia de Datos:** Implementar un sistema de guardado y carga de partida utilizando los `syscalls` de manejo de archivos (`13`, `14`, `15`) para almacenar el estado del juego en un archivo externo y reanudarlo posteriormente.
* **Manejo Avanzado de Excepciones:** Mejorar la validación de entrada implementando un manejador de excepciones o leyendo la entrada como `string` para validar el código ASCII de cada carácter y evitar errores si el usuario ingresa caracteres no numéricos.
* **Mecánicas de Juego Extendidas:** Introducir nuevos valores centinelas (e.g., trampas o teletransportes) para aumentar la complejidad algorítmica y expandir la lógica de ramificación dentro de la subrutina `actualizar_datos`.