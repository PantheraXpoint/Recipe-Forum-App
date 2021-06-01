import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine
db = MongoEngine()


class RecipePreview(gj.Document):
    recipeId = db.SequenceField()
    name = db.StringField(required=True)
    avgRating = db.DecimalField(required=True)
    photos = db.StringField()
    level = db.StringField()
    totalRating = db.IntField()
    totalLike = db.IntField()
    totalTime = db.IntField()

    meta = {'collection': 'recipe_filter'}
