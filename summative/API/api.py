import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import joblib
import numpy as np
# import the models
base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
model_path = os.path.join(base_dir, "linear_regression", "best_model.pkl")
scaler_path = os.path.join(base_dir, "linear_regression", "scaler.pkl")
feature_names_path = os.path.join(base_dir, "linear_regression", "feature_names.pkl")
# Initialize FastAPI app
app = FastAPI(
    title="African American Student GPA Predictor",
    description="Predicts GPA for African American" \
    " high school students based on academic and social factors",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify actual origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load models and scaler at startup
try:
    model = joblib.load(model_path)
    scaler = joblib.load(scaler_path)
    feature_names = joblib.load(feature_names_path)
    print("Models loaded successfully!")
except FileNotFoundError as e:
    print(f"Error loading models: {e}")
    model = None
    scaler = None
    feature_names = None

# Pydantic model for request validation
class StudentData(BaseModel):
    # Note: Based on your sample, you have these 13 features (excluding StudentID)
    age: int = Field(..., ge=15, le=18, description="Student age (15-18 years)")
    gender: int = Field(..., ge=0, le=1, description="Gender: 0=Male, 1=Female")
    ethnicity: int = Field(1, ge=1, le=1, description="Ethnicity: 1=African American (fixed)")
    parental_education: int = Field(..., ge=0, le=4, description="Parental education level (0-4)")
    study_time_weekly: float = Field(..., ge=0, le=20, description="Weekly study hours (0-20)")
    absences: int = Field(..., ge=0, le=30, description="Number of absences (0-30)")
    tutoring: int = Field(..., ge=0, le=1, description="Tutoring: 0=No, 1=Yes")
    parental_support: int = Field(..., ge=0, le=4, description="Parental support level (0-4)")
    extracurricular: int = Field(..., ge=0, le=1,
                                 description="Extracurricular activities: 0=No, 1=Yes")
    sports: int = Field(..., ge=0, le=1, description="Sports participation: 0=No, 1=Yes")
    music: int = Field(..., ge=0, le=1, description="Music activities: 0=No, 1=Yes")
    volunteering: int = Field(..., ge=0, le=1, description="Volunteering: 0=No, 1=Yes")
    grade_class: int = Field(..., ge=0, le=4, description="Current grade class (0-4)")

    class Config:
        schema_extra = {
            "example": {
                "age": 16,
                "gender": 1,
                "ethnicity": 1,
                "parental_education": 3,
                "study_time_weekly": 10.5,
                "absences": 5,
                "tutoring": 1,
                "parental_support": 3,
                "extracurricular": 1,
                "sports": 1,
                "music": 0,
                "volunteering": 1,
                "grade_class": 2
            }
        }

class PredictionResponse(BaseModel):
    predicted_gpa: float
    grade_category: str
    confidence_level: str
    success_factors: dict

@app.get("/")
async def root():
    return {
        "message": "African American Student GPA Predictor API",
        "version": "1.0.0",
        "endpoints": {
            "/predict": "POST - Make GPA prediction",
            "/health": "GET - Health check",
            "/docs": "GET - API documentation"
        }
    }

@app.get("/health")
async def health_check():
    model_status = "loaded" if model is not None else "not loaded"
    return {
        "status": "healthy",
        "model_status": model_status,
        "scaler_status": "loaded" if scaler is not None else "not loaded"
    }

def gpa_to_grade(gpa: float) -> str:
    """Convert GPA to letter grade"""
    if gpa >= 3.5:
        return "A"
    elif gpa >= 3.0:
        return "B"
    elif gpa >= 2.5:
        return "C"
    elif gpa >= 2.0:
        return "D"
    else:
        return "F"

def get_confidence_level(gpa: float) -> str:
    """Determine confidence level based on GPA range"""
    if 2.0 <= gpa <= 4.0:
        return "High"
    elif 1.5 <= gpa < 2.0 or 4.0 < gpa <= 4.5:
        return "Medium"
    else:
        return "Low"

def analyze_success_factors(student_data: StudentData) -> dict:
    """Analyze key success factors for the student"""
    factors = {}
    
    # Study time impact
    if student_data.study_time_weekly >= 15:
        factors["study_time"] = "High positive impact"
    elif student_data.study_time_weekly >= 8:
        factors["study_time"] = "Moderate positive impact"
    else:
        factors["study_time"] = "Low impact - consider increasing"
    
    # Parental support
    if student_data.parental_support >= 3:
        factors["parental_support"] = "Strong support system"
    elif student_data.parental_support >= 2:
        factors["parental_support"] = "Moderate support"
    else:
        factors["parental_support"] = "Limited support"
    
    # Attendance
    if student_data.absences <= 5:
        factors["attendance"] = "Excellent attendance"
    elif student_data.absences <= 15:
        factors["attendance"] = "Good attendance"
    else:
        factors["attendance"] = "Attendance concerns"
    
    # Extracurricular balance
    activity_count = sum([
        student_data.extracurricular,
        student_data.sports,
        student_data.music,
        student_data.volunteering
    ])
    
    if activity_count >= 2:
        factors["activities"] = "Well-rounded engagement"
    elif activity_count == 1:
        factors["activities"] = "Some extracurricular involvement"
    else:
        factors["activities"] = "Consider joining activities"
    
    return factors

@app.post("/predict", response_model=PredictionResponse)
async def predict_gpa(student_data: StudentData):
    """Predict GPA for African American high school student"""
    
    if model is None or scaler is None:
        raise HTTPException(
            status_code=500,
            detail="Model not loaded. Please check server configuration."
        )
    try:
        # Convert student data to feature array
        # Order should match your training features
        features = np.array([[
            student_data.age,
            student_data.gender,
            student_data.ethnicity,
            student_data.parental_education,
            student_data.study_time_weekly,
            student_data.absences,
            student_data.tutoring,
            student_data.parental_support,
            student_data.extracurricular,
            student_data.sports,
            student_data.music,
            student_data.volunteering,
            student_data.grade_class
        ]])
        # Scale features (since Linear Regression was your best model)
        features_scaled = scaler.transform(features)
        # Make prediction
        predicted_gpa = float(model.predict(features_scaled)[0])
        # Ensure GPA is within reasonable bounds
        predicted_gpa = max(0.0, min(4.0, predicted_gpa))
        # Get grade category
        grade_category = gpa_to_grade(predicted_gpa)
        # Get confidence level
        confidence_level = get_confidence_level(predicted_gpa)
        # Analyze success factors
        success_factors = analyze_success_factors(student_data)
        return PredictionResponse(
            predicted_gpa=round(predicted_gpa, 2),
            grade_category=grade_category,
            confidence_level=confidence_level,
            success_factors=success_factors
        )   
    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail=f"Prediction error: {str(e)}"
        )

@app.get("/model-info")
async def get_model_info():
    """Get information about the trained model"""
    if model is None:
        raise HTTPException(status_code=500, detail="Model not loaded")
    
    return {
        "model_type": "Linear Regression",
        "test_r2_score": 0.9566,
        "test_mse": 0.0359,
        "features_count": len(feature_names) if feature_names else 13,
        "target": "GPA (Grade Point Average)",
        "focus": "African American High School Students"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)