# prediction_1.py

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import pandas as pd
import numpy as np
import joblib
import os
import sys
import gdown

# Download model from Google Drive if not present
def download_models():
    """Download model files from Google Drive if they don't exist locally"""
    
    # Download best_model.pkl (105MB file)
    if not os.path.exists("best_model.pkl"):
        print("Downloading best_model.pkl from Google Drive...")
        try:
            gdown.download(
                "https://drive.google.com/uc?id=1XVAsBCYOa6RwtCSvjsqH57ypEhP9ouUH",
                "best_model.pkl",
                quiet=False
            )
            print("best_model.pkl downloaded successfully!")
        except Exception as e:
            print(f"Error downloading best_model.pkl: {e}", file=sys.stderr)
            raise e
    else:
        print("best_model.pkl already exists locally.")
    
    # Note: Add similar blocks for scaler.pkl and feature_names.pkl if they're also large
    # For now, assuming they're small enough to be in the repo

# Download models before loading
download_models()

# Load model, scaler, and features
try:
    model = joblib.load("best_model.pkl")
    scaler = joblib.load("scaler.pkl")
    feature_names = joblib.load("feature_names.pkl")
    print("All models loaded successfully!")
except Exception as e:
    print(f"Error loading model/scaler/features: {e}", file=sys.stderr)
    raise e

# Initialize FastAPI
app = FastAPI(
    title="Student Housing Rent Predictor",
    description="Predicts apartment rent prices based on features like bedrooms, bathrooms, floor area, location, and amenities.",
    version="1.0"
)

# Enable CORS for all origins (for Flutter or mobile clients)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define Pydantic input model
class RentInput(BaseModel):
    bedrooms: float = Field(..., ge=0, le=20)
    bathrooms: float = Field(..., ge=0, le=20)
    floor_area: float = Field(..., ge=50, le=10000)
    lat: float = Field(..., description="Latitude of property")
    lng: float = Field(..., description="Longitude of property")
    
    category: str = Field(..., description="Property category (e.g., 'home', 'short_term')")
    condition: str = Field(..., description="Property condition (e.g., 'new', 'used')")
    is_furnished: str = Field(..., description="Furnishing status ('Yes'/'No')")
    parking_space: str = Field(..., description="Parking available ('Yes'/'No')")
    amenities: str = Field(..., description="Amenities summary or main feature")
    region: str = Field(..., description="Region of property")
    locality: str = Field(..., description="Locality within the region")

# Helper function: encode categorical
def encode_categorical(input_data: dict) -> pd.DataFrame:
    """
    Encodes input into one-hot encoded DataFrame compatible with trained features.
    Missing features are set to 0.
    """
    encoded = {col: 0 for col in feature_names if col != 'price'}

    # Numeric features
    numeric_features = ['bedrooms', 'bathrooms', 'floor_area', 'lat', 'lng']
    for feature in numeric_features:
        if feature in encoded:
            encoded[feature] = input_data.get(feature, 0)

    # Map categorical inputs
    mapping = {
        'category': f"category_{input_data['category']}",
        'condition': f"condition_{input_data['condition']}",
        'is_furnished': f"is_furnished_{input_data['is_furnished']}",
        'parking_space': f"parking_space_{input_data['parking_space']}",
        'amenities': f"amenities_{input_data['amenities']}",
        'region': f"region_{input_data['region']}",
        'locality': f"locality_{input_data['locality']}"
    }

    for key, col in mapping.items():
        if col in encoded:
            encoded[col] = 1

    return pd.DataFrame([encoded])

# Prediction endpoint
@app.post("/predict")
def predict_rent(data: RentInput):
    try:
        input_dict = data.dict()

        # --- Validation for quantitative features ---
        if input_dict['bedrooms'] < 1:
            return {"error": "Invalid input: bedrooms must be >= 1"}
        if input_dict['bathrooms'] < 1:
            return {"error": "Invalid input: bathrooms must be >= 1"}
        if input_dict['floor_area'] <= 0:
            return {"error": "Invalid input: floor_area must be > 0"}
        if not (-90 <= input_dict['lat'] <= 90):
            return {"error": "Invalid input: latitude must be between -90 and 90"}
        if not (-180 <= input_dict['lng'] <= 180):
            return {"error": "Invalid input: longitude must be between -180 and 180"}

        # Encode categorical features
        input_df = encode_categorical(input_dict)

        # Scale features
        scaled_df = scaler.transform(input_df)

        # Predict
        prediction = model.predict(scaled_df)
        return {"predicted_rent": float(prediction[0])}

    except Exception as e:
        return {"error": str(e)}

# Root endpoint
@app.get("/")
def root():
    return {
        "message": "Welcome to the Student Housing Rent Prediction API. Use /predict with POST request."
    }

# Optional local run
if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("prediction_1:app", host="0.0.0.0", port=port, reload=True)