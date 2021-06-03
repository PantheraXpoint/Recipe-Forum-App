import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine
from models.Ingredient import Ingredient
from models.Photo import Photo
from models.Profile import Profile
db = MongoEngine()

class IngredientDetail(Ingredient):
    quantity = db.IntField(required=True)

class Step(gj.Document):
    content = db.StringField(required=True)
    photos = db.ListField(db.ListField(db.ReferenceField(Photo))) #list of list?
    
class RecipeDetail(gj.Document):
    _id = db.ObjectIdField()
    recipeId = db.SequenceField()
    id = db.IntField()
    name = db.StringField(required=True)
    description = db.StringField(required=True)
    photos = db.ListField(db.ListField(db.ReferenceField(Photo))) #list of list?
    ingredients = db.ListField(db.ReferenceField(IngredientDetail))
    steps = db.ListField(db.ReferenceField(Step))
    avgRating = db.DecimalField(required=True)
    totalRating = db.IntField()
    totalLike = db.IntField()
    totalTime = db.IntField()

    meta = {'collection': 'recipe_detail'}
