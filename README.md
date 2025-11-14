# Credit Default Prediction Model (Logistic Regression in R)

This repository contains an end-to-end credit default prediction project developed in R.
The goal is to build a baseline model that predicts the probability that a customer will default on credit, helping financial institutions reduce risk and make informed lending decisions.

# Project Structure
credit-default-prediction-R/
│
├── scripts/
│     └── credit_default_prediction.R
│
├── outputs/
│     └── plots/
│           ├── roc_curve.png
│           ├── confusion_matrix.png
│           ├── default_distribution.png
│           └── variable_importance.png
│
├── data/ (optional)
│
└── README.md


# Project Overview

Financial institutions face significant losses when customers default on loans.
This project builds a logistic regression model to estimate default probability and classify customers as:

High Risk

Low Risk

The project includes:

✔ Data cleaning
✔ Missing value imputation
✔ Feature engineering
✔ Model training
✔ Model evaluation (ROC, AUC, confusion matrix)
✔ Scoring new applicants
✔ Visualizations

# Technologies Used
| Category       | Tools            |
| -------------- | ---------------- |
| Language       | **R**            |
| Data Wrangling | tidyverse, dplyr |
| Modeling       | caret, stats     |
| Evaluation     | pROC             |
| Visualization  | ggplot2          |


# Dataset
The dataset includes financial and demographic information such as:

Age

Education

Income

Credit Amount

Repayment History

Default Status (target

Target variable:
DEFAULT → 0 = No Default, 1 = Default

Preprocessing steps included:

Removing ID column

Handling missing values (median imputation)

Normalizing numeric variables

Encoding categorical variables

Train-test split (80% / 20%)

Data Preprocessing Summary
| Step                         | Action                   |
| ---------------------------- | ------------------------ |
| Remove unnecessary columns   | Yes                      |
| Encode categorical variables | Yes (DEFAULT, EDUCATION) |
| Impute missing values        | Median (numeric)         |
| Normalize numeric features   | Yes                      |
| Train-test split             | 80/20                    |


# Modeling Approach

A logistic regression classifier was built using:

glm(DEFAULT ~ ., data = train_data, family = binomial)

Evaluation metrics:

Confusion Matrix

Accuracy

Recall / Sensitivity

Specificity

ROC Curve

AUC Score


# Scoring New Applicants

A second dataset (CreditRisk_Verify.csv) was used to score new customers:

Default probability generated using predict()

Threshold > 0.60 → High Risk

Else → Low Risk

This simulates real-world credit approval workflows.

# Key Insights

Higher installment rates and Longer loan duration increase default risk.

Logistic regression provides a transparent and interpretable model

AUC score indicates robust separability between good vs. bad clients

Adjusting the probability threshold can optimize risk sensitivity

# Future Enhancements

Potential improvements:

Add Random Forest & XGBoost models for comparison

Hyperparameter tuning using caret

SMOTE / ROSE for class imbalance

Deploy as a Shiny dashboard

Add API endpoint for real-time scoring

