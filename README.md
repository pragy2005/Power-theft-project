# Smart Grid Energy Theft and Faulty Smart Meter Detection

A machine learning and statistical analysis based project for detecting energy theft and defective smart meters in Smart Grid systems using Linear Regression techniques.

This project is based on the research paper:

"Detection of Energy Theft and Defective Smart Meters in Smart Grids Using Linear Regression"

---

# Overview

Non-Technical Losses (NTLs) such as electricity theft and faulty smart meters cause major financial losses for utility providers. Traditional detection methods require expensive manual inspections and are inefficient for large-scale smart grids.

This project implements two regression-based algorithms:

- LR-ETDM  
  (Linear Regression-Based Detection of Energy Theft and Defective Smart Meters)

- CVLR-ETDM  
  (Categorical Variable Enhanced Linear Regression Model)

These algorithms analyze smart meter consumption data to detect:
- Fraudulent consumers
- Abnormal energy usage
- Faulty smart meters
- Time-dependent energy theft patterns

---

# Objectives

- Detect energy theft using smart meter consumption data
- Identify faulty or defective smart meters
- Analyze abnormal energy consumption behavior
- Apply linear regression for anomaly detection
- Detect time-based fraud during peak/off-peak hours
- Reduce non-technical losses in smart grids

---

# Methodology

The system compares:
- Total energy supplied by the utility provider
- Total energy reported by consumers

The discrepancy is modeled using linear regression.

## Anomaly Coefficient

Each consumer is assigned an anomaly coefficient:

- aₙ = 0 → Honest consumer
- aₙ > 0 → Energy theft
- aₙ < 0 → Faulty smart meter

---

## LR-ETDM Model

The regression equation is:

a₁pₜ,₁ + a₂pₜ,₂ + ... + aₙpₜ,ₙ = yₜ

Matrix form:

P · a = y

Coefficient estimation:

a = (PᵀP)⁻¹Pᵀy

---

## CVLR-ETDM Model

To detect time-based theft, categorical variables are introduced.

- Off-peak → 0
- On-peak → 1

Extended regression equation:

a₁pₜ,₁ + ... + aₙpₜ,ₙ + b₁pₜ,₁x₁ + ... + bₙpₜ,ₙxₙ = yₜ

Combined matrix form:

[ P_off    0      ] [ a ]   =   [ y_off  ]
[ P_peak  P_peak ] [ b ]       [ y_peak ]

---

# Features

- Energy theft detection
- Faulty smart meter detection
- Peak vs off-peak fraud analysis
- Statistical validation using:
  - t-test
  - p-value analysis
- Regression-based anomaly detection
- Smart grid consumption analysis

---

# Technologies Used

- MATLAB / Python
- Linear Regression
- Statistical Analysis
- Smart Grid Concepts
- Data Analytics
- Machine Learning Concepts

---

# Project Structure

smart-grid-energy-theft-detection/

├── README.md  
├── report/  
│   └── project_report.pdf  
│  
├── dataset/  
│   └── sample_dataset.csv  
│  
├── matlab/  
│   ├── lr_etdm.m  
│   ├── cvlr_etdm.m  
│   └── visualization.m  
│  
├── results/  
│   ├── graphs/  
│   └── outputs/  
│  
└── docs/  
    └── methodology.md  

---

# Results

The proposed models successfully detect:
- Constant energy theft
- Time-dependent energy theft
- Defective smart meters
- Abnormal consumer behavior

CVLR-ETDM performs better in detecting variable and peak-time fraud patterns compared to the basic LR-ETDM model.

---

# Future Improvements

- Real-time smart grid implementation
- Privacy-preserving anomaly detection
- Noise-tolerant regression models
- Deep learning based fraud detection
- IoT integration for live monitoring

---

# Reference

Sook-Chin Yip et al.

"Detection of Energy Theft and Defective Smart Meters in Smart Grids Using Linear Regression"

Electrical Power and Energy Systems, 2017.

---

# Author

[Your Name]

Engineering Student | Smart Grid and Data Analytics Enthusiast
