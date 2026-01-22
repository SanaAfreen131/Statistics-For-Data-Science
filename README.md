# 📈 Sigmoid-like Function vs. Fisher z Transformation  
### *Statistics for Data Science – Final Project*

---

## 🧠 Technical Skills & Competencies

**Statistics & Probability**
- Standard Normal Distribution (PDF & CDF)
- Gauss Error Function (erf)
- Fisher z Transformation & Inverse
- Sampling Distribution of Pearson Correlation Coefficient

**Mathematical Modeling**
- Closed-form approximation design
- Sigmoid-based functional modeling
- Parameter tuning and optimization
- Analytical interpretability vs. numerical accuracy trade-offs

**Numerical Analysis & Optimization**
- Total Squared Error minimization
- Maximum Absolute Error (Chebyshev criterion)
- Error bounds and approximation benchmarking
- Change of variables and inverse-function derivation

**Data Science Tools & Methods**
- Numerical integration and simulation
- Comparative visualization of approximations
- Performance evaluation and sensitivity analysis
- Mathematical typesetting with LaTeX

> *Implementation typically relies on Python (NumPy, SciPy, Matplotlib) or R for numerical experiments.*

---

## 📌 Project Overview

This project proposes and evaluates a **novel Sigmoid-like approximation function** as a **more accurate and interpretable alternative** to the classical **Fisher z transformation** for approximating:

- the **Standard Normal Cumulative Distribution Function (CDF)**  
- the **Gauss error function (erf)**  

The core objective is to achieve an **optimal balance between numerical precision and analytical simplicity**, a key requirement in **statistical inference, causal modeling, and data science applications**.

With an optimized coefficient **k ≈ 1.701**, the proposed approximation significantly improves upon Fisher’s method.

---

## 🚀 Key Contributions

✔️ Introduced an explicit Sigmoid-like approximation for Φ(x)  
✔️ Optimized the function using rigorous error minimization criteria  
✔️ Demonstrated superior performance across the entire real line  
✔️ Preserved analytical interpretability while improving accuracy  

---

## 🔬 Methodology

### Approximation Strategy
The Sigmoid-like function \( S_Y(k, x) \) is designed to approximate the standard normal CDF \( \Phi(x) \) while remaining analytically tractable.

### Optimization Criteria
The parameter **k** is optimized using two complementary approaches:

- **Total Squared Error Minimization**  
\[
\int_{-\infty}^{\infty} \big(S_Y(k,x) - \Phi(x)\big)^2 \, dx
\]

- **Maximum Absolute Error Minimization (Chebyshev criterion)**  
\[
\max_x \left| S_Y(k,x) - \Phi(x) \right|
\]

A change of variables \( y = \frac{x}{\sqrt{2}} \) enables direct comparison with the error function (erf).

---

## 📊 Results & Performance

| Method                          | Optimal k | Total Squared Error | Max Absolute Error |
|--------------------------------|-----------|----------------------|--------------------|
| Fisher z (baseline)            | 2.0       | ~0.00352             | ~0.0442            |
| **Sigmoid-like (proposed)**    | **1.701** | **~0.000314**        | **~0.0095**        |

### 📉 Performance Gains
- **11.2× lower total squared error**
- **4.65× lower maximum absolute error**

✅ The proposed method consistently outperforms Fisher’s transformation for  
**k ∈ (1.390, 2.000)**  
✅ Best empirical accuracy achieved at **k = 1.701**

---

## 🎯 Applications & Impact

- More accurate confidence intervals for Pearson correlation coefficients
- Simplified analytical expressions in statistical inference
- Improved interpretability for **causal modeling** and **explainable AI (XAI)**
- Robust closed-form approximations for:
  - Finance and risk modeling
  - Econometrics
  - Machine learning theory

---

## 📚 References

1. Fisher, R. A. (1915). *Frequency Distribution of the Values of the Correlation Coefficient*. **Biometrika**  
2. Yang et al. (2016). *New Sigmoid-like Function Better than Fisher z Transformation*. **Communications in Statistics**  
3. Yun, B. I. (2009). *Approximation to the Cumulative Normal Distribution Using Tanh-Based Functions*

---

## 🧑‍🎓 Authors

- **Sana Afreen**  
- Naomi Cedeño-Manrique  
- Luis Pinto-Alemán  

🎓 *MSc in Data Science and Business Informatics*  
📍 Goethe University Frankfurt  
📅 Completed: **May 29, 2024**

---

> 💡 **Why this matters**  
In data science, finance, and regulation-heavy domains, **interpretable yet accurate mathematical approximations** are essential for trustworthy modeling, transparent decision-making, and reproducible research.
