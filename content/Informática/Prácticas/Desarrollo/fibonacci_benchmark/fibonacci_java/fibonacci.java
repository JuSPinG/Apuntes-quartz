import java.math.BigInteger;
import java.time.Duration;
import java.time.Instant;

public class fibonacci {

    static final int LIMITE = 500_000;

    enum Impresion { NINGUNO, ULTIMO, TODO }

    static final Impresion NIVEL_IMPRESION = Impresion.NINGUNO;

    // ── Cronómetro ────────────────────────────────────────────────────────────
    // Java no tiene RAII ni destructores. El patrón idiomático es
    // AutoCloseable + try-with-resources, que garantiza la ejecución del
    // bloque de cierre igual que el Drop de Rust o el defer de Go.

    static class Cronometro implements AutoCloseable {
        private final String etiqueta;
        private final Instant inicio;

        Cronometro(String etiqueta) {
            this.etiqueta = etiqueta;
            this.inicio   = Instant.now();
        }

        @Override
        public void close() {
            Duration duracion = Duration.between(inicio, Instant.now());
            long ms  = duracion.toMillis();
            long sec = duracion.toSeconds();
            System.out.printf("⏱️  [%s] Fin de ejecución. Duración: %d.%03ds%n",
                    etiqueta, sec, ms % 1000);
        }
    }

    // ── Interfaz ──────────────────────────────────────────────────────────────

    interface CalcularFibonacci {
        void calcular();
    }

    // ── Implementación 1: Caché ───────────────────────────────────────────────

    static class FibonacciCache implements CalcularFibonacci {
        private final int       limite;
        private final Impresion impresion;
        private final String    nombre;

        FibonacciCache() {
            this.limite    = LIMITE;
            this.impresion = NIVEL_IMPRESION;
            this.nombre    = "FibonacciCache";
        }

        @Override
        public void calcular() {
            try (var timer = new Cronometro(nombre)) {
                BigInteger[] cache = new BigInteger[limite + 1];
                cache[0] = BigInteger.ZERO;
                cache[1] = BigInteger.ONE;

                for (int i = 2; i <= limite; i++) {
                    cache[i] = cache[i - 1].add(cache[i - 2]);
                    if (impresion == Impresion.TODO) {
                        System.out.println(i + " : " + cache[i]);
                    }
                }

                if (impresion == Impresion.ULTIMO) {
                    System.out.println(limite + " : " + cache[limite]);
                }
            }
        }
    }

    // ── Implementación 2: Iterativa ───────────────────────────────────────────

    static class FibonacciIterativo implements CalcularFibonacci {
        private final int       limite;
        private final Impresion impresion;
        private final String    nombre;
        private final boolean   memSwap;

        FibonacciIterativo(String nombre, boolean memSwap) {
            this.limite    = LIMITE;
            this.impresion = NIVEL_IMPRESION;
            this.nombre    = nombre;
            this.memSwap   = memSwap;
        }

        @Override
        public void calcular() {
            try (var timer = new Cronometro(nombre)) {
                BigInteger a = BigInteger.ZERO;
                BigInteger b = BigInteger.ONE;

                // BigInteger es inmutable en Java: tanto add() como el
                // intercambio de referencias crean objetos nuevos siempre.
                // Las dos variantes son funcionalmente idénticas; se mantienen
                // para reflejar la estructura original.
                if (memSwap) {
                    for (int i = 2; i <= limite; i++) {
                        a = a.add(b);
                        BigInteger tmp = a; a = b; b = tmp;
                    }
                } else {
                    for (int i = 2; i <= limite; i++) {
                        BigInteger siguiente = a.add(b);
                        a = b;
                        b = siguiente;
                    }
                }

                if (impresion == Impresion.ULTIMO) {
                    System.out.println(limite + " : " + b);
                }
            }
        }
    }

    // ── Implementación 3: Doblado rápido ─────────────────────────────────────

    static class FibonacciDoblado implements CalcularFibonacci {
        private final int       limite;
        private final Impresion impresion;
        private final String    nombre;

        FibonacciDoblado(String nombre) {
            this.limite    = LIMITE;
            this.impresion = NIVEL_IMPRESION;
            this.nombre    = nombre;
        }

        private static BigInteger[] helper(int n) {
            if (n == 0) {
                return new BigInteger[]{ BigInteger.ZERO, BigInteger.ONE };
            }

            BigInteger[] prev = helper(n >> 1);
            BigInteger fk  = prev[0];
            BigInteger fk1 = prev[1];

            // F(2k) = F(k) · (2·F(k+1) − F(k))
            BigInteger c = fk.multiply(fk1.shiftLeft(1).subtract(fk));
            // F(2k+1) = F(k)² + F(k+1)²
            BigInteger d = fk.multiply(fk).add(fk1.multiply(fk1));

            if ((n & 1) == 0) {
                return new BigInteger[]{ c, d };
            } else {
                return new BigInteger[]{ d, c.add(d) };
            }
        }

        @Override
        public void calcular() {
            try (var timer = new Cronometro(nombre)) {
                BigInteger resultado = helper(limite)[0];

                if (impresion == Impresion.ULTIMO) {
                    System.out.println(limite + " : " + resultado);
                }
            }
        }
    }

    // ── Main ──────────────────────────────────────────────────────────────────
    // Nota: FibonacciCache se comenta porque almacena 500.000 números Fibonacci
    // en RAM, causando OutOfMemoryError. Las otras tres implementaciones son
    // más eficientes en memoria y funcionan sin problemas.
    // Si quieres activar FibonacciCache: reduce LIMITE o ejecuta con -Xmx4g

    public static void main(String[] args) {
        // new FibonacciCache().calcular();
        new FibonacciIterativo("FibonacciIterativo",        false).calcular();
        new FibonacciIterativo("FibonacciIterativoMemSwap", true ).calcular();
        new FibonacciDoblado  ("FibonacciDoblado"               ).calcular();
    }
}