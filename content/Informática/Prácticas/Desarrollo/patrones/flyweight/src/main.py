import time
from abc import ABC, abstractmethod
from contextlib import contextmanager
from enum import Enum, auto


# ── Constantes ────────────────────────────────────────────────────────────────

LIMITE = 500_000

class Impresion(Enum):
    NINGUNO = auto()
    ULTIMO  = auto()
    TODO    = auto()

NIVEL_IMPRESION = Impresion.NINGUNO


# ── Cronómetro (gestor de contexto, equivalente al Drop de Rust) ───────────────

@contextmanager
def cronometro(etiqueta: str):
    inicio = time.perf_counter()
    try:
        yield
    finally:
        duracion = time.perf_counter() - inicio
        print(f"⏱️  [{etiqueta}] Fin de ejecución. Duración: {duracion:.6f}s")


# ── Interfaz base ──────────────────────────────────────────────────────────────

class CalcularFibonacci(ABC):
    @abstractmethod
    def calcular(self) -> None: ...


# ── Implementación 1: Caché (lista completa) ───────────────────────────────────

class FibonacciCache(CalcularFibonacci):
    def __init__(
        self,
        limite: int = LIMITE,
        impresion: Impresion = NIVEL_IMPRESION,
    ) -> None:
        self.limite    = limite
        self.impresion = impresion
        self.nombre    = "FibonacciCache"

    def calcular(self) -> None:
        with cronometro(self.nombre):
            cache: list[int] = [0, 1]

            if len(cache) > self.limite:
                return

            for i in range(len(cache), self.limite + 1):
                siguiente = cache[i - 1] + cache[i - 2]
                cache.append(siguiente)
                if self.impresion == Impresion.TODO:
                    print(f"{i} : {cache[i]}")

            if self.impresion == Impresion.ULTIMO:
                print(f"{self.limite} : {cache[-1]}")


# ── Implementación 2: Iterativa (con y sin intercambio de variables) ───────────

class FibonacciIterativo(CalcularFibonacci):
    def __init__(
        self,
        nombre: str,
        mem_swap: bool,
        limite: int = LIMITE,
        impresion: Impresion = NIVEL_IMPRESION,
    ) -> None:
        self.limite    = limite
        self.impresion = impresion
        self.nombre    = nombre
        self.mem_swap  = mem_swap

    def calcular(self) -> None:
        with cronometro(self.nombre):
            a, b = 0, 1

            if self.mem_swap:
                # Desempaquetado de tupla: equivalente al mem::swap de Rust.
                # Python reutiliza objetos int pequeños, pero para BigInt el
                # compilador CPython igual crea nuevos objetos; el patrón es
                # idiomático y evita una variable temporal explícita.
                for _ in range(2, self.limite + 1):
                    a, b = b, a + b
            else:
                # Versión explícita con variable temporal (espejo exacto del Rust)
                for _ in range(2, self.limite + 1):
                    siguiente = a + b
                    a = b
                    b = siguiente

            if self.impresion == Impresion.ULTIMO:
                print(f"{self.limite} : {b}")


# ── Implementación 3: Doblado rápido (fast doubling) ──────────────────────────

class FibonacciDoblado(CalcularFibonacci):
    def __init__(
        self,
        nombre: str,
        limite: int = LIMITE,
        impresion: Impresion = NIVEL_IMPRESION,
    ) -> None:
        self.limite    = limite
        self.impresion = impresion
        self.nombre    = nombre

    def calcular(self) -> None:
        with cronometro(self.nombre):
            resultado = self._helper(self.limite)[0]

            if self.impresion == Impresion.ULTIMO:
                print(f"{self.limite} : {resultado}")

    @staticmethod
    def _helper(n: int) -> tuple[int, int]:
        """Devuelve (F(n), F(n+1)) mediante doblado recursivo."""
        if n == 0:
            return (0, 1)

        fk, fk1 = FibonacciDoblado._helper(n >> 1)   # k = n // 2

        # F(2k)   = F(k) · (2·F(k+1) − F(k))
        c = fk * (2 * fk1 - fk)
        # F(2k+1) = F(k)² + F(k+1)²
        d = fk * fk + fk1 * fk1

        if n & 1 == 0:
            return (c, d)           # n par  → (F(2k),   F(2k+1))
        else:
            return (d, c + d)       # n impar → (F(2k+1), F(2k+2))


# ── Punto de entrada ───────────────────────────────────────────────────────────

def main() -> None:
    FibonacciCache().calcular()
    FibonacciIterativo("FibonacciIterativo",        mem_swap=False).calcular()
    FibonacciIterativo("FibonacciIterativoMemSwap", mem_swap=True ).calcular()
    FibonacciDoblado  ("FibonacciDoblado"                         ).calcular()


if __name__ == "__main__":
    main()