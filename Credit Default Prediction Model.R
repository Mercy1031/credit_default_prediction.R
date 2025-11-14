# ============================================================
# Credit Default Prediction Model (Logistic Regression in R)
# Author: Gbenga Adeyinka
# ============================================================

# -------------------------------
# 1. Install & Load Packages
# -------------------------------
# install.packages("tidyverse")
# install.packages("caret")
# install.packages("pROC")

library(tidyverse)
library(caret)
library(pROC)

# -------------------------------
# 2. Load Dataset
# -------------------------------
credit_data <- read.csv("c:/Users/user/Desktop/CreditRisk_Data1.csv",
                        stringsAsFactors = FALSE)

# View structure
str(credit_data)
summary(credit_data)

# -------------------------------
# 3. Preprocessing
# -------------------------------

# Remove ID column (1st column)
refined_data <- credit_data[, -1]

# Convert target to factor
refined_data$DEFAULT <- as.factor(refined_data$DEFAULT)

# Convert categorical variables
refined_data$EDUCATION <- as.factor(refined_data$EDUCATION)

# Impute missing numeric values using median
refined_data <- refined_data %>%
  mutate(across(where(is.numeric),
                ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))

# Normalize numeric variables
numeric_vars <- sapply(refined_data, is.numeric)
refined_data[numeric_vars] <- scale(refined_data[numeric_vars])

# -------------------------------
# 4. Train-Test Split
# -------------------------------
set.seed(123)
train_index <- createDataPartition(refined_data$DEFAULT, p = 0.8, list = FALSE)

train_data <- refined_data[train_index, ]
test_data  <- refined_data[-train_index, ]

# -------------------------------
# 5. Logistic Regression Model
# -------------------------------
log_model <- glm(DEFAULT ~ ., data = train_data, family = binomial)
summary(log_model)

# -------------------------------
# 6. Model Evaluation
# -------------------------------

# Predict probabilities
log_probs <- predict(log_model, newdata = test_data, type = "response")

# Convert to class labels (threshold = 0.5)
log_preds <- ifelse(log_probs > 0.5, "1", "0")
log_preds <- as.factor(log_preds)

# Confusion Matrix
confusionMatrix(log_preds, test_data$DEFAULT)

# ROC Curve + AUC
roc_obj <- roc(test_data$DEFAULT, log_probs)
plot(roc_obj, main = "ROC Curve - Logistic Regression")
auc(roc_obj)

# -------------------------------
# 7. Predicting New Applicants
# -------------------------------
new_applicants <- read.csv("c:/Users/user/Desktop/CreditRisk_Verify.csv",
                           stringsAsFactors = FALSE)

# Apply preprocessing
new_applicants$EDUCATION <- as.factor(new_applicants$EDUCATION)

# Predict default probability
new_applicants$default_prob <- predict(log_model,
                                       newdata = new_applicants,
                                       type = "response")

# Risk flag
new_applicants$risk_flag <- ifelse(new_applicants$default_prob > 0.6,
                                   "High Risk", "Low Risk")

head(new_applicants)

# -------------------------------
# 8. Odds Ratios & Confidence Intervals
# -------------------------------

exp_coef <- exp(coef(log_model))
conf_int <- exp(confint(log_model))

summary_table <- data.frame(
  Variable = names(exp_coef),
  OddsRatio = exp_coef,
  CI_Low = conf_int[,1],
  CI_High = conf_int[,2],
  p_value = summary(log_model)$coefficients[,4]
)

summary_table <- summary_table[order(-abs(summary_table$OddsRatio)), ]
print(summary_table)
