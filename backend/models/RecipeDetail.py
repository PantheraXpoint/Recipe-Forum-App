import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine
from models.Ingredient import Ingredient
from models.Photo import Photo
from models.Profile import Profile, Creator
from models.RecipePreview import RecipePreview
from bson import json_util

db = MongoEngine()

class IngredientDetail(Ingredient):
    quantity = db.IntField(required=True)

    # @property
    # def serialize(self):
    #     return {
    #         "name": self.name,
    #         "quantity" : self.quantity,
    #         "unit" : self.unit
    #     }

class Step(db.EmbeddedDocument):
    content = db.StringField(required=True)
    photos = db.ListField(db.ListField(db.EmbeddedDocumentField(Photo))) #list of list?

class RecipeDetail(gj.Document):
    id = db.SequenceField()
    _id = db.IntField()
    name = db.StringField(required=True)
    description = db.StringField(required=True)
    level = db.StringField()
    TypeID = db.IntField(default=0)
    totalTime = db.IntField()
    
    avgRating = db.FloatField(required=True)
    totalView = db.IntField(required=True,default=0)
    totalRating = db.IntField(default=0)
    totalLike = db.IntField(default=0)

    steps = db.ListField(db.EmbeddedDocumentField(Step))
    photos = db.ListField(db.ListField(db.EmbeddedDocumentField(Photo)))
    ingredients = db.ListField(db.EmbeddedDocumentField(IngredientDetail))
    creator = db.EmbeddedDocumentField(Creator)

    meta = {
        'collection': 'complete_recipe_detail',
        'indexes': [
            {'fields': ['$name'],
            'default_language': 'english',
            'weights': {'name': 10}
            }
        ]
    }

    #unused fields
    servings = db.IntField()
    hasVideo = db.BooleanField()
    url = db.StringField()
    videoUrl = db.StringField()
    hasCooked = db.BooleanField()
    hasLiked = db.BooleanField()
    createdOn = db.IntField()
    totalCook = db.IntField()
    urlRewrite = db.StringField()

    def checkCreator(self,username):
        if self.creator.username == username:
            return 1
        return 0

    def generatePreview(self):
        return RecipePreview( 
            Id=self.id,
            Name=self.name,
            AvgRating=self.avgRating,
            Img= self.getThumbnail(),
            Level= self.level,
            TotalTime = self.totalTime,
            TotalView = self.totalView,
            TotalLiked = self.totalLike,
            TotalRating = self.totalRating
        )

    # def get_ingredients(self):
    #     return self__ingredients

    def get_photos(self):
        return json_util( self.photos)

    def get_steps(self):
        return json_util( self.steps)

    def getId(self):
        return json_util( self.id)

    def getThumbnail(self):
        return self.photos[0][0]["url"]
