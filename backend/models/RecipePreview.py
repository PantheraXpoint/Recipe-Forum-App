import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine
from models.RecipeDetail import RecipeDetail
db = MongoEngine()

class RecipePreview(gj.Document):
    # recipeId = db.SequenceField()
    Id = db.SequenceField()
    Name = db.StringField(required=True)
    AvgRating = db.DecimalField(required=True)
    Img = db.StringField()
    Level = db.StringField()
    # totalRating = db.IntField()
    TotalLiked = db.IntField()
    TotalTime = db.IntField()

    meta = {'collection': 'recipe_filter'}
