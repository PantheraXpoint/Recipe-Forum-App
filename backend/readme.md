# Setup

pip install Flask

pip install sqlalchemy

pip install sqlalchemy-media

python database_setup.py

# Run
python app.py

# APIs
GET/POST http://0.0.0.0:4996/recipesApi

GET/DELETE/PUT http://0.0.0.0:4996/recipesApi/<int:id>

GET http://0.0.0.0:4996/recipesApiBrowse
