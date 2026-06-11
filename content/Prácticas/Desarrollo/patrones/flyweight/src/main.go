package main

import (
	"fmt"
	"math/big"
	"time"
)

const limite = 500_000

type Impresion int

const (
	Ninguno Impresion = iota
	Ultimo
	Todo
)

const nivelImpresion = Ninguno

// ── Cronómetro ────────────────────────────────────────────────────────────────
// Go no tiene destructores, así que se usa defer + clausura,
// que es el patrón idiomático equivalente al Drop de Rust.

func cronometro(etiqueta string) func() {
	inicio := time.Now()
	return func() {
		fmt.Printf("⏱️  [%s] Fin de ejecución. Duración: %v\n", etiqueta, time.Since(inicio))
	}
}

// ── Interfaz ──────────────────────────────────────────────────────────────────

type CalcularFibonacci interface {
	calcular()
}

// ── Implementación 1: Caché ───────────────────────────────────────────────────

type FibonacciCache struct {
	limite    int
	impresion Impresion
	nombre    string
}

func newFibonacciCache() FibonacciCache {
	return FibonacciCache{limite: limite, impresion: nivelImpresion, nombre: "FibonacciCache"}
}

func (f FibonacciCache) calcular() {
	defer cronometro(f.nombre)()

	cache := make([]*big.Int, f.limite+1)
	cache[0] = big.NewInt(0)
	cache[1] = big.NewInt(1)

	for i := 2; i <= f.limite; i++ {
		cache[i] = new(big.Int).Add(cache[i-1], cache[i-2])
		if f.impresion == Todo {
			fmt.Printf("%d : %s\n", i, cache[i].String())
		}
	}

	if f.impresion == Ultimo {
		fmt.Printf("%d : %s\n", f.limite, cache[f.limite].String())
	}
}

// ── Implementación 2: Iterativa ───────────────────────────────────────────────

type FibonacciIterativo struct {
	limite    int
	impresion Impresion
	nombre    string
	memSwap   bool
}

func newFibonacciIterativo(nombre string, memSwap bool) FibonacciIterativo {
	return FibonacciIterativo{limite: limite, impresion: nivelImpresion, nombre: nombre, memSwap: memSwap}
}

func (f FibonacciIterativo) calcular() {
	defer cronometro(f.nombre)()

	a := big.NewInt(0)
	b := big.NewInt(1)

	if f.memSwap {
		// Equivalente al mem::swap de Rust: Add modifica 'a' en su propio
		// espacio de memoria y luego se intercambian los punteros.
		for i := 2; i <= f.limite; i++ {
			a.Add(a, b)
			a, b = b, a
		}
	} else {
		siguiente := new(big.Int)
		for i := 2; i <= f.limite; i++ {
			siguiente.Add(a, b)
			a.Set(b)
			b.Set(siguiente)
		}
	}

	if f.impresion == Ultimo {
		fmt.Printf("%d : %s\n", f.limite, b.String())
	}
}

// ── Implementación 3: Doblado rápido ─────────────────────────────────────────

type FibonacciDoblado struct {
	limite    int
	impresion Impresion
	nombre    string
}

func newFibonacciDoblado(nombre string) FibonacciDoblado {
	return FibonacciDoblado{limite: limite, impresion: nivelImpresion, nombre: nombre}
}

func helperDoblado(n int) (*big.Int, *big.Int) {
	if n == 0 {
		return big.NewInt(0), big.NewInt(1)
	}

	fk, fk1 := helperDoblado(n >> 1)

	// F(2k) = F(k) · (2·F(k+1) − F(k))
	dosFk1 := new(big.Int).Lsh(fk1, 1)        // 2·F(k+1)
	c := new(big.Int).Mul(fk, dosFk1.Sub(dosFk1, fk))

	// F(2k+1) = F(k)² + F(k+1)²
	d := new(big.Int).Add(
		new(big.Int).Mul(fk, fk),
		new(big.Int).Mul(fk1, fk1),
	)

	if n&1 == 0 {
		return c, d
	}
	return d, new(big.Int).Add(c, d)
}

func (f FibonacciDoblado) calcular() {
	defer cronometro(f.nombre)()

	resultado, _ := helperDoblado(f.limite)

	if f.impresion == Ultimo {
		fmt.Printf("%d : %s\n", f.limite, resultado.String())
	}
}

// ── Main ──────────────────────────────────────────────────────────────────────

func main() {
	newFibonacciCache().calcular()
	newFibonacciIterativo("FibonacciIterativo", false).calcular()
	newFibonacciIterativo("FibonacciIterativoMemSwap", true).calcular()
	newFibonacciDoblado("FibonacciDoblado").calcular()
}