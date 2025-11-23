# Student Housing Rent Predictor

## Mission
My mission is to simplify and streamline the process of student housing search and settlement in Rwanda by providing accurate rental price predictions. I aim to make the process faster, more informed, and reliable, with the specific goal of helping at least 200 students find suitable housing by 2027.


## Dataset
Since there is no public dataset for student housing in Rwanda, I used a Kaggle dataset: **[Ghana House Rental Dataset](https://www.kaggle.com/datasets/epigos/ghana-house-rental-dataset)**.

**Instructions:**  
- Download the dataset from Kaggle.  
- Place the CSV file as `house_rentals.csv` under:

linear_regression_model/summative/linear_regression/


This dataset contains listings with features like bedrooms, bathrooms, square footage, location, property condition, furnishing status, amenities, and other attributes. It provides enough variety to train regression models effectively.

**Key Features Used in My Model:**

- **Numeric:**  
  `bathrooms`, `bedrooms`, `square_feet`, `latitude`, `longitude`

- **Categorical:**  
  `category` (home, short_term),  
  `condition` (new, used),  
  `is_furnished` (Yes, No),  
  `parking_space` (Yes, No),  
  `amenities` (WiFi, Gym etc.),  
  `region` (Downtown, Suburbs, Campus Area, City Center),  
  `locality` (North, South, East, West, Central)

**Visualizations:**

1. **Correlation Heatmap**  
   Shows which features strongly correlate with rent.  
   ![Correlation Heatmap](images/correlation_heatmap.png)

2. **Bedrooms vs Rent Scatter Plot**  
   Visualizes how rental prices vary with the number of bedrooms.  
   ![Scatter Plot](images/bedrooms_vs_rent.png)


## Models
I experimented with multiple regression models to predict rental prices:

1. **Gradient Descent Linear Regression** – optimized iteratively by minimizing loss.  
2. **Linear Regression (scikit-learn)** – standard least-squares method.  
3. **Decision Tree Regressor** – captures nonlinear patterns in the data.  
4. **Random Forest Regressor** – ensemble method that improves accuracy and reduces overfitting.

The **Random Forest Regressor** performed best (lowest MSE). I saved this model as `best_model.pkl`, along with `scaler.pkl` and `feature_names.pkl` for deployment.

**Prediction Flow:**
- The Flutter frontend sends JSON input to the API.
- The API validates and scales numeric features, encodes categorical features, and ensures multi-select amenities are properly handled.
- The trained model predicts rent using the prepared inputs.
- The API returns the predicted rent to the frontend.

## API Endpoint
The API is publicly available and tested with Swagger UI:

**POST** `https://summative-mobile-app-regression-gh.onrender.com/predict`

**Example Input:**

{
  "bathrooms": 2,
  "bedrooms": 3,
  "square_feet": 850,
  "latitude": 1.9579,
  "longitude": 30.1127,
  "category": "home",
  "condition": "new",
  "is_furnished": "Yes",
  "parking_space": "Yes",
  "amenities": "WiFi,Gym",
  "region": "Downtown",
  "locality": "Central"
}


**Example Output:**

{
  "predicted_rent": 450.0,
  "error": null
}


**Swagger UI:** [https://summative-mobile-app-regression-gh.onrender.com/docs](https://summative-mobile-app-regression-gh.onrender.com/docs)


## Flutter Mobile App

### Installation

1. **Clone the repository:**

git clone `https://github.com/PapiWinnie/Summative_Mobile_App_Regression_GH.git`


2. **Set up Python virtual environment for backend (optional but recommended):**

python -m venv .venv
# On Windows
.venv\Scripts\activate
# On macOS/Linux
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt


3. **Download the dataset** as mentioned above and place it at:

linear_regression_model/summative/linear_regression/apartments_for_rent_classified_10K.csv

4. **Run the Flutter app on an emulator or device:**

flutter pub get
flutter run


### Features Implemented

* Input fields for all model variables.
* Multi-select amenities support.
* **Predict** button to trigger API call.
* Display area shows predicted rent or error messages if inputs are invalid.
* Clean, organized, and user-friendly layout.



## Demo Video

* Loom doesn't allow to me download my video, hence I had to screen record the loom video. In case the youtube video recording is blury, here is the direct loom link [Loom Video Link](https://www.loom.com/share/fc244de9633e4e17a233a20530298b2a)

[ Youtube Demo – 5 Minutes](https://youtu.be/0CTYHea3kJM)

* Demonstrates the mobile app making predictions and API Swagger UI tests.
* Shows model creation, training, and performance evaluation (MSE for Linear Regression, Decision Tree, and Random Forest).
* Explains why Random Forest was selected based on dataset characteristics and model performance.

