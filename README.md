#Shaft-Design-Failure-Analysis-MATLAB
 Shaft Design & Failure Analysis Using MATLAB

A MATLAB-based engineering tool for the **design, stress analysis, failure analysis, and optimization of mechanical shafts** subjected to combined bending and torsional loading.

This project applies concepts from **Machine Design, Strength of Materials, Failure Theories, Fatigue Analysis, and Numerical Methods** to develop an automated shaft-design solution.

---

PROJECT OVERVIEW

Mechanical shafts are commonly subjected to simultaneous **bending moments and torsional loads** during power transmission. Incorrect shaft sizing can result in excessive deformation, yielding, fatigue failure, or sudden fracture.

This project develops a MATLAB program that evaluates shaft performance under specified operating conditions and determines the **minimum safe shaft diameter** based on the required factor of safety.

The program can calculate:

* Transmitted torque
* Bending stress
* Torsional shear stress
* Von Mises stress
* Principal stresses
* Factor of safety
* Failure criteria
* Minimum safe shaft diameter
* Fatigue safety using Goodman/Soderberg approaches
* Engineering plots for design evaluation

---
#OBJECTIVE

The main objectives of this project are:

1. Calculate shaft torque from power and rotational speed.
2. Analyze the effect of bending and torsional loading.
3. Calculate bending and torsional stresses.
4. Determine equivalent Von Mises stress.
5. Evaluate shaft safety using different failure theories.
6. Determine the minimum required shaft diameter.
7. Perform basic fatigue analysis.
8. Automate the design calculations using MATLAB.
9. Generate engineering plots for design interpretation.
10. Provide a reusable computational tool for preliminary shaft design.

---

# Engineering Concepts Used

## 1. Power-Torque Relationship

The transmitted torque is calculated using:


P= 2PiNT/60


Therefore,


T = 60p/2PiN


where:

* P= Power in watts
* N = Rotational speed in RPM
* T = Torque in N·m

---

#2. BENDING STRESS

For a solid circular shaft:


sigma_b = 32M/pi d^3


where:

* M = Bending moment
* d = Shaft diameter



# 3. Torsional Shear Stress


tau = 16T/pi d^3


where:

* T= Torque
* d = Shaft diameter

---

### 4. Von Mises Stress

For combined bending and torsion:


sigma_{vm} =
sqrt{sigma_b^2 + 3tau^2}


The shaft is considered safe when:


sigma_{vm} <=frac{S_y}{n}


where:

* S_y = Yield strength
* n = Required factor of safety

---

#  Failure Theories

The project evaluates shaft safety using multiple failure criteria.

### Maximum Principal Stress Theory

The maximum principal stress is compared with the allowable stress.

### Maximum Shear Stress Theory — Tresca

The maximum shear stress criterion is used to evaluate yielding.

### Distortion Energy Theory — Von Mises

The Von Mises criterion is used for determining equivalent stress under combined loading.

The results from different theories can be compared to understand their effect on shaft sizing.



##  Fatigue Analysis

Rotating shafts can experience cyclic bending stresses, making fatigue an important design consideration.

The project can be extended to include:

* Alternating stress
* Mean stress
* Endurance strength
* Ultimate tensile strength
* Goodman criterion
* Soderberg criterion
* S-N curve
* Fatigue safety factor

### Goodman Relation


\frac{\sigma_a}{S_e}
+
\frac{\sigma_m}{S_{ut}}
\leq
\frac{1}{n}
$$

where:

* \(\sigma_a\) = Alternating stress
* \(\sigma_m\) = Mean stress
* \(S_e\) = Endurance strength
* \(S_{ut}\) = Ultimate tensile strength
* \(n\) = Factor of safety

---

#  Project Workflow

```text
             START
               │
               ▼
       Enter Design Inputs
               │
               ▼
      Calculate Shaft Torque
               │
               ▼
      Determine Shaft Loading
               │
               ▼
     Calculate Bending Moment
               │
               ▼
      Calculate Bending Stress
               │
               ▼
     Calculate Torsional Stress
               │
               ▼
      Calculate Von Mises Stress
               │
               ▼
        Calculate FOS
               │
               ▼
       Check Design Safety
          /           \
        NO             YES
        │               │
        ▼               ▼
 Increase Diameter   Safe Diameter
        │               │
        └───────┬───────┘
                ▼
        Fatigue Analysis
                │
                ▼
        Generate Results
                │
                ▼
               END
```

---

# 📁 Repository Structure

```text
Shaft-Design-Failure-Analysis-MATLAB/
│
├── README.md
│
├── MATLAB/
│   ├── shaft_design.m
│   ├── stress_analysis.m
│   ├── failure_analysis.m
│   ├── fatigue_analysis.m
│   └── shaft_optimization.m
│
├── Results/
│   ├── stress_vs_diameter.png
│   ├── fos_vs_diameter.png
│   ├── torque_vs_speed.png
│   └── SN_curve.png
│
├── Documentation/
│   └── Project_Report.pdf
│
└── LICENSE
```

