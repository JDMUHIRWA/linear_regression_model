# African American Student Academic Success Predictor

## 🎯 Mission Statement

This project predicts academic success (GPA) for African American high school students by analyzing study habits, parental involvement, and extracurricular participation. The goal is to identify key factors that contribute to academic achievement, supporting targeted educational interventions and personalized learning strategies.

---

## 📊 Dataset Description

The dataset contains detailed information on 2,392 high school students, including demographics, study habits, parental involvement, extracurricular activities, and academic performance. The analysis focuses on African American students (Ethnicity = 1) to provide actionable insights for this group.

- **Source:** [Kaggle - Student Performance Factors Dataset](https://www.kaggle.com/datasets/rabieelkharoua/students-performance-dataset)
- **Author:** Rabie El Kharoua
- **License:** CC BY 4.0
- **Type:** Synthetic dataset for educational purposes
- **Size:** 2,392 students × 15 features

**Key Features:**
- Student Demographics: Age (15-18), Gender, Ethnicity
- Academic Metrics: Weekly study hours, absences, current GPA, grade classification
- Family Support: Parental education level, parental support intensity
- Activities: Tutoring, extracurricular activities, sports, music, volunteering
- **Target Variable:** GPA (2.0-4.0 scale)

---

## 🏗️ Project Structure

```
linear_regression_model/
│
├── summative/
│   ├── linear_regression/
│   │   ├── multivariate.ipynb         # Main analysis notebook
│   │   ├── best_model.pkl             # Saved best model
│   │   ├── scaler.pkl                 # Saved scaler
│   │   ├── feature_names.pkl          # Saved feature names
│   │   ├── student_performance.csv    # Dataset
│   ├── API/
│   │   ├── api.py                     # FastAPI application
│   │   ├── requirements.txt           # Python dependencies
│   ├── gpa_app/
│   │   ├── lib/
│   │   │   ├── main.dart              # Flutter app main code
│   │   └── ...                        # Other Flutter app files
│
└── README.md                          # Project documentation
```

---

## 📈 Exploratory Data Analysis

- **Correlation Heatmap:** Visualizes relationships between features and GPA.
- **Feature Distributions:** Histograms for key variables (study time, absences, etc.).
- **Scatter Plot:** Actual vs. Predicted GPA for Linear Regression.

---

## 🤖 Model Training & Evaluation

Three regression models were trained and compared:
- **Linear Regression**
- **Random Forest**
- **Decision Tree**

| Model               | Train MSE | Test MSE | Test R² |
|---------------------|-----------|----------|---------|
| **Linear Regression** ✅ | 0.0361    | 0.0359   | **0.9567** |
| Random Forest       | 0.0057    | 0.0514   | 0.9379  |
| Decision Tree       | 0.0000    | 0.0877   | 0.8940  |

- **Best Model:** Linear Regression (lowest test MSE, highest R²)
- **Model, scaler, and feature names saved for deployment**
- **Single-row prediction and scatter plot included in notebook**

---

## 🌐 API Deployment

- **Framework:** FastAPI (Python)
- **Endpoints:** `/predict`, `/health`, `/model-info`
- **CORS:** Enabled for frontend integration
- **Input Validation:** Pydantic models with type and range constraints
- **Swagger UI:** [https://linear-regression-model-ofxu.onrender.com/docs](https://linear-regression-model-ofxu.onrender.com/docs)
- **Live Prediction Endpoint:** [https://linear-regression-model-ofxu.onrender.com/predict](https://linear-regression-model-ofxu.onrender.comm/predict)

**Example Request:**
```json
POST /predict
{
  "age": 16,
  "gender": 1,
  "ethnicity": 1,
  "parental_education": 3,
  "study_time_weekly": 12.5,
  "absences": 3,
  "tutoring": 1,
  "parental_support": 3,
  "extracurricular": 1,
  "sports": 1,
  "music": 0,
  "volunteering": 1,
  "grade_class": 2
}
```

**Example Response:**
```json
{
  "predicted_gpa": 3.45,
  "grade_category": "B",
  "confidence_level": "High",
  "success_factors": {
    "study_time": "Moderate positive impact",
    "parental_support": "Strong support system",
    "attendance": "Excellent attendance",
    "activities": "Well-rounded engagement"
  }
}
```

---

## 📱 Mobile Application

- **Technology:** Flutter (Dart)
- **Features:**
  - Modern UI with gradient design
  - Input form with validation for all model features
  - Button to trigger prediction
  - Output display with predicted GPA, grade, and success factors
  - Error handling and navigation

**How to Run:**
1. Install Flutter SDK and dependencies
2. Update API endpoint in `lib/main.dart`
3. Run `flutter pub get`
4. Launch with `flutter run`

---

## 🎥 Demo Video

- Demonstrates:
  - Jupyter notebook model training and evaluation
  - API testing with Swagger UI
  - Flutter mobile app making predictions
  - Presenter on camera, clear explanation of model performance and deployment

---

## 🛠️ Technologies Used

- **Machine Learning:** Python, scikit-learn, pandas, numpy, matplotlib, seaborn
- **API:** FastAPI, Pydantic, Uvicorn, CORS
- **Mobile:** Flutter, Dart, HTTP package
- **Deployment:** Render
- **Visualization:** Matplotlib, Seaborn

---

## 📈 Key Insights

1. Linear Regression outperformed tree-based models (R² = 0.9567)
2. Study time and parental support are the strongest predictors of GPA
3. Extracurricular balance and attendance patterns significantly impact academic performance
4. Family education level shows moderate correlation with student outcomes

---

## 🔍 Educational Impact

- **School Counselors:** Early identification of at-risk students
- **Educators:** Targeted intervention strategies
- **Parents:** Understand factors influencing academic success
- **Students:** Self-assessment and improvement
- **Researchers:** Analyze educational equity patterns

---

## 📝 License

- **Project:** MIT License
- **Dataset:** CC BY 4.0 (Kaggle)

---

## 👨‍💻 Author

**Your Name**  
*Muhirwa Harerimana & MLOps Student*

---

*Developed as part of academic coursework on predictive modeling for educational success in underrepresented communities.*