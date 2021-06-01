
import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine
from models.Ingredient import Ingredient
db = MongoEngine()


class IngredientDetail(Ingredient):
    quantity = db.IntField(required=True)


class RecipeDetail(gj.Document):
    recipeId = db.SequenceField()
    name = db.StringField(required=True)
    photos = db.StringField()
    description = db.StringField(required=True)
    avgRating = db.DecimalField(required=True)
    totalRating = db.IntField()
    ingredients = db.ListField(db.ReferenceField(IngredientDetail))
    totalLike = db.IntField()
    totalTime = db.IntField()

    meta = {'collection': 'Updated_Recipes'}