---

#  Software Requirements

* MATLAB R2022a or later
* MATLAB basic plotting functionality

Optional:

* MATLAB Optimization Toolbox
* MATLAB Symbolic Math Toolbox

---

#  How to Run

### Step 1 — Clone the repository

```bash
git clone https://github.com/yourusername/Shaft-Design-Failure-Analysis-MATLAB.git
```

### Step 2 — Open MATLAB

Open MATLAB and navigate to the project directory.

### Step 3 — Open the main script

```text
MATLAB/shaft_design.m
```

### Step 4 — Enter design parameters

Typical inputs include:

```text
Power
RPM
Bending Moment
Material Properties
Required Factor of Safety
```

### Step 5 — Run the MATLAB program

The program calculates the stresses and determines the minimum safe shaft diameter.

---

#  Example Design Parameters

| Parameter              |   Example Value |
| ---------------------- | --------------: |
| Power                  |           10 kW |
| Speed                  |        1000 RPM |
| Maximum Bending Moment |        1.2 kN·m |
| Material               | AISI 1045 Steel |
| Yield Strength         |         530 MPa |
| Ultimate Strength      |         625 MPa |
| Required FOS           |               2 |

These values are provided as an example and can be modified by the user.

---

#  Expected Outputs

The MATLAB program generates:

### Stress Analysis

* Bending stress
* Torsional shear stress
* Von Mises stress
* Principal stresses

### Design Analysis

* Minimum safe shaft diameter
* Factor of safety
* Allowable stress
* Failure-theory comparison

### Graphical Results

* Von Mises stress vs shaft diameter
* Factor of safety vs shaft diameter
* Torque vs RPM
* S-N curve
* Fatigue safety factor vs diameter

---

#  Sample Output

```text
========================================
       SHAFT DESIGN ANALYSIS
========================================

Power                  : 10.00 kW
Speed                  : 1000 RPM
Torque                 : 95.49 N-m

Required FOS           : 2.00

Minimum Safe Diameter  : XX.XX mm

Bending Stress         : XX.XX MPa
Torsional Stress       : XX.XX MPa
Von Mises Stress       : XX.XX MPa

Design Status          : SAFE
========================================
```

> The final numerical results depend on the selected loading conditions, material properties, and design assumptions.

---

#  Applications

This type of analysis can be applied to:

* Power transmission shafts
* Gearbox shafts
* Automotive drive shafts
* Machine-tool shafts
* Pump shafts
* Conveyor shafts
* Industrial rotating machinery
* Turbomachinery components

---

#  Key Features

*  Automated shaft sizing
*  Combined bending and torsion analysis
*  Von Mises stress calculation
*  Tresca failure analysis
*  Principal stress analysis
*  Factor-of-safety calculation
*  Fatigue analysis
*  Diameter optimization
*  MATLAB visualization
*  Modular program structure

---

#  Skills Demonstrated

### Mechanical Engineering

* Machine Design
* Strength of Materials
* Shaft Design
* Failure Analysis
* Fatigue Analysis
* Stress Analysis

### Software

* MATLAB
* Numerical Computation
* Engineering Visualization
* Algorithm Development

### Engineering Analysis

* Bending Analysis
* Torsional Analysis
* Failure Theory
* Design Optimization

---

# 🔮 Future Improvements

The project can be further developed by adding:

1. **MATLAB App Designer GUI**
2. Automatic **SFD and BMD generation**
3. Gear and pulley force calculations
4. Bearing reaction calculations
5. Keyway stress concentration
6. Stress concentration factors
7. Shaft deflection analysis
8. Critical speed analysis
9. Goodman and Soderberg fatigue analysis
10. Automatic material selection
11. Optimization for minimum weight
12. 3D shaft visualization
13. Import of CAD geometry
14. Comparison with FEA results from ANSYS/SolidWorks Simulation

---

#  Author

**Madhu Lekkala**

Mechanical Engineering Student

### Areas of Interest

* Mechanical Design
* R&D
* CAD/CAE
* MATLAB
* Failure Analysis
* Engineering Simulation

---

#  Disclaimer

This project is intended for **educational and preliminary engineering analysis**. Actual industrial shaft design should consider applicable design standards, detailed loading conditions, stress concentrations, manufacturing processes, material variability, fatigue data, dynamic effects, and appropriate safety requirements.

---

#  Project Goal

> **To develop a computational engineering tool that combines mechanical design theory with MATLAB-based numerical analysis to evaluate and optimize shaft performance under realistic loading conditions.**
