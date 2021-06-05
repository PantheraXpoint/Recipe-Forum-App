import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine
db = MongoEngine()

class RecipePreview(gj.Document):
    # recipeId = db.SequenceField()
    Id = db.IntField(required=True)
    Name = db.StringField(required=True)
    Img = db.StringField()
    Level = db.StringField(default="Dễ")
    # totalRating = db.IntField()
    AvgRating = db.DecimalField(required=True)
    TotalView = db.IntField(default=0)
    TotalLiked = db.IntField(defaul=0)
    TotalTime = db.IntField(default=0)

    meta = {'collection': 'recipe_filter'}
