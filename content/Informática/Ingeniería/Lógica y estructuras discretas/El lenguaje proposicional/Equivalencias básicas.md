Para poder reemplazar en $X$ una subfórmula $Y_{1}$ por otra equivalente $Y_{2}$ hay que disponer de estas equivalencias básicas de partida $Y_{1}\equiv Y_{2}$. El siguiente ejemplo recopila equivalencias comprobables sobre tabla de verdad, como puede ser: $p\lor (q\land p)\equiv p$. Las equivalencias del ejemplo se generalizan posteriormente como esquemas de equivalencia, como ocurre con $Y \lor (Z\land Y)\equiv Y$.

Doble negación, idempotencia, identidad, absorción, complementación, dominación

$$\begin{align*}
\neg\neg p           &\equiv p     &\qquad                         &                     \\ 
p\vee p              &\equiv p     &\qquad    p\wedge p            &\equiv p             \\  
p\vee \bot           &\equiv p     &\qquad    p\wedge \top         &\equiv p             \\
p\vee (q\wedge p)    &\equiv p     &\qquad    p\wedge (q\vee p)    &\equiv p             \\
p\vee \neg p         &\equiv \top  &\qquad    p\wedge \neg p       &\equiv \bot          \\
p\vee \top           &\equiv \top  &\qquad    p\wedge \bot         &\equiv \bot          \\
\end{align*}$$

Conmutatividad, asociatividad, distributividad, De Morgan.

$$\begin{align*}
p\vee q              &\equiv q \vee p                       &\qquad
p\wedge q            &\equiv q \wedge p                     \\
p\vee (q \vee r)     &\equiv (p\vee q) \vee r               &\qquad
p\wedge (q\wedge r)  &\equiv (p\wedge q) \wedge r           \\
p\vee (q \wedge r)   &\equiv (p\vee q) \wedge (p\vee r)     &\qquad
p\wedge (q \vee r)   &\equiv (p\wedge q) \vee (p\wedge r)   \\
\neg (p\vee q)       &\equiv (\neg p \wedge \neg q)         &\qquad
\neg(p\wedge q)      &\equiv (\neg p\vee \neg q)            \\
\end{align*}$$

Condicional, bicondicional

$$\begin{align*}
p\rightarrow q       &\equiv \neg p\vee q                             &\qquad 
p\rightarrow q       &\equiv \neg q \rightarrow \neg p                  \\
p\leftrightarrow q   &\equiv (p\wedge q) \vee (\neg p\wedge \neg q)   &\qquad
p\leftrightarrow q   &\equiv (p\rightarrow q) \wedge (q\rightarrow p)   \\ 
\end{align*}$$